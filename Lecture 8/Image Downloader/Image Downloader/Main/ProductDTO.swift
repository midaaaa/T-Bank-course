//
//  ProductDTO.swift
//  Image Downloader
//
//  Created by Дмитрий Филимонов on 16.05.2025.
//

import Foundation

struct ProductDTO: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: URL
    let rating: RatingDTO
    
    struct RatingDTO: Codable {
        let rate: Double
        let count: Int
    }
}
