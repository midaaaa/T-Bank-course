//
//  Presenter.swift
//  Image Downloader
//
//  Created by Дмитрий Филимонов on 20.04.2025.
//

import UIKit

protocol PresenterView: AnyObject {
    func updateTable()
    func updateImage(_ image: UIImage, at index: Int)
    func stopAnimation()
    func updateProgress(_ progress: Float)
}

final class Presenter {
    weak var view: PresenterView?
    private var products: [Product] = []
    private var productsDTO: [ProductDTO] = []
    private var imageLoader = ImageDownloader()
    private var imagesLoaded = 0
    private var totalImagesToLoad = 0
    
    func viewDidLoad() {
        getJSONs()
    }

    var productsCount: Int {
        products.count
    }
    
    func product(at index: Int) -> Product {
        products[index]
    }
    
    private func getJSONs() {
        let url = URL(string: "https://fakestoreapi.com/products")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            defer {
                DispatchQueue.main.async {
                    guard let view = self.view else { return }
                    view.stopAnimation()
                    self.startDownload()
                }
            }
            
            if let data = data {
                print("\u{2705} Данные получены: \(data)")
                do {
                    self.productsDTO = try JSONDecoder().decode([ProductDTO].self, from: data)
                    self.products = self.productsDTO.map { Product(from: $0) }
                    print("\u{2705} Успешно распарсили \(self.products.count) товаров")
                } catch {
                    print("\u{274C} Ошибка парсинга: \(error)")
                }
            } else if let error = error {
                print("\u{274C} Ошибка: \(error)")
            }
        }
        task.resume()
    }
    
    private func startDownload() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let view = self.view else { return }
            self.totalImagesToLoad = self.products.count
            view.updateTable()

            self.products.enumerated().forEach { index, product in
                self.loadImage(for: product, at: index)
            }
        }
    }
    
    private func loadImage(for product: Product, at index: Int) {
        imageLoader.loadImage(url: product.imageURL, forIndex: index) { [weak self] image in
            guard let self = self, let image = image, let view = self.view else { return }
            
            self.imagesLoaded += 1
            let progress = Float(self.imagesLoaded) / Float(self.totalImagesToLoad)
            
            print("Загружено изображение \(index + 1)/\(self.totalImagesToLoad)")
            print("Текущий прогресс: \(Int(progress * 100)) %")
            
            view.updateProgress(progress)
            view.updateImage(image, at: index)
        }
    }
}
