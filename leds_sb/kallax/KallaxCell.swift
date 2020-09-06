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
    
    func setCellSelected() {
        imageView.isHidden = false
    }
    
    func setCellUnselected() {
        imageView.isHidden = true
    }
    
    
    
    func color(color: UIColor) {
        gradients[0].colors = [color.cgColor, color.cgColor]
        gradients[1].colors = [color.cgColor, color.cgColor]
        gradients[2].colors = [color.cgColor, color.cgColor]
        gradients[3].colors = [color.cgColor, color.cgColor]
        vs = gradients[0].startPoint
        ve = gradients[0].endPoint
    }
    
    func gradientTopDown(colors: [CGColor]) {
        gradients[0].colors = [colors[0], colors[0]]
        gradients[1].colors = [colors[0], colors[1]]
        gradients[2].colors = [colors[1], colors[1]]
        gradients[3].colors = [colors[0], colors[1]]
        
        gradients[0].startPoint = vs
        gradients[0].endPoint = ve
        gradients[1].startPoint = vs
        gradients[1].endPoint = ve
        gradients[2].startPoint = vs
        gradients[2].endPoint = ve
        gradients[3].startPoint = vs
        gradients[3].endPoint = ve
    }
    
    func gradientLeftRight(colors: [CGColor]) {
        gradients[0].colors = [colors[0], colors[1]]
        gradients[1].colors = [colors[1], colors[1]]
        gradients[2].colors = [colors[0], colors[1]]
        gradients[3].colors = [colors[0], colors[0]]
        
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
