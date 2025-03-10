import Foundation

let string1 = "(())"
let string2 = "))(("
let string3 = "()()()"

var counter = 0

for bracket in string1 {
    if bracket == "(" {
        counter += 1
    } else if bracket == ")" {
        counter -= 1
        if counter < 0 {
            break
        }
    }
}

if counter == 0 {
    print("Корректная")
} else {
    print("Некорректная")
}
