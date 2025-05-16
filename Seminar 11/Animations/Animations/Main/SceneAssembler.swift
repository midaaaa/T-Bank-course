//
//  SceneAssembler.swift
//  Animations
//
//  Created by Дмитрий Филимонов on 01.05.2025.
//

import UIKit

final class MainAssembler {
    func makeScene() -> UIViewController {
        let presenter = Presenter()
        let view = ViewController (presenter: presenter)
        presenter.view = view
        return view
    }
}
