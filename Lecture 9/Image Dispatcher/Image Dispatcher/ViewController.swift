//
//  ViewController.swift
//  Image Dispatcher
//
//  Created by Дмитрий Филимонов on 23.04.2025.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    private var imageViews: [UIImageView] = []
    private var downloadButton: UIButton?
    private var spinnerIcon: UIActivityIndicatorView?
    private let imageUrls = [
        "https://images.unsplash.com/photo-1603831055494-c52b10355bcc?q=80&w=3117&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1619486049112-27a4fc547801?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1628925217319-61e69f7a8361?q=80&w=3174&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        for _ in 0..<3 {
            let imageView = UIImageView()
            imageView.backgroundColor = .black
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.isHidden = true
            view.addSubview(imageView)
            imageViews.append(imageView)
        }
        
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitle("Загрузить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        view.addSubview(button)
        downloadButton = button
        
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .black
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinnerIcon = spinner
        
        for (index, imageView) in imageViews.enumerated() {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 350),
                imageView.heightAnchor.constraint(equalToConstant: 200)
            ])
            
            if index == 0 {
                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            } else {
                imageView.topAnchor.constraint(equalTo: imageViews[index-1].bottomAnchor, constant: 30).isActive = true
            }
        }
            
        guard let downloadButton = downloadButton, let spinnerIcon = spinnerIcon else { return }
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        spinnerIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            downloadButton.heightAnchor.constraint(equalToConstant: 60),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            downloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            spinnerIcon.centerXAnchor.constraint(equalTo: downloadButton.centerXAnchor),
            spinnerIcon.centerYAnchor.constraint(equalTo: downloadButton.centerYAnchor)
        ])

    }
    
    @objc private func didTapButton() {
        guard let spinnerIcon = spinnerIcon else { return }
        imageViews.forEach {
            $0.isHidden = true
            $0.image = nil
        }
        spinnerIcon.startAnimating()
        downloadButton?.isEnabled = false
        downloadButton?.setTitle("", for: .normal)

        let group = DispatchGroup()
        
        for (index, urlString) in imageUrls.enumerated() {
            group.enter()
            let request = AF.request(urlString, requestModifier: { $0.timeoutInterval = 5 })
            
            request.responseData { [weak self] response in
                defer { group.leave() }
                
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imageViews[index].image = image
                            self?.imageViews[index].contentMode = .scaleAspectFill
                        }
                    } else {
                        print("Невозможно создать изображение \(urlString)")
                        self?.setErrorImage(for: index)
                    }
                case .failure(let error):
                    print("Ошибка загрузки: \(error.localizedDescription)")
                    self?.setErrorImage(for: index)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            spinnerIcon.stopAnimating()
            self?.downloadButton?.isEnabled = true
            self?.downloadButton?.setTitle("Загрузить ещё раз", for: .normal)
            self?.imageViews.forEach { $0.isHidden = false }
        }
    }

    private func setErrorImage(for index: Int) {
        DispatchQueue.main.async { [weak self] in
            let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .large)
            let errorImage = UIImage(systemName: "photo.badge.exclamationmark", withConfiguration: config)
            self?.imageViews[index].image = errorImage
            self?.imageViews[index].tintColor = .white
            self?.imageViews[index].contentMode = .center
        }
    }
}
