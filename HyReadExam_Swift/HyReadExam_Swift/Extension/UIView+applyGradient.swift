//
//  UIView+applyGradient.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import UIKit

extension UIView {
    func applyGradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
