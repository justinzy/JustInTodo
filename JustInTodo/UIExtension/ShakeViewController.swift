//
//  ViewController.swift
//  JustInTodo
//
//  Created by Justin Zhang on 2018/7/30.
//  Copyright © 2018年 JustinZhang. All rights reserved.
//

import UIKit

extension UIView {
    func shake() {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "shake")
    }
}
