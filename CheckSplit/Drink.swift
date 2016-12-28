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
    let cost : Double
    
    var description : String {
        return "\(name) - \(cost)"
    }
    
    init(name: String, cost: Double) {
        self.name = name
        self.cost = cost
    }
    
    
}

func ==(lhs: Drink, rhs: Drink) -> Bool {
    return lhs.name == rhs.name
}
