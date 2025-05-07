//
//  ViewController.swift
//  Image Dispatcher
//
//  Created by Дмитрий Филимонов on 23.04.2025.
//

import UIKit

final class ViewController: UIViewController {
    private let presenter: Presenter

    private enum Constants {
        static let imageViewsCount: Int = 3
        
        static let imageViewHeightMultiplier: CGFloat = 0.25
        static let imageViewWidthMultiplier: CGFloat = 0.9
        static let imageViewGap: CGFloat = 5
        
        static let buttonHeight: CGFloat = 60
        static let buttonGap: CGFloat = 15
        static let buttonCornerRadius: CGFloat = 15
    }
    
    private lazy var imageViews: [UIImageView] = (0..<Constants.imageViewsCount).map { _ in
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        return imageView
    }
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitle("Загрузить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }()
    
    private lazy var spinnerIcon: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .black
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        return spinner
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
    
    private func setupUI() {
        view.backgroundColor = .black
        
        for (index, imageView) in imageViews.enumerated() {
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                imageView.heightAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.heightAnchor,
                    multiplier: Constants.imageViewHeightMultiplier
                ),
                imageView.widthAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.widthAnchor,
                    multiplier: Constants.imageViewWidthMultiplier
                ),
            ])
            
            if index == 0 {
                imageView.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: Constants.imageViewGap
                ).isActive = true
            } else {
                imageView.topAnchor.constraint(
                    equalTo: imageViews[index-1].bottomAnchor,
                    constant: Constants.imageViewGap
                ).isActive = true
            }
        }

        NSLayoutConstraint.activate([
            downloadButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.buttonGap
            ),
            downloadButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.buttonGap
            ),
            
            spinnerIcon.centerXAnchor.constraint(equalTo: downloadButton.centerXAnchor),
            spinnerIcon.centerYAnchor.constraint(equalTo: downloadButton.centerYAnchor)
        ])

    }
    
    @objc private func didTapButton() {
        presenter.didTapButton()
    }
}

extension ViewController: PresenterViewProtocol {
    func displayImages(_ images: [UIImage?]) {
        for (index, image) in images.enumerated() {
            imageViews[index].isHidden = false
            imageViews[index].image = image
            
            if image?.isSymbolImage == true {
                imageViews[index].contentMode = .center
                imageViews[index].tintColor = .white
            } else {
                imageViews[index].contentMode = .scaleAspectFill
            }
        }
    }
    
    func enableButton(_ isEnabled: Bool) {
        downloadButton.isUserInteractionEnabled = isEnabled
    }
    
    func updateButtonTitle(_ title: String) {
        downloadButton.setTitle(title, for: .normal)
    }
    
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            spinnerIcon.startAnimating()
        } else {
            spinnerIcon.stopAnimating()
        }
    }
    
    func clearImageViews() {
        imageViews.forEach {
            $0.isHidden = true
            $0.image = nil
        }
    }
}
