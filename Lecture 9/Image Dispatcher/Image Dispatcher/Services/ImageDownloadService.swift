//
//  ImageDownloadService.swift
//  Image Dispatcher
//
//  Created by Дмитрий Филимонов on 07.05.2025.
//

import UIKit
import Alamofire

protocol ImageDownloadProtocol {
    func downloadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class ImageDownloadService: ImageDownloadProtocol {
    private var requests: [DataRequest] = []
    
    func downloadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let request = AF.request(url, requestModifier: { $0.timeoutInterval = 5 })
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        completion(.success(image))
                    } else {
                        completion(.failure(ImageDownloadError.invalidImageData))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        requests.append(request)
    }
    
    enum ImageDownloadError: Error {
        case invalidImageData
    }
}
