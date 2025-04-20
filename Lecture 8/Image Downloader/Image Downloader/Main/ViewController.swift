//
//  ViewController.swift
//  Image Downloader
//
//  Created by Дмитрий Филимонов on 16.04.2025.
//

import UIKit

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: URL
    let rating: Rating
    
    struct Rating: Codable {
        let rate: Double
        let count: Int
    }
}

extension ViewController: PresenterView {
    func updateTable() {
        tableView.reloadData()
    }
    
    func updateImage(_ image: UIImage, at index: Int) {
        productImages[index] = image
        let indexPath = IndexPath(row: index, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? ProductViewCell {
            cell.setImage(image: image)
        }
    }
    
    func stopAnimation() {
        stopSpinner()
        showProgressBar()
    }
    
    func updateProgress(_ progress: Float) {
        progressBar.setProgress(progress, animated: true)
    }
}

class ViewController: UIViewController {
    private let presenter: Presenter
    private var spinner = UIActivityIndicatorView()
    private var progressBar = UIProgressView()
    private var tableView = UITableView()
    private var TableViewCell = UITableViewCell()
    private var productImages: [Int: UIImage] = [:]
    
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
        startSpinner()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progress = 0
        progressBar.isHidden = true
        view.addSubview(progressBar)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProductViewCell.self, forCellReuseIdentifier: "ProductViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 116
        tableView.rowHeight = 116
        view.addSubview(tableView)
        
        spinner.style = .large
        spinner.color = .black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            progressBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            tableView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func startSpinner() {
        spinner.startAnimating()
    }
    
    private func stopSpinner() {
        spinner.stopAnimating()
    }
    
    private func showProgressBar() {
        progressBar.isHidden = false
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.productsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductViewCell", for: indexPath) as! ProductViewCell
        let product = presenter.product(at: indexPath.row)
        cell.setValues(title: product.title,
                       description: product.description,
                       price: product.price)

        if let image = productImages[indexPath.row] {
            cell.setImage(image: image)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = presenter.product(at: indexPath.row)
        print("Нажата ячейка \(product.id)")
    }
}
