//
//  ViewController.swift
//  GameCharacter
//
//  Created by Дмитрий Филимонов on 15.03.2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let warrior = Warrior(name: "Spartan", health: 30, level: 10, strength: 30)
        let wizard = Mage(name: "Gandalf", health: 75, level: 33, magicPower: 30, flightSpeed: 15, mana: 50)
        
        // both characters output
        warrior.printCharacterInfo()
        wizard.printCharacterInfo()
        
        let potion1 = PotionHP(name: "Зелье здоровья", description: "Восстанавливает 30 HP", amount: 30, owner: warrior)
        warrior.inventory.add(potion1)  // warrior gets PotionHP
        let dagger1 = Dagger(name: "Кинжал", description: "Наносит 30 урона", amount: 30, owner: warrior)
        warrior.inventory.add(dagger1)  // warrior gets Dagger
        
        // both characters output
        warrior.printCharacterInfo()
        wizard.printCharacterInfo()
        
        warrior.inventory.useItem(name: "Зелье здоровья", target: wizard)  // warrior uses PotionHP on wizard
        wizard.fly()
        warrior.attack(target: wizard)
        wizard.spellAttack(target: warrior)  // wizard kills warrior and levels up
        wizard.healTarget(target: warrior, amount: 100)  // failed heal attempt
        warrior.attack(target: warrior)  // dead warrior can't attack
        wizard.healTarget(target: warrior, amount: 20)  // wizard heals warrior from the dead
        wizard.spellAttack(target: warrior)  // wizard kills warrior and levels up again
        warrior.inventory.useItem(name: "Кинжал", target: warrior)  // dead warrior can't use Dagger
        
        // both characters output
        warrior.printCharacterInfo()
        wizard.printCharacterInfo()
    }


}

