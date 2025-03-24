//
//  ARC.swift
//  ARC
//
//  Created by Дмитрий Филимонов on 24.03.2025.
//

import Foundation

class Person {
    let name: String
    var car: Car?
    
    init(name: String, car: Car?) {
        self.name = name
        self.car = car
    }
    
    deinit {
        print("Person очищен")
    }
}

class Car {
    weak var owner: Person?
    
    init(owner: Person?) {
        self.owner = owner
    }
    
    deinit {
        print("Car очищен")
    }
}

func testARC() {
    print("Задание 5:")
    let person = Person(name: "Dima", car: nil)
    let car = Car(owner: nil)
    person.car = car
    car.owner = person
    
    print(person.name)
    print(person.car ?? "nil")
    print(car.owner ?? "nil")
}
