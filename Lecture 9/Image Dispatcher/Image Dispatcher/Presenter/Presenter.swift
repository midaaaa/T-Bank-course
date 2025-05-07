//
//  Presenter.swift
//  Image Dispatcher
//
//  Created by Дмитрий Филимонов on 07.05.2025.
//

import UIKit

protocol PresenterViewProtocol: AnyObject {
    func displayImages(_ images: [UIImage?])
    func showLoading(_ isLoading: Bool)
    func updateButtonTitle(_ title: String)
    func enableButton(_ isEnabled: Bool)
    func clearImageViews()
}

protocol PresenterProtocol {
    func viewDidLoad()
    func didTapButton()
}

final class Presenter: PresenterProtocol {
    weak var view: PresenterViewProtocol?
    private let imageDownloadService: ImageDownloadProtocol
    private let imageUrls: [String]
    private var isLoading = false
    
    init(imageDownloadService: ImageDownloadProtocol, imageUrls: [String]) {
        self.imageDownloadService = imageDownloadService
        self.imageUrls = imageUrls
    }
    
    func viewDidLoad() {
        
    }
    
    private enum Constants {
        static let animationDuration: TimeInterval = 1
        
    }

    func didTapButton() {
        guard !isLoading else { return }
        
        isLoading = true
        view?.enableButton(false)
        view?.updateButtonTitle("")
        view?.showLoading(true)
        view?.clearImageViews()
        
        
        var downloadedImages: [UIImage?] = Array(repeating: nil, count: imageUrls.count)
        let group = DispatchGroup()
        
        for (index, url) in imageUrls.enumerated() {
            group.enter()
            imageDownloadService.downloadImage(from: url) { [weak self] result in
                switch result {
                case .success(let image):
                    downloadedImages[index] = image
                case .failure:
                    downloadedImages[index] = self?.errorImage()
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.showLoading(false)
            self?.view?.updateButtonTitle("Загрузить ещё раз")
            self?.view?.displayImages(downloadedImages)
            self?.view?.enableButton(true)
            self?.isLoading = false
        }
    }
    
    func getImageUrls() -> [String] {
        return imageUrls
    }
    
    private func errorImage() -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .large)
        return UIImage(systemName: "photo.badge.exclamationmark", withConfiguration: config)
    }
}
