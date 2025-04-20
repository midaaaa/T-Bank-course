//
//  Presenter.swift
//  Image Downloader
//
//  Created by Дмитрий Филимонов on 20.04.2025.
//

import UIKit

protocol PresenterView: AnyObject {
    func updateTable()
    func updateImage(_ image: UIImage, at index: Int)
    func stopAnimation()
    func updateProgress(_ progress: Float)
}

class Presenter {
    weak var view: PresenterView?
    private var products: [Product] = []
    private var imageLoader = ImageDownloader()
    private var imagesLoaded = 0
    private var totalImagesToLoad = 0
    
    func viewDidLoad() {
        getJSONs()
    }

    var productsCount: Int {
        products.count
    }
    
    func product(at index: Int) -> Product {
        products[index]
    }
    
    private func getJSONs() {
        let url = URL(string: "https://fakestoreapi.com/products")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    self.view!.stopAnimation()
                    self.view!.updateTable()
                    self.startDownload()
                }
            }
            
            if let data = data {
                print("\u{2705} Данные получены: \(data)")
                do {
                    self.products = try JSONDecoder().decode([Product].self, from: data)
                    print("\u{2705} Успешно распарсили \(self.products.count) товаров")
                } catch {
                    print("\u{274C} Ошибка парсинга: \(error)")
                }
            } else if let error = error {
                print("\u{274C} Ошибка: \(error)")
            }
        }
        task.resume()
    }
    
    private func startDownload() {
        DispatchQueue.main.async {
            self.totalImagesToLoad = self.products.count
            self.view!.updateTable()

            self.products.enumerated().forEach { index, product in
                self.loadImage(for: product, at: index)
            }
        }
    }
    
    private func loadImage(for product: Product, at index: Int) {
        imageLoader.loadImage(url: product.image, forIndex: index) { [weak self] image in
            guard let self = self, let image = image else { return }
            
            self.imagesLoaded += 1
            let progress = Float(self.imagesLoaded) / Float(self.totalImagesToLoad)
            
            print("Загружено изображение \(index + 1)/\(self.totalImagesToLoad)")
            print("Текущий прогресс: \(Int(progress * 100)) %")
            
            self.view?.updateProgress(progress)
            self.view?.updateImage(image, at: index)
        }
    }
}

class ImageDownloader: NSObject {
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
              let (index, completion) = activeDownloads[url] else { return }
        
        DispatchQueue.main.async {
            if let error = error {
                print("Ошибка загрузки: \(error)")
                completion(nil)
            } else if let data = self.receivedData[url], let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Не удалось создать изображение из данных")
                completion(nil)
            }
            
            self.activeDownloads.removeValue(forKey: url)
            self.receivedData.removeValue(forKey: url)
        }
    }
}
