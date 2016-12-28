//
//  Food.swift
//  CheckSplit
//
//  Created by Henry Dinhofer on 12/22/16.
//  Copyright © 2016 Henry Dinhofer. All rights reserved.
//
import Foundation

let EURO_CONVERSION_RATE = 0.96
let YUAN_CONVERSION_RATE = 6.95

class Food : Equatable {
    
    var name : String
    var cost : Double
    var description : String {
        return "\(name) - \(cost)"
    }
    
    
    var inEuros : Double {
        get {
            return self.cost * EURO_CONVERSION_RATE
        }
    }
    
    var inYuan : Double {
        get {
            return self.cost * YUAN_CONVERSION_RATE
        }
    }
    
   
    init(name: String, cost: Double) {
        self.name = name
        self.cost = cost
    }
    
    convenience init() {
        self.init(name: "Unknown", cost: 8675309)
    }

}

func ==(lhs: Food, rhs: Food) -> Bool {
    return lhs.name == rhs.name
}
