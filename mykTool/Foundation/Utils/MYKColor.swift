//
//  MYKColor.swift
//  mykTools
//
//  Created by 薛 on 2025/1/15.
//

import SwiftUI

extension Color {
    static let customBackground = Color(red: 255/255, green: 253/255, blue: 240/255)
    static let customButton = Color(red: 255/255, green: 248/255, blue: 220/255)
    static let customControl = Color(red: 255/255, green: 254/255, blue: 245/255)
}

extension Color {
    func getRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        // 将 SwiftUI 的 Color 转换为 UIColor
        let uiColor = UIColor(self)
        
        // 提取 RGB 值
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red, green, blue, alpha)
        } else {
            return nil
        }
    }
}

func printColor(color: Color) {
    if let rgb = color.getRGB() {
       print("Red: \(rgb.red), Green: \(rgb.green), Blue: \(rgb.blue), Alpha: \(rgb.alpha)")
   }
}


