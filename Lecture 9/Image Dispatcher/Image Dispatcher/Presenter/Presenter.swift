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
        guard !isLoading, let view = view else { return }
        isLoading = true
        view.enableButton(false)
        view.updateButtonTitle("")
        view.showLoading(true)
        view.clearImageViews()
        
        var downloadedImages: [UIImage?] = Array(repeating: nil, count: imageURLs.count)
        let group = DispatchGroup()
        
        for (index, url) in imageURLs.enumerated() {
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
            guard let self = self, let view = self.view else { return }
            view.displayImages(downloadedImages)
            view.showLoading(false)
            view.updateButtonTitle("Загрузить ещё раз")
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.buttonDelay) {
                view.enableButton(true)
                self.isLoading = false
            }
        }
    }
    
    private func errorImage() -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: Constants.errorImageSize, weight: .medium, scale: .large)
        return UIImage(systemName: "photo.badge.exclamationmark", withConfiguration: config)
    }
}
