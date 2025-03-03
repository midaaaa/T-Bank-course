import Foundation

let string1 = "apple Orange pineapple PEAR"
let string2 = "apple aPPle appLe Apple"

var words: Set<String> = []

for word in string1.lowercased().split(separator: " ") {
    words.insert(String(word))
}

print(words.count)
