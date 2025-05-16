//
//  SceneAssembler.swift
//  Image Downloader
//
//  Created by Дмитрий Филимонов on 21.04.2025.
//

import UIKit

final class SceneAssembler {
    func makeScene() -> UIViewController {
        let presenter = Presenter()
        let view = ViewController (presenter: presenter)
        presenter.view = view
        return view
    }
}
