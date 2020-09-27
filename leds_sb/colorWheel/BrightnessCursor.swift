//
//  HRBrightnessCursor.swift
//  ColorPicker3
//
//  Created by Ryota Hayashi on 2020/05/06.
//  Copyright © 2020 Hayashi Ryota. All rights reserved.
//

import UIKit

internal class BrightnessCursor: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.5
        layer.borderWidth = 1
        isUserInteractionEnabled = false
    }

    func set(hsv: HSVColor) {
        backgroundColor = hsv.uiColor
        let borderColor = hsv.borderColor
        layer.borderColor = borderColor.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 6
    }
}
