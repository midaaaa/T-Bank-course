import Foundation

let array1 = ["a", "bb", "b", "cccc"]
let array2 = ["a", "b", "c"]

var dict: [Int: Array<String>] = [:]

for string in array1 {
    dict.updateValue((dict[string.count] ?? []) + [string], forKey: string.count)
}

for keys in dict.keys.sorted() {
    print("\(keys) - \(dict[keys]!)")
}
