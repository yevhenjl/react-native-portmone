// ios/StyleOptionsMapper.swift
import Foundation
import UIKit

// Helper class to work with styling options
class StyleOptionsMapper {
    // Convert hex color string to UIColor
    static func colorFrom(hexString: String?) -> UIColor? {
        guard let hexString = hexString else { return nil }
        
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                if hexColor.count == 8 {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    return UIColor(red: r, green: g, blue: b, alpha: a)
                } else if hexColor.count == 6 {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255
                    
                    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
                }
            }
        }
        
        return nil
    }
    
    // Get font from font name with default size
    static func fontFrom(fontName: String?, size: CGFloat = 16) -> UIFont? {
        guard let fontName = fontName, !fontName.isEmpty else { return nil }
        return UIFont(name: fontName, size: size)
    }
}