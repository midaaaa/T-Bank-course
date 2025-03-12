import Foundation

enum Genre {
    case fiction
    case novel
    case poems
}

struct Book {
    let title: String
    let author: String
    let price: Double
    let genre: Genre
}

class Library {
    var books: [Book] = []

    func addBook (_ book: Book) {
        books.append(book)
    }
    
    func filterBooks(by genre: Genre) -> [Book] {
        return books.filter { $0.genre == genre }
    }
    
    func filterBooks(byName name: String) -> [Book] {
        return books.filter { $0.title.contains(name) }
    }
}

enum Parameter {
    case title
    case price
}

class User {
    let name: String
    let discount: Double
    var cart: [Book] = []
    
    init(name: String, discount: Double) {
        self.name = name
        self.discount = discount
    }
    
    func addToCart(_ books: [Book]) {
        cart.append(contentsOf: books)
    }
    
    func totalPrice() -> String {
        return "\(cart.reduce(0) { $0 + $1.price } * (1 - discount / 100))\u{20BD}"
    }

    func sortedListOfBooks(by parameter: Parameter, ascending: Bool = true) -> String{
        return cart.sorted {
            switch parameter {
            case .title:
                return ascending ? $0.title < $1.title : $0.title > $1.title
            case .price:
                return ascending ? $0.price < $1.price : $0.price > $1.price
            }
        }.map {
            "\($0.title) (\($0.author)) - \($0.price)\u{20BD}"
        }.joined(separator: "\n")
    }
}

let library = Library()
library.addBook(
    Book(
        title: "Гарри Поттер и философский камень",
        author: "Дж.К. Роулинг",
        price: 1000,
        genre: .fiction
    )
)
library.addBook(
    Book(
        title: "Война и мир",
        author: "Лев Толстой",
        price: 850,
        genre: .novel
    )
)
library.addBook(
    Book(
        title: "Стихотворение",
        author: "Владимир Маяковский",
        price: 540,
        genre: .poems
    )
)

let user = User(name: "Алиса", discount: 1.5)
let novelBooks = library.filterBooks(by: .novel)
user.addToCart(novelBooks)
let booksWithName = library.filterBooks(byName: "Гарри")
user.addToCart(booksWithName)

print("Итоговая корзина: \(user.sortedListOfBooks(by: .price, ascending: false))")
print("Цена корзины: \(user.totalPrice())")
