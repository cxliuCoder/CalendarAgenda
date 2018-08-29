//
//  UIColor+CAColor.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-08-28.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

extension UIColor {
    class func hexColor(string:String) -> UIColor {
        
        var hex = string.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (hex.hasPrefix("#")) {
            let index = hex.index(hex.startIndex, offsetBy:1)
            hex = hex.substring(from: index)
        } else if (hex.hasPrefix("0X")) {
            let index = hex.index(hex.startIndex, offsetBy:2)
            hex = hex.substring(from: index)
        }
        
        if (hex.count != 6) {
            return UIColor.red
        }
        
        let index = hex.index(hex.startIndex, offsetBy:2)
        let index2 = hex.index(hex.startIndex, offsetBy:4)
        let range = Range(index ..< index2)
        
        let red:String = hex.substring(to:index)
        let green:String = hex.substring(with:range)
        let blue:String = hex.substring(from:index2)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: red).scanHexInt32(&r)
        Scanner.init(string: green).scanHexInt32(&g)
        Scanner.init(string: blue).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
