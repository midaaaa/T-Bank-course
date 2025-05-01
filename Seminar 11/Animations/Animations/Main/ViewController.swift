//
//  ViewController.swift
//  Animations
//
//  Created by Дмитрий Филимонов on 01.05.2025.
//

import UIKit

extension ViewController: PresenterView {

}

class ViewController: UIViewController {
    private let presenter: Presenter
    
    private lazy var logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "iOS 18")
        image.alpha = 0
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
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.alpha = 0
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchButtonOutside), for: .touchDown)
        button.addTarget(self, action: #selector(didTouchButtonInside), for: .touchUpOutside)
        button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: .pi)
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
        animate()
    }
    
    private func setupUI() {
        view.backgroundColor = .black

        view.addSubview(logoImage)
        view.addSubview(headlineLabel)
        view.addSubview(actionButton)

        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),

            headlineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 20),
            headlineLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            actionButton.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 20),
            actionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            actionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func resetUI() {
        // перезапуск элементов с задержкой 500мс
        UIView.animate(withDuration: 0.5) {
            self.logoImage.alpha = 0
            self.headlineLabel.alpha = 0
            self.actionButton.alpha = 0
            self.logoImage.center.y -= 300
            self.logoImage.transform = .identity
            self.actionButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: .pi)
            self.actionButton.layer.cornerRadius = 8
        }
    }
    
    private func animate() {
        // Логотип опускается вниз
        UIView.animate(withDuration: 1, delay: 1) {
            //self.view.layoutIfNeeded()
            self.logoImage.alpha = 1
            self.logoImage.center.y += 300
        }
        
        // Заголовок появляется через 200мс после анимации логотипа
        UIView.animate(withDuration: 1, delay: 2.2) {
            self.headlineLabel.alpha = 1
        }
        
        // Кнопка вращается, увеличивается и появляется через 200мс после анимации заголовка
        UIView.animate(
            withDuration: 1,
            delay: 3.4,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 1,
            animations: {
                self.actionButton.alpha = 1
                self.actionButton.transform = .identity
            }
        )
        /*
        UIView.animate(
            withDuration: 1,
            delay: 3.4,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 1
        ) {
            self.actionButton.alpha = 1
            self.actionButton.transform = .identity
        }*/
    }
    
    @objc private func didTouchButtonInside() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0
        ) {
            self.actionButton.layer.cornerRadius = 8
            self.actionButton.transform = .identity
        }
    }
    
    @objc private func didTouchButtonOutside() {
        UIView.animate(withDuration: 0.2) {
            self.actionButton.layer.cornerRadius = 20
            self.actionButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    @objc private func didTapButton() {
        resetUI()
        animate()
    }
}
