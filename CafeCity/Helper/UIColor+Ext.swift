//
//  UIColor+Ext.swift
//  CafeCity
//
//  Created by Shane on 2019/8/20.
//  Copyright © 2019 Shane. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff,alpha: 1.0)
    }
    
    struct myColor {
        static let mainColor = UIColor(red: 242, green: 110, blue: 80,alpha: 1.0)
    }
}
