//
//  SceneAssembler.swift
//  Image Dispatcher
//
//  Created by Дмитрий Филимонов on 07.05.2025.
//

import UIKit

final class SceneAssembler {
    func makeScene() -> UIViewController {
        let imageDownloadService = ImageDownloadService()
        let presenter = Presenter(
            imageDownloadService: imageDownloadService,
            imageURLs: ImageURLs.URLs
        )
        let viewController = ViewController(
            presenter: presenter
        )
        presenter.view = viewController
        return viewController
    }
}
