//
//  SceneAssembler.swift
//  Image Dispatcher
//
//  Created by Дмитрий Филимонов on 07.05.2025.
//

import UIKit

final class SceneAssembler {
    private let imageUrls = [
        "https://images.unsplash.com/photo-1603831055494-c52b10355bcc?q=80&w=3117&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1619486049112-27a4fc547801?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1628925217319-61e69f7a8361?q=80&w=3174&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ]
    
    func makeScene() -> UIViewController {
        let imageDownloadService = ImageDownloadService()
        
        let presenter = Presenter(
            imageDownloadService: imageDownloadService,
            imageUrls: imageUrls
        )
        
        let viewController = ViewController(
            presenter: presenter
        )
        
        presenter.view = viewController

        return viewController
    }
}
