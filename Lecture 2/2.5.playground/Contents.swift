import Foundation

enum Operation {
    case sum(Double, Double)
    case sub(Double, Double)
    case mul(Double, Double)
    case div(Double, Double)
    case square(Double)
    case sqrt(Double)
}

let array1: [Operation] = [.sum(1,2), .sub(2,123), .mul(2,3),
                           .div(12,3), .square(2.25), .sqrt(2)]

for action in array1 {
    switch action {
    case .sum(let a, let b):
        print("Сумма - \(a + b)")
    case .sub(let a, let b):
        print("Разность - \(a - b)")
    case .mul(let a, let b):
        print("Произведение - \(a * b)")
    case .div(let a, let b):
        print("Деление - \(a / b)")
    case .square(let a):
        print("Квадрат - \(a * a)")
    case .sqrt(let a):
        print("Квадратный корень - \(sqrt(a))")
    }
}
