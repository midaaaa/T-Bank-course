//
//  ProductViewCell.swift
//  Image Downloader
//
//  Created by Дмитрий Филимонов on 21.04.2025.
//

import UIKit

class ProductViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageIcon = UIImageView()
    private let priceLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "ProductViewCell")
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 2
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 3
        imageIcon.contentMode = .scaleToFill
        imageIcon.backgroundColor = .lightGray
        priceLabel.font = UIFont.systemFont(ofSize: 16)
        priceLabel.numberOfLines = 1
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(imageIcon)
        contentView.addSubview(priceLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        imageIcon.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageIcon.widthAnchor.constraint(equalToConstant: 100),
            imageIcon.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: imageIcon.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func setValues(title: String, description: String, price: Double) {
        titleLabel.text = title
        descriptionLabel.text = description
        priceLabel.text = "\u{00A3} " + String(format: "%g", price)
    }
    
    func setImage(image: UIImage) {
        imageIcon.image = image
    }
}
