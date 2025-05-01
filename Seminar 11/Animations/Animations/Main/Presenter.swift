//
//  Presenter.swift
//  Animations
//
//  Created by Дмитрий Филимонов on 01.05.2025.
//

import UIKit

protocol PresenterViewProtocol: AnyObject {
    func animateLogo()
    func animateHeadline()
    func animateActionButton()
    func resetAnimations()
    func setActionButtonEnabled(_ enabled: Bool)
}

protocol PresenterProtocol {
    func viewDidLoad()
    func didTapActionButton()
}

final class Presenter: PresenterProtocol {
    weak var view: PresenterViewProtocol?
    
    private var isAnimating = false
    
    func viewDidLoad() {
        startAnimations()
    }
    
    private enum Constants {
        static let animationDuration: TimeInterval = 1
        static let animationDelay: TimeInterval = 0.2
        static let buttonAnimationDuration: TimeInterval = 0.5
    }
    
    private func startAnimations() {
        guard !isAnimating else { return }
        isAnimating = true
        
        view?.animateLogo()
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + Constants.animationDuration + Constants.animationDelay
        ) { [weak self] in
            self?.view?.animateHeadline()
        }
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + Constants.animationDuration + Constants.animationDelay + Constants.animationDuration + Constants.animationDelay
        ) { [weak self] in
            self?.view?.animateActionButton()
            self?.view?.setActionButtonEnabled(true)
            self?.isAnimating = false
        }
    }
    
    func didTapActionButton() {
        guard !isAnimating else { return }
        isAnimating = true
        view?.setActionButtonEnabled(false)
        view?.resetAnimations()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.buttonAnimationDuration) { [weak self] in
            self?.isAnimating = false
            self?.startAnimations()
        }
    }
}
