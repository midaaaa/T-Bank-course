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
    private let imageURLs: [String]
    private var isLoading = false
    
    init(imageDownloadService: ImageDownloadProtocol, imageURLs: [String]) {
        self.imageDownloadService = imageDownloadService
        self.imageURLs = imageURLs
    }
    
    func viewDidLoad() {
        guard let view = view else { return }
        view.enableButton(true)
    }
    
    private enum Constants {
        static let buttonDelay: TimeInterval = 0.5
        
        static let errorImageSize: CGFloat = 30
    }

    func didTapButton() {
        guard !isLoading else { return }
        loadBegun()
    }
    
    private func loadBegun() {
        guard let view = view else { return }
        isLoading = true
        view.enableButton(false)
        view.updateButtonTitle("")
        view.showLoading(true)
        view.clearImageViews()
        loadImages()
    }
    
    private func loadImages() {
        var downloadedImages: [UIImage?] = Array(repeating: nil, count: imageURLs.count)
        let group = DispatchGroup()
        
        for (index, url) in imageURLs.enumerated() {
            group.enter()
            imageDownloadService.downloadImage(from: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let image):
                    downloadedImages[index] = image
                case .failure(let error):
                    downloadedImages[index] = self.errorImage()
                    self.handleError(error as! ImageDownloadService.ImageDownloadError)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.loadEnded(images: downloadedImages)
        }
    }
    
    private func loadEnded(images: [UIImage?]) {
        guard let view = self.view else { return }
        view.displayImages(images)
        view.showLoading(false)
        view.updateButtonTitle("Загрузить ещё раз")
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.buttonDelay) { [weak self] in
            guard let self = self else { return }
            view.enableButton(true)
            self.isLoading = false
        }
    }
    
    private func handleError(_ error: ImageDownloadService.ImageDownloadError) {
        let errorMessage: String
        switch error {
        case .invalidURL:
            errorMessage = "Неверный URL изображения"
        case .invalidImageData:
            errorMessage = "Невозможно преобразовать данные в изображение"
        }
        print(errorMessage)
    }
    
    private func errorImage() -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: Constants.errorImageSize, weight: .medium, scale: .large)
        return UIImage(systemName: "photo.badge.exclamationmark", withConfiguration: config)
    }
}
