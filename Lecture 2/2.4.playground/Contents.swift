import Foundation

let dict1: [String : Int?] = ["A": 4, "B": 4, "C": 4]
let dict2: [String : Int?] = ["A": nil, "B": nil, "C": nil]


// solution 1
var sum = 0, count = 0

for (_, value) in dict1 {
    if value != nil {
        sum += value!
        count += 1
    }
}

if count == 0 {
    print("Никто не сдал")
} else {
    print(Double(sum)/Double(count))
}

// solution 2
/*
let values: Set<Int?> = Set(dict1.values)

if values.count == 1 && values.contains(nil) { // if values == [nil] {
    print("Никто не сдал")
} else {
    let dictClean = dict1.filter { $0.value != nil }
    var sum = 0
    for (_, value) in dictClean {
        sum += value!
    }
    print(Double(sum)/Double(dictClean.count))
}
*/
