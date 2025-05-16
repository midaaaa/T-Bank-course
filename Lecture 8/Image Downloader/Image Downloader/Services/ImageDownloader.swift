//
//  ImageDownloader.swift
//  Image Downloader
//
//  Created by Дмитрий Филимонов on 16.05.2025.
//

import UIKit

final class ImageDownloader: NSObject {
    private enum Constants {
        static let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .large)
        static let errorImage = UIImage(systemName: "photo.badge.exclamationmark", withConfiguration: config)
    }
    
    private var receivedData: [URL: Data] = [:]
    private var activeDownloads: [URL: (index: Int, completion: (UIImage?) -> Void)] = [:]
    private lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    func loadImage(url: URL, forIndex index: Int, completion: @escaping (UIImage?) -> Void) {
        activeDownloads[url] = (index, completion)
        let downloadTask = downloadsSession.dataTask(with: url)
        downloadTask.resume()
    }
}

// MARK: ImageDownloader + URLSessionDataDelegate

extension ImageDownloader: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let url = dataTask.originalRequest?.url else { return }
        
        if receivedData[url] == nil {
            receivedData[url] = Data()
        }
        receivedData[url]?.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let url = task.originalRequest?.url,
              let (_, completion) = activeDownloads[url] else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let error = error {
                print("Ошибка загрузки: \(error)")
                completion(Constants.errorImage)
            } else if let data = self.receivedData[url], let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Не удалось создать изображение из данных")
                completion(Constants.errorImage)
            }
            
            self.activeDownloads.removeValue(forKey: url)
            self.receivedData.removeValue(forKey: url)
        }
    }
}
