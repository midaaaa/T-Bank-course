//
//  ViewController.swift
//  Image Downloader
//
//  Created by Дмитрий Филимонов on 16.04.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private enum Constants {
        static let rowHeight: CGFloat = 116
        static let progressBarGap: CGFloat = 15
        static let tableViewGap: CGFloat = 8
    }
    
    private let presenter: Presenter
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progressViewStyle = .default
        progressBar.isHidden = true
        view.addSubview(progressBar)
        return progressBar
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductViewCell.self, forCellReuseIdentifier: "ProductViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = Constants.rowHeight
        tableView.estimatedRowHeight = Constants.rowHeight
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
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
        view.addSubview(progressBar)
        view.addSubview(tableView)
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressBar.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.progressBarGap
            ),
            progressBar.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.progressBarGap
            ),
            
            tableView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: Constants.tableViewGap),
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

// MARK: ViewController + PresenterView

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

// MARK: ViewController + UITableViewDataSource + UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.productsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductViewCell", for: indexPath) as! ProductViewCell
        let product = presenter.product(at: indexPath.row)
        cell.setValues(title: product.name,
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
