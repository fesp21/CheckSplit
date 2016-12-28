//
//  AppDelegate.swift
//  CheckSplit
//
//  Created by Henry Dinhofer on 12/22/16.
//  Copyright © 2016 Henry Dinhofer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let henry = Person(name: "Henry")
        let andrew = Person(name: "Andrew V")
        
        let whiskeyGingerbread = Drink(name: "Whiskey Gingerbread", cost: 7.99)
        let vodkaClub = Drink(name: "Vodka and Club Soda", cost: 3.00)
        let bacardiAndCoke = Drink(name: "Bacardi and Coke", cost: 5.99)
        henry.addDrink(drink: whiskeyGingerbread)
        andrew.addDrink(drink: bacardiAndCoke)
        
        henry.removeDrink(drink: whiskeyGingerbread)
        henry.addDrink(drink: vodkaClub)
        
        //print(henry.description)
        //print(andrew.description)
        
        let pitcher = Drink(name: "Sangria Pitcher", cost: 30.0, splitWith: [henry])
        henry.addDrink(drink: pitcher)
        pitcher.splitWith.append(andrew)
        andrew.addDrink(drink: pitcher)
        
        print(andrew.description)
        print(pitcher.cost)
        let ari = Person(name: "Ari")
        pitcher.splitWith.append(ari)
        print(ari.description)
        
        print(henry.description)
        pitcher.splitWith.remove(at: 1)
        print(andrew.description)
        print(henry.description)
        pitcher.splitWith.remove(at: 0)
        print(henry.description)
        
        henry.removeDrink(drink: pitcher)
        print(henry.description)
        
        // Person A splits drink with Person B
        // add drink (with UUID) to Person A
        // add person to Drink?
        //
        // addSplit == on class Drink
        // removeSplit ==
        
        // edge cases you add drinks to person A (split with same person over and over again)
        // I think we should go with the UUID scenario each item gets its own UUID
        
        enum itemType : String {
            case appetizer, entree, desert, drink, beverage
        }
        
        let entree = itemType.entree
        print(entree)
        
        if entree == itemType.entree { print("YES!") }
        
        print(MealDataStore.sharedInstance.UUID)
        let store = MealDataStore.sharedInstance
        /*store.drinks.append(pitcher)
         print(MealDataStore.sharedInstance.UUID)
         print(MealDataStore.sharedInstance.UUID)
         
         // each Drink split method needs to also update the Person object
         
         store.drinks.remove(at: 0)
         print(MealDataStore.sharedInstance.UUID)
         store.patrons.append(henry)
         store.removeItem(item: pitcher)
         
         store.patrons.append(andrew)
         
         store.patrons[0].addDrink(drink: whiskeyGingerbread)
         store.patrons[0].split(drink: whiskeyGingerbread, withPerson: andrew)
         print(store.patrons[0].description)
         */
        
        //DataStore methods
        let newHenry = Person(name: "Henry D")
        store.add(item: newHenry)
        let ginTonic0 = Drink(name: "Gin and Tonic", cost: 10.0)
        store.add(item: ginTonic0)
    
        let ginTonic1 = Drink(name: "Gin and Tonic", cost: 10.0)
        store.add(item: ginTonic1)
        let tequillaAndLime = Drink(name: "Tequilla Shot x3", cost: 20.0)
        store.add(item: tequillaAndLime)
        let newBen = Person(name: "Ben G")
        store.add(item: newBen)
        store.add(item: ginTonic0)
        
        store.add(item: ginTonic1, toPerson: newBen)
        store.add(item: ginTonic1, toPerson: Person(name: "Henry D"))
        let newAri = Person(name: "Ari M")
        store.add(item: newAri)
        
//        store.add(item: ginTonic1, toPerson: Person(name: "Ari M"))
//        store.add(item: Drink(name: "Chocolate Shake", cost: 10.0) , toPerson: newBen) //New item Chocolate Shake isn't added
//        store.add(item: tequillaAndLime, toPerson: Person(name: "Ari M"))
//        store.add(item: ginTonic0, toPerson: Person(name: "Henry D"))
//        
//        store.remove(item: ginTonic0, fromPerson: newBen) // Correct. Doesn't remove drink from person who doesn't have it!
//        store.remove(item: ginTonic1, fromPerson: newAri)
//        
//        store.remove(item: ginTonic0, fromPerson: newHenry)
//        store.remove(item: ginTonic0, fromPerson: newHenry) // Correct. Already removed!
//        store.remove(item: ginTonic1, fromPerson: newBen)
//        store.remove(item: ginTonic1, fromPerson: Person(name: "Henry D"))
//        store.add(item: ginTonic1, toPerson: Person(name: "Ben G"))
//        store.add(item: ginTonic1, toPerson: Person(name: "Ari M"))
//        store.add(item: ginTonic1, toPerson: newHenry)
//        
//        store.remove(item: ginTonic1)
        //store.remove(item: tequillaAndLime)
        
        store.add(item: ginTonic1, toPerson: Person(name: "Ari M"))
        store.add(item: Drink(name: "Chocolate Shake", cost: 10.0) , toPerson: newBen) //New item Chocolate Shake isn't added
        store.add(item: tequillaAndLime, toPerson: Person(name: "Ari M"))
        store.add(item: ginTonic0, toPerson: Person(name: "Henry D"))
        
        store.remove(item: ginTonic0, fromPerson: newBen) // Correct. Doesn't remove drink from person who doesn't have it!
        //store.remove(item: ginTonic1, fromPerson: newAri)
        
        store.remove(item: ginTonic0, fromPerson: newHenry)
        store.remove(item: ginTonic0, fromPerson: newHenry)
        store.add(item: ginTonic0, toPerson: newAri)
        store.remove(item: ginTonic0)

        
        print("\n")
        print("People UUID \(store.peopleUUID)")
        for person in store.patrons {
            print(person.description)
        }
        
        print("Items UUID \(store.UUID)")
        for drink in store.drinks {
            print(drink.description)
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

