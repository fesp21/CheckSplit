//
//  Drink.swift
//  CheckSplit
//
//  Created by Henry Dinhofer on 12/22/16.
//  Copyright © 2016 Henry Dinhofer. All rights reserved.
//

import Foundation


class Drink : Equatable {
    
    let name: String
    let originalPrice : Double
    var cost : Double {
        get {
            return splitWith.count == 0 ?  originalPrice : originalPrice / Double(splitWith.count)
        }
    }
    let uuid : Int
    var splitWith : [Person]
    
    var description : String {
        var text = "\(name) - \(cost) (\(uuid)) "
        for partner in splitWith {
            text += "\(partner.name) "
        }
        return text
    }
    var splitWithPeople : String {
        var text = ""
        for partner in splitWith {
            text += "\(partner.name) "
        }
        return text
    }
    convenience init() {
        self.init(name: "ERROR", cost: 6000.0, splitWith: [Person]())
    }
    
    convenience init(name: String, cost: Double) {
        self.init(name: name, cost: cost, splitWith: [Person]())
    }
    init(name: String, cost: Double, splitWith: [Person]) {
        self.name = name
        self.splitWith = splitWith
        self.originalPrice = cost
        self.uuid = MealDataStore.sharedInstance.UUID
        //UUID += 1 //Wanted to see which is faster, observer or the other one
    }
    
}

func ==(lhs: Drink, rhs: Drink) -> Bool {
    return lhs.name == rhs.name && lhs.uuid == rhs.uuid
}
