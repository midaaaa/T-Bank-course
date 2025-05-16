//
//  Product.swift
//  Image Downloader
//
//  Created by Дмитрий Филимонов on 16.05.2025.
//

import Foundation

struct Product {
    let id: Int
    let name: String
    let price: String
    let description: String
    let imageURL: URL
}

extension Product {
    init(from dto: ProductDTO) {
        self.id = dto.id
        self.name = dto.title
        self.price = String(format: "\u{00A3} %.2f", dto.price)
        self.description = dto.description
        self.imageURL = dto.image
    }
}
