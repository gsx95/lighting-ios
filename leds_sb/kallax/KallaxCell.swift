//
//  KallaxCell.swift
//  leds_sb
//
//  Created by Georg Schwarz on 28.02.20.
//  Copyright © 2020 Georg Schwarz. All rights reserved.
//

import UIKit

class KallaxCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var gradients: [CAGradientLayer] = []
    var num = -1
    var w = CGFloat(2)
    
    var hs = CGPoint(x: 0.0, y: 0.5)
    var he = CGPoint(x: 1.0, y: 0.5)
    var vs: CGPoint = CGPoint()
    var ve: CGPoint = CGPoint()
    
    
    class GradStrip {
        var from: UIColor = UIColor.white
        var to: UIColor = UIColor.white
        init() {
            
        }
    }
    
    //left -> right
    var top = GradStrip()
    var bottom = GradStrip()
    //top -> bottom
    var left = GradStrip()
    var right = GradStrip()
    
    var orig_start = UIColor.white
    var orig_end = UIColor.white
    var orig_mode = "all"
    
    func setCellSelected() {
        imageView.isHidden = false
    }
    
    func setCellUnselected() {
        imageView.isHidden = true
    }
    
    func color(color: UIColor) {
        top.from = color
        top.to = color
        bottom.from = color
        bottom.to = color
        left.from = color
        left.to = color
        right.from = color
        right.to = color
        
        orig_start = color
        orig_end = color
        orig_mode = "all"
        
        gradients[0].colors = [color.cgColor, color.cgColor]
        gradients[1].colors = [color.cgColor, color.cgColor]
        gradients[2].colors = [color.cgColor, color.cgColor]
        gradients[3].colors = [color.cgColor, color.cgColor]
        vs = gradients[0].startPoint
        ve = gradients[0].endPoint
    }
    
    func gradientTopDown(colors: [UIColor]) {
    
        let first = colors[0]
        let second = colors[1]
        
        top.from = first
        top.to = first
        bottom.from = second
        bottom.to = second
        left.from = first
        left.to = second
        right.from = first
        right.to = second
        orig_start = first
        orig_end = second
        orig_mode = "top_down"
        
        
        gradients[0].colors = [colors[0].cgColor, colors[0].cgColor]
        gradients[1].colors = [colors[0].cgColor, colors[1].cgColor]
        gradients[2].colors = [colors[1].cgColor, colors[1].cgColor]
        gradients[3].colors = [colors[0].cgColor, colors[1].cgColor]
        
        gradients[0].startPoint = vs
        gradients[0].endPoint = ve
        gradients[1].startPoint = vs
        gradients[1].endPoint = ve
        gradients[2].startPoint = vs
        gradients[2].endPoint = ve
        gradients[3].startPoint = vs
        gradients[3].endPoint = ve
    }
    
    func gradientLeftRight(colors: [UIColor]) {
        
        let first = colors[0]
        let second = colors[1]
        
        top.from = first
        top.to = second
        bottom.from = first
        bottom.to = second
        left.from = first
        left.to = first
        right.from = second
        right.to = second
        orig_start = first
        orig_end = second
        orig_mode = "left_right"
        
        gradients[0].colors = [colors[0].cgColor, colors[1].cgColor]
        gradients[1].colors = [colors[1].cgColor, colors[1].cgColor]
        gradients[2].colors = [colors[0].cgColor, colors[1].cgColor]
        gradients[3].colors = [colors[0].cgColor, colors[0].cgColor]
        
        gradients[0].startPoint = hs
        gradients[0].endPoint = he
        gradients[1].startPoint = hs
        gradients[1].endPoint = he
        gradients[2].startPoint = hs
        gradients[2].endPoint = he
        gradients[3].startPoint = hs
        gradients[3].endPoint = he
    }
    
    func addBorders(index: Int, color: UIColor) {
        addBorderTop(index: index, color: color)
        addBorderRight(index: index, color: color)
        addBorderBottom(index: index, color: color)
        addBorderLeft(index: index, color: color)
    }
    func addBorderTop(index: Int, color: UIColor) {
        var width = w
        if(index < 4) {
            width = w*2
        }
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = [color.cgColor, color.cgColor]

        let shape = CAShapeLayer()
        shape.lineWidth = width
        shape.path = UIBezierPath(rect: CGRect(x: 0-width, y: 0, width: self.frame.size.width + (2*width), height: self.frame.size.height + (2*width))).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        self.layer.addSublayer(gradient)
        gradients.append(gradient)
    }
    
    func addBorderBottom(index: Int, color: UIColor) {
        var width = w
        if(index > 11) {
            width = w*2
        }
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = [color.cgColor, color.cgColor]

        let shape = CAShapeLayer()
        shape.lineWidth = width
        shape.path = UIBezierPath(rect: CGRect(x: 0-width, y: 0-(2*width), width: self.frame.size.width + (2*width), height: self.frame.size.height + (2*width))).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        self.layer.addSublayer(gradient)
        gradients.append(gradient)
    }
    
    func addBorderLeft(index: Int, color: UIColor) {
        var width = w
        if(index % 4 == 0) {
            width = w*2
        }
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = [color.cgColor, color.cgColor]

        let shape = CAShapeLayer()
        shape.lineWidth = width
        shape.path = UIBezierPath(rect: CGRect(x: 0, y: 0-width, width: self.frame.size.width + (2*width), height: self.frame.size.height + (2*width))).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        self.layer.addSublayer(gradient)
        gradients.append(gradient)
    }
    
    func addBorderRight(index: Int, color: UIColor) {
        var width = w
        if(index % 4 == 3) {
            width = w*2
        }
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = [color.cgColor, color.cgColor]

        let shape = CAShapeLayer()
        shape.lineWidth = width
        shape.path = UIBezierPath(rect: CGRect(x: 0-(2*width), y: 0-width, width: self.frame.size.width + (2*width), height: self.frame.size.height + (2*width))).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        self.layer.addSublayer(gradient)
        gradients.append(gradient)
    }
}
