//
//  ViewController.swift
//  Animations
//
//  Created by Дмитрий Филимонов on 01.05.2025.
//

import UIKit

class ViewController: UIViewController {
    private let presenter: Presenter
    
    private lazy var logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "iOS 18")
        image.alpha = 0
        image.transform = CGAffineTransform(translationX: 0, y: -Constants.logoImageMoveLength)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var headlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 36, weight: .medium)
        label.textAlignment = .center
        label.text = "Build for iOS 18"
        label.numberOfLines = 0
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get started!", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.backgroundColor = .white
        button.layer.cornerRadius = Constants.actionButtonCornerRadius
        button.alpha = 0
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchButtonOutside), for: .touchDown)
        button.addTarget(self, action: #selector(didTouchButtonInside), for: .touchUpOutside)
        button.transform = CGAffineTransform(
            scaleX: Constants.actionButtonScale,
            y: Constants.actionButtonScale
        ).rotated(by: .pi)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(presenter: Presenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    private enum Constants {
        static let headlineLabelTopInset: CGFloat = 20
        static let actionButtonTopInset: CGFloat = 40
        static let actionButtonLeadingInset: CGFloat = 30
        static let actionButtonTrailingInset: CGFloat = -30
        static let actionButtonHeight: CGFloat = 50
        
        static let logoImageMoveLength: CGFloat = 300
        
        static let actionButtonScale: CGFloat = 0.1
        static let actionButtonScaleActive: CGFloat = 0.9
        
        static let actionButtonCornerRadius: CGFloat = 8
        static let actionButtonCornerRadiusActive: CGFloat = 20
        
        static let animationDuration: TimeInterval = 1
        static let shadowDuration: TimeInterval = animationDuration / 2
        static let animationDelayShort: TimeInterval = 0.2
        static let animationDelayLong: TimeInterval = 0.4
        static let activeButtonHoldDuration: TimeInterval = 0.2
        static let activeButtonReleaseDuration: TimeInterval = activeButtonHoldDuration * 2
        
        static let activeButtonShadowRadius: CGFloat = 20
        static let activeButtonShadowOpacity: Float = 0.6
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(logoImage)
        view.addSubview(headlineLabel)
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            headlineLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor,
                constant: Constants.headlineLabelTopInset
            ),
            headlineLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            actionButton.topAnchor.constraint(
                equalTo: headlineLabel.bottomAnchor,
                constant: Constants.actionButtonTopInset
            ),
            actionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            actionButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.actionButtonLeadingInset
            ),
            actionButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constants.actionButtonTrailingInset
            ),
            actionButton.heightAnchor.constraint(equalToConstant: Constants.actionButtonHeight)
        ])
    }
    
    private func drawButtonShadow() {
        let path = UIBezierPath(
            roundedRect: actionButton.bounds,
            cornerRadius: actionButton.layer.cornerRadius
        )
        actionButton.layer.shadowPath = path.cgPath
        actionButton.layer.shadowColor = UIColor.white.cgColor
        actionButton.layer.shadowOpacity = Constants.activeButtonShadowOpacity
        actionButton.layer.shadowRadius = Constants.activeButtonShadowRadius
        
        // анимация появления тени после завершения анимации появления и поворота
        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowAnimation.fromValue = 0
        shadowAnimation.toValue = actionButton.layer.shadowOpacity
        shadowAnimation.duration = Constants.shadowDuration
        actionButton.layer.add(shadowAnimation, forKey: "buttonShadow")
    }
    
    @objc private func didTouchButtonInside() {
        // анимация отпускания кнопки
        UIView.animate(
            withDuration: Constants.activeButtonReleaseDuration,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0
        ) {
            self.actionButton.layer.cornerRadius = Constants.actionButtonCornerRadius
            self.actionButton.transform = .identity
        }
    }
    
    @objc private func didTouchButtonOutside() {
        // анимация нажатия(удерживания) кнопки
        UIView.animate(withDuration: Constants.activeButtonHoldDuration) {
            self.actionButton.layer.cornerRadius = Constants.actionButtonCornerRadiusActive
            self.actionButton.transform = CGAffineTransform(
                scaleX: Constants.actionButtonScaleActive,
                y: Constants.actionButtonScaleActive
            )
        }
    }
    
    @objc private func didTapButton() {
        presenter.didTapActionButton()
    }
}

extension ViewController: PresenterViewProtocol {
    // Логотип опускается вниз
    func animateLogo() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.logoImage.alpha = 1
            self.logoImage.transform = .identity
        }
    }
    
    // Заголовок появляется через 200мс после анимации логотипа
    func animateHeadline() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.headlineLabel.alpha = 1
        }
    }
    
    // Кнопка вращается, увеличивается и появляется через 200мс после анимации заголовка
    func animateActionButton() {
        UIView.animate(
            withDuration: Constants.animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1,
            animations: {
                self.actionButton.alpha = 1
                self.actionButton.transform = .identity
            },
            completion: { _ in
                self.drawButtonShadow()
            }
        )
    }
    
    // перезапуск элементов (все анимации проигрываются одновременно назад)
    func resetAnimations() {
        UIView.animate(withDuration: Constants.shadowDuration) {
            self.logoImage.alpha = 0
            self.headlineLabel.alpha = 0
            self.actionButton.alpha = 0
            self.logoImage.transform = CGAffineTransform(translationX: 0, y: -Constants.logoImageMoveLength)
            self.actionButton.transform = CGAffineTransform(
                scaleX: Constants.actionButtonScale,
                y: Constants.actionButtonScale
            ).rotated(by: .pi)
            self.actionButton.layer.shadowOpacity = 0
            self.actionButton.layer.cornerRadius = Constants.actionButtonCornerRadius
        }
    }
    
    func setActionButtonEnabled(_ enabled: Bool) {
        actionButton.isUserInteractionEnabled = enabled
    }
}
