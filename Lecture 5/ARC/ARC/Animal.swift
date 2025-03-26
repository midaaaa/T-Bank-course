//
//  Animal.swift
//  ARC
//
//  Created by Дмитрий Филимонов on 24.03.2025.
//

import Foundation

class Animal {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func speak() {
        print("Sound...")
    }
}

class Dog: Animal {
    override func speak() {
        print("Woof!")
    }
}

class Cat: Animal {
    override func speak() {
        print("Meow!")
    }
}

func testAnimal() {
    print("Задание 6:")
    var animals: [Animal] = []
    let dog1 = Dog(name: "Бульдог")
    let dog2 = Dog(name: "Корги")
    let cat = Cat(name: "Британец")
    animals.append(dog1)
    animals.append(dog2)
    animals.append(cat)
    for animal in animals {
        animal.speak()
    }
}
