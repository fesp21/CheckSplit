//
//  MealDataStore.swift
//  CheckSplit
//
//  Created by Henry Dinhofer on 12/28/16.
//  Copyright © 2016 Henry Dinhofer. All rights reserved.
//

import Foundation

class MealDataStore {
    static let sharedInstance = MealDataStore()
    private init() {  }
    
    var UUID : Int = 0
    var peopleUUID : Int = 0
    
    var patrons : [Person] = [] {
        didSet {
            let oldCount = oldValue.count
            if patrons.count > oldCount {
                print("Inserted")
                peopleUUID += 1  //objectID
            }
            else {
                print("Deleted")
                peopleUUID -= 1
            }
        }
    }
    
    var items : [AnyObject] = [] // Goal here
    
    
    var drinks : [Drink] = [] {
        didSet {
            let oldCount = oldValue.count
            if drinks.count > oldCount {
                print("Inserted")
                UUID += 1
            }
            else {
                print("Deleted")
                //UUID -= 1 //TODO: methods that update Persons, removing drink from each Person's drinks list
            }
        }
    }
    var food : [Food] = []
    
    func clear() {
        drinks.removeAll()
        food.removeAll()
        items.removeAll()
        patrons.removeAll()
        UUID = 0
        peopleUUID = 0
    }
    
    // Waiter or Waitress actions
    func removeAll(item : AnyObject) {
        if item is Person {
            print("Remove function for person needed")
        }
        
        print("remove")
        guard let index = index(of: item) else { return }
        
        if item is Drink {
            let drinkToRemove = drinks[index]
            drinks.remove(at: index)
            for person in patrons {
                guard let matchIndex = person.drinks.index(where:{$0 == drinkToRemove}  )
                else { continue } // didn't have drink
                person.drinks.remove(at: matchIndex)
            }
        }
        
        
        //        switch item {
        //            case is Person: patrons.remove(at: index)
        //            case is Drink: drinks.remove(at: index)
        //
        //        }
    }
    
    func add(item : AnyObject) {
        guard index(of: item) == nil else { print("Prevented inserting duplicate item"); return }
        //let addFlag : Bool = false
        
        if let person = item as? Person {
            patrons.insert(person, at: 0)
            //addFlag = true
        }
        
        if let drink = item as? Drink {
            drinks.insert(drink, at: 0)
        }
        
        if let grub = item as? Food {
            food.insert(grub, at: 0)
        }
        
    }
    
    func add(item : AnyObject, toPerson person : Person) {
        guard let personIndex = index(of: person) else { return }
        guard let itemIndex = index(of: item) else { return }
        if item is Person { return }
        
        
        //find person
        // add object to said person
        //
        let patron = patrons[personIndex]
        
        
        // update singleton drinks
        if item is Drink {
            let updateItem = drinks[itemIndex]
            updateItem.splitWith.append(patron)
            //updateAllPeople(withNewItem: updateItem)
            drinks[itemIndex] = updateItem
            patron.drinks.append(updateItem)    //instance of item in Singleton, change also updates singleton
        }
    }
    
    // TODO: get index regardless of object ID?
    func index(of item : AnyObject) -> Int? {
        var index : Int?
        if let person = item as? Person {
            index = patrons.index(where: { $0 == person } )
            if index == nil { print("Unable to find Person \(person.name) in datastore") }
        }
        
        if let drink = item as? Drink {
            index = drinks.index(where: { $0 == drink } )
            if index == nil { print("Unable to find Drink \(drink.description) in datastore") }
        }
        
        return index
    }
    
    func updateAllPeople(withNewItem item : AnyObject) {
        guard let itemIndex = index(of: item) else { return }
        
        for person in patrons {
            
            if let newDrink = item as? Drink {
                for index in 0..<person.drinks.count {
                    let drink = person.drinks[index]
                    if drink == newDrink {
                        person.drinks[index] = newDrink
                    }
                }
            }
        }
        
        if let newDrink = item as? Drink {
            drinks[itemIndex] = newDrink
        }
        
        //        if let newDrink = item as? Drink {
        //            for index in 0..<drinks.count {
        //                let drink = drinks[index]
        //                if newDrink == drink {
        //                    drinks[index] = newDrink
        //                }
        //            }
        //        }
    }
    
    func remove(item : AnyObject, fromPerson person : Person) {
        guard let itemIndex = index(of: item) else  { print("Unable to find item index"); return }
        guard let personIndex = index(of: person) else { print("Unable to find person index"); return }
        if item is Person { return } //can't add People to People!

        print("remove item from person")
        
        //find person
        // add object to said person
        //
        let patron = patrons[personIndex]
        
        
        // update singleton drinks
        if item is Drink {
            let updateItem = drinks[itemIndex]
            guard let splitIndex = updateItem.splitWith.index(where: { $0 == patron })
                else { print("Unable for drink to remove the payer, are you sure \(patron.name) ordered it?"); return }
            updateItem.splitWith.remove(at: splitIndex)
            //updateAllPeople(withNewItem: updateItem)
            
            // I have no idea why this works, think I'm messing with the state of the singleton
            drinks[itemIndex] = updateItem
            guard let patronIndex = patron.drinks.index(where: { $0 == updateItem })
                else { print("Unable to find drink for person, are you sure they ordered it?"); return }
            patron.drinks.remove(at: patronIndex)
            //updateAllPeople(withNewItem: updateItem)
        }
        
    }
    
    func calculateSubtotal() -> Double {
        var subtotal : Double = 0.0
        for person in patrons {
            subtotal += person.totalTally
        }
        return subtotal
    }
    
}
