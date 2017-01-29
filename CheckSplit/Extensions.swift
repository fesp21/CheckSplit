//
//  Extensions.swift
//  tryingOutNewHorizontalScrollingCocoapods
//
//  Created by Henry Dinhofer on 1/15/17.
//  Copyright © 2017 Henry Dinhofer. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

extension UserDefaults {
    
    func getTaxRate() -> Double {
        let defaults = UserDefaults.standard
        let result = defaults.double(forKey: Constants.UserDefaultss.taxKey)
        return result == 0 ? Constants.NYtaxRate : result
    }
    
    func setTaxFractionRate(withDecimal decimal : Double) {   // "rate" or "fraction"? not really a % since its not per centa (over 100) mantissa?
        
        let defaults = UserDefaults.standard
        defaults.set(decimal, forKey: Constants.UserDefaultss.taxKey)
    }
    
    
    func getTipRate() -> Double {
        let defaults = UserDefaults.standard
        let result = defaults.double(forKey: Constants.UserDefaultss.tipKey)
        return result == 0 ? Constants.normalTipRate : result
    }
    
    func setTipFractionRate(withDecimal decimal : Double) {
        let defaults = UserDefaults.standard
        defaults.set(decimal, forKey: Constants.UserDefaultss.tipKey)

    }
}

