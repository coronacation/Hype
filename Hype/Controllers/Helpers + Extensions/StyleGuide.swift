//
//  StyleGuide.swift
//  Hype
//
//  Created by Theo Vora on 4/6/20.
//  Copyright © 2020 Theo Vora. All rights reserved.
//

import UIKit

extension UIColor {
    static let textFieldBorderColor = UIColor(named: "textFieldBorderColor")!
    static let buttonGreen = UIColor(named: "buttonGreen")!
    static let hypeBackground = UIColor(named: "hypeBackground")!
    static let subtitleGray = UIColor(named: "subtitleGray")!
    static let textfieldBackground = UIColor(named: "textfieldBackground")
}

extension UIView {
    func addCornerRadius(_ radius: CGFloat = 4) {
        self.layer.cornerRadius = radius
    }
    
    func addAccentBorder(width: CGFloat = 1, color: UIColor = UIColor.textFieldBorderColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func rotate(by radians: CGFloat = (-(CGFloat.pi/2))) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}
