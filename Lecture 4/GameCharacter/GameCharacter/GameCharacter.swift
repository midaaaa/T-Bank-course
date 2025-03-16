//
//  GameCharacter.swift
//  GameCharacter
//
//  Created by Дмитрий Филимонов on 15.03.2025.
//

import Foundation

struct Constants {
    static let levelUpMultiplier = 1.1  // 10% increase on levelUp
    static let spellManaCostMultiplier = 2  // magicPower to mana ratio
}

class GameCharacter {
    let name: String
    var health: Int
    var level: Int
    var inventory: Inventory
    
    init(name: String, health: Int, level: Int) {
        self.name = name
        self.health = health
        self.level = level
        self.inventory = Inventory()
    }
    
    func takeDamage(amount: Int) {
        if health - amount < 0 {
            health = 0
            print("\(name) получил \(amount) урона и погиб.")
        } else {
            health -= amount
            print("\(name) получил \(amount) урона. Осталось \(health) HP.")
        }
    }
    
    func heal(amount: Int) {
        health += amount
        print("\(name) восстановил \(amount) HP. Всего \(health) HP.")
    }
    
    func levelUp() {
        level += 1
        health = Int(Double(health) * Constants.levelUpMultiplier)
        print("\(name) повысил уровень до \(level)!")
    }
}

class Warrior: GameCharacter {
    var strength: Int
    
    init(name: String, health: Int, level: Int, strength: Int) {
        self.strength = strength
        super.init(name: name, health: health, level: level)
    }

    func attack(target: GameCharacter) {
        if self.isAlive {
            print("\(name) рубит мечом \(target.name) и наносит \(strength) урона.")
            if target.isAlive {
                target.takeDamage(amount: strength)
                if !target.isAlive && target !== self {  // leveling up by killing enemy
                    levelUp()
                }
            }
        } else {
            print("\(name) не может атаковать, потому что умер.")
        }
    }
    
    override func levelUp() {
        super.levelUp()
        // constant increase to all stats and values
        strength = Int(Double(strength) * Constants.levelUpMultiplier)
    }
    
    override func printCharacterInfo() {
        print("\(name) (\(String(describing: type(of: self))) lvl. \(level)) \(health) HP \(strength) ATK")
        inventory.printInventory()
    }
    
}

class Mage: GameCharacter, Flyable, Healer {
    var magicPower: Int
    var flightSpeed: Int
    var mana: Int
    
    init(name: String, health: Int, level: Int, magicPower: Int, flightSpeed: Int, mana: Int) {
        self.magicPower = magicPower
        self.flightSpeed = flightSpeed
        self.mana = mana
        super.init(name: name, health: health, level: level)
    }
    
    func spendMana(amount: Int) {
        if mana - amount < 0 {
            mana = 0
        } else {
            mana -= amount
        }
    }
    
    // Mage uses spell and spends (ATK/2) MP
    func spellAttack(target: GameCharacter) {
        if !self.isAlive {
            print("\(name) не может атаковать, потому что умер.")
        } else if mana - magicPower/Constants.spellManaCostMultiplier < 0 {
            print("\(name) не может атаковать, потому что недостаточно маны \(mana).")
        } else {
            print("\(name) атакует \(target.name) заклинанием и наносит \(magicPower) урона.")
            spendMana(amount: magicPower/Constants.spellManaCostMultiplier)
            if target.isAlive {
                target.takeDamage(amount: magicPower)
                if !target.isAlive && target !== self {  // leveling up by killing enemy
                    levelUp()
                }
            }
        }
    }
    
    override func levelUp() {
        super.levelUp()
        // constant increase to all stats and values
        mana = Int(Double(mana) * Constants.levelUpMultiplier)
        magicPower = Int(Double(magicPower) * Constants.levelUpMultiplier)
        flightSpeed = Int(Double(flightSpeed) * Constants.levelUpMultiplier)
    }
    
    func fly() {
        print("\(name) летает со скоростью \(flightSpeed).")
    }
    
    // Mage heals X HP and spends X MP
    func healTarget(target: GameCharacter, amount: Int) {
        if self.isAlive {
            if mana >= amount {
                spendMana(amount: amount)
                print("\(name) вылечил \(target.name) \(amount) HP.")
                target.heal(amount: amount)
            } else {
                print("У \(name) недостаточно маны (\(mana) MP) для лечения \(target.name) на \(amount) HP.")
            }
        } else {
            print("\(name) не может лечить, потому что умер.")
        }
    }
    
    override func printCharacterInfo() {
        print("\(name) (\(String(describing: type(of: self))) lvl. \(level)) \(health) HP \(mana) MP \(magicPower) ATK")
        inventory.printInventory()
    }
}

// can fly
protocol Flyable {
    var flightSpeed: Int { get }
    func fly()
}

// can heal others
protocol Healer {
    var mana: Int { get set }
    func healTarget(target: GameCharacter, amount: Int)
}

extension GameCharacter {
    var isAlive: Bool {
        return health > 0
    }
    
    @objc func printCharacterInfo() {
        print("\(name) (\(String(describing: type(of: self))) lvl. \(level)) \(health) HP")
    }
}

protocol Item {
    var name: String { get }
    var description: String { get }
    var amount: Int { get }
    var owner: GameCharacter { get }
    func action(target: GameCharacter)
}

class PotionHP: Item {
    var name: String
    var description: String
    var amount: Int
    var owner: GameCharacter
    
    init(name: String, description: String, amount: Int, owner: GameCharacter) {
        self.name = name
        self.description = description
        self.amount = amount
        self.owner = owner
    }
    
    func action(target: GameCharacter) {
        print("\(owner.name) применил \(name) к \(target.name).")
        target.heal(amount: amount)
    }
}

class Dagger: Item {
    var name: String
    var description: String
    var amount: Int
    var owner: GameCharacter
    
    init(name: String, description: String, amount: Int, owner: GameCharacter) {
        self.name = name
        self.description = description
        self.amount = amount
        self.owner = owner
    }
    
    func action(target: GameCharacter) {
        print("\(owner.name) бросил \(name) в \(target.name).")
        target.takeDamage(amount: amount)
        if !target.isAlive && target !== self {  // leveling up by killing enemy
            owner.levelUp()
        }
    }
}

class Inventory {
    var items: [Item] = []
    
    func add(_ item: Item) {
        items.append(item)
    }
    
    func remove(item: Item) {
        if let index = items.firstIndex(where: { $0.name == item.name }) {
            items.remove(at: index)  // removing item on use by its name
        }
    }
    
    func useItem(name: String, target: GameCharacter) {
        if let index = items.firstIndex(where: { $0.name == name }) {
            if items[index].owner.isAlive {
                items[index].action(target: target)
                remove(item: items[index])
            } else {
                print("\(items[index].owner.name) не может использовать \(items[index].name), потому что умер.")
            }
        } else {
            print("Нет такого предмета в инвентаре.")
        }
    }
    
    func printInventory() {
        print("Инвентарь\(items.isEmpty ? " пуст." : ": \(items.map(\.name).joined(separator: ", ")).")")
    }
}
