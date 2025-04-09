//
//  ProductPageController.swift
//  T-Bank product page UI
//
//  Created by Дмитрий Филимонов on 07.04.2025.
//

import UIKit

class ProductPageViewController: UIViewController {

    struct Product {
        let image: UIImage?
        let brandName: String
        let name: String
        let price: String
        let oldPrice: String?
    }
    
    private let products: [Product] = [
        Product(image: UIImage(named: "ProductImage1"), brandName: "Balenciaga", name: "Le Cagole", price: "216 000 \u{20BD}", oldPrice: "240 000 \u{20BD}"),
        Product(image: UIImage(named: "ProductImage2"), brandName: "ENFANTS RICHES D\u{45}\u{301}PRIM\u{45}\u{301}S", name: "Italian Romance Denim Jacket", price: "370 000 \u{20BD}", oldPrice: nil),
        Product(image: UIImage(named: "ProductImage3"), brandName: "Apple", name: "iPhone 16 Pro Max", price: "120 000 \u{20BD}", oldPrice: "150 000 \u{20BD}"),
        Product(image: UIImage(named: "ProductImage4"), brandName: "Louis Vuitton", name: "Petit Palais", price: "2 499 \u{0024}", oldPrice: "2 999 \u{0024}"),
        Product(image: UIImage(named: "ProductImage5"), brandName: "Killian", name: "Angel's share 50ml", price: "30 600 \u{20BD}", oldPrice: nil)
    ]
    private var productImage: UIImageView?
    private var productBrandName: UILabel?
    private var productName: UILabel?
    private var productPrice: UILabel?
    private var productOldPrice: UILabel?
    private var productIndex: Int = 0
    private var mainButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupProductPage()
        setupConstraints()
        updateProduct()
    }

    private func setupProductPage() {
        view.backgroundColor = .black
        
        let image = UIImageView()
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        view.addSubview(image)
        productImage = image
        
        let brandNameLabel = UILabel()
        brandNameLabel.textColor = .lightGray
        brandNameLabel.font = .systemFont(ofSize: 15)
        brandNameLabel.numberOfLines = 0
        view.addSubview(brandNameLabel)
        productBrandName = brandNameLabel
        
        let nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.numberOfLines = 0
        view.addSubview(nameLabel)
        productName = nameLabel
        
        let priceLabel = UILabel()
        priceLabel.textColor = .white
        priceLabel.font = UIFont.boldSystemFont(ofSize: 25)
        view.addSubview(priceLabel)
        productPrice = priceLabel
        
        let oldPriceLabel = UILabel()
        oldPriceLabel.textColor = .gray
        oldPriceLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(oldPriceLabel)
        productOldPrice = oldPriceLabel
        
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitle("Показать следующий товар", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        view.addSubview(button)
        mainButton = button
    }
    
    @objc private func didTapButton() {
        productIndex = (productIndex + 1) % products.count
        updateProduct()
    }
    
    private func updateProduct() {
        guard let productImage, let productBrandName, let productName, let productPrice, let productOldPrice else { return }
        let product = products[productIndex]
        
        productImage.image = product.image
        productBrandName.text = product.brandName
        productName.text = product.name
        productPrice.text = product.price
        
        guard let price = product.oldPrice, !price.isEmpty else {
            productOldPrice.isHidden = true
            return
        }
        
        let strikeThroughText = NSAttributedString(
            string: product.oldPrice ?? "",
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                         .strikethroughColor: UIColor.gray.withAlphaComponent(0.7)]
        )
        productOldPrice.attributedText = strikeThroughText
        productOldPrice.isHidden = false
    }
    
    private func setupConstraints() {
        guard let productImage, let productBrandName, let productName, let productPrice, let productOldPrice, let mainButton else { return }
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productBrandName.translatesAutoresizingMaskIntoConstraints = false
        productName.translatesAutoresizingMaskIntoConstraints = false
        productPrice.translatesAutoresizingMaskIntoConstraints = false
        productOldPrice.translatesAutoresizingMaskIntoConstraints = false
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            productImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor),
            
            productBrandName.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 10),
            productBrandName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            productBrandName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            productName.topAnchor.constraint(equalTo: productBrandName.bottomAnchor, constant: 8),
            productName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            productName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            productPrice.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 10),
            productPrice.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            productOldPrice.centerYAnchor.constraint(equalTo: productPrice.centerYAnchor),
            productOldPrice.leadingAnchor.constraint(equalTo: productPrice.trailingAnchor, constant: 5),
            
            mainButton.heightAnchor.constraint(equalToConstant: 60),
            mainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            mainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
}
