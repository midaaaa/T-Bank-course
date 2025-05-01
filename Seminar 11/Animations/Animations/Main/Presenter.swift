//
//  Presenter.swift
//  Animations
//
//  Created by Дмитрий Филимонов on 01.05.2025.
//

import UIKit

protocol PresenterView: AnyObject {

}

class Presenter {
    weak var view: PresenterView?
    
    func viewDidLoad() {
        
    }
}
