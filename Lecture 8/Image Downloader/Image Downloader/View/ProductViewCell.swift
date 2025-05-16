//
//  ProductViewCell.swift
//  Image Downloader
//
//  Created by Дмитрий Филимонов on 21.04.2025.
//

import UIKit

class ProductViewCell: UITableViewCell {
    private enum Constants {
        static let titleLabelFont: CGFloat = 16
        static let titleLabelNumberOfLines: Int = 2
        
        static let descriptionLabelFont: CGFloat = 12
        static let descriptionLabelNumberOfLines: Int = 3
        
        static let priceLabelFont: CGFloat = 16
        static let priceLabelNumberOfLines: Int = 1
        
        static let imageIconSize: CGFloat = 100
        static let imageIconGap: CGFloat = 8
        static let horizontalGap: CGFloat = 8
        static let verticalGap: CGFloat = 2
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleLabelFont, weight: .bold)
        titleLabel.numberOfLines = Constants.titleLabelNumberOfLines
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.descriptionLabelFont)
        descriptionLabel.numberOfLines = Constants.descriptionLabelNumberOfLines
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private lazy var imageIcon: UIImageView = {
        let imageIcon = UIImageView()
        imageIcon.contentMode = .scaleAspectFit
        imageIcon.backgroundColor = .white
        imageIcon.tintColor = .systemRed
        imageIcon.translatesAutoresizingMaskIntoConstraints = false
        return imageIcon
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: Constants.priceLabelFont)
        priceLabel.numberOfLines = Constants.priceLabelNumberOfLines
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "ProductViewCell")
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(imageIcon)
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            imageIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.imageIconGap),
            imageIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.imageIconGap),
            imageIcon.widthAnchor.constraint(equalToConstant: Constants.imageIconSize),
            imageIcon.heightAnchor.constraint(equalToConstant: Constants.imageIconSize),
            
            titleLabel.topAnchor.constraint(equalTo: imageIcon.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor, constant: Constants.horizontalGap),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalGap),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.verticalGap),
            priceLabel.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor, constant: Constants.horizontalGap),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalGap),
            
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Constants.verticalGap),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor, constant: Constants.horizontalGap),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalGap)
        ])
    }
    
    func setValues(title: String, description: String, price: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        priceLabel.text = price
    }
    
    func setImage(image: UIImage) {
        imageIcon.image = image
    }
}
