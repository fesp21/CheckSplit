//
//  DemoRun.swift
//  CheckSplit
//
//  Created by Henry Dinhofer on 1/1/17.
//  Copyright © 2017 Henry Dinhofer. All rights reserved.
//

import Foundation

class DemoRun {
    
    let store = MealDataStore.sharedInstance
    
    func setup() {
        makeMenu()
        getOrder()
    }
    
    func getOrder() {
        getPeople()
        getDrinks()
        assignDrinks()
    }
    
    func assignDrinks() {
        let numPatronsDrinking = 10
        for index in 0..<numPatronsDrinking
        {
            let person = store.patrons[index]
            let drink = store.drinks[index]
            store.add(item: drink, toPerson: person)
        }
        
        store.add(item: store.drinks[4], toPerson: Person(name: "Ben G"))
        store.add(item: store.drinks[2], toPerson: Person(name: "Mikey C"))
        
    }
    func getPeople() {
        let ben = Person(name: "Ben G")
        let henry = Person(name: "Henry D")
        let ari = Person(name: "Ari M")
        let david = Person(name: "David Z")
        let josh = Person(name: "Josh E")
        let mikey = Person(name: "Mikey C")
        let dani = Person(name: "Dani S")
        let ryan = Person(name: "Ryan C")
        let alex = Person(name: "Alex H")
        let githui = Person(name: "Githui M")
        let people : [Person] = [ben, henry, ari, david, josh, mikey, dani, ryan, alex, githui]
        
        for person in people {
            store.add(item: person)
        }

    }

    func getDrinks() {
        
        let drinksCount = menu["Drinks"]?.count ?? 0
        var randomDrinkList = [Drink]()
        
        while (randomDrinkList.count < store.patrons.count) {
            let randomIndex = Int(arc4random_uniform(UInt32(drinksCount)))
            
            let randomDrink = store.drinks[randomIndex]
            if randomDrinkList.contains(randomDrink) { continue }
            else { randomDrinkList.append(randomDrink) }
        }
        
        store.drinks = randomDrinkList
//        store.drinks.append(contentsOf: randomDrinkList)
    }
    
    func makeMenu() {
        store.clear()
        for sectionName in menu.keys {
            
            let section = menu[sectionName] ?? ["NOT VALID" : 0]
            
            
            for dish in section {
                if sectionName == "Drinks"
                {
                    let drink = Drink(name: dish.key, cost: Double(dish.value))
                    store.drinks.append(drink)
                }
                    
                else if sectionName == "Appetizers" {
                    
                }
                else if sectionName == "Entrees"
                {
                    let food = Food(name: dish.key, cost: Double(dish.value))
                    store.food.append(food)
                }
            }
        }
    }
}
