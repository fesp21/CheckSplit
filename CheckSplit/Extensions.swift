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
