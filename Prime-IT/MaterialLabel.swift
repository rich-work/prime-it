//
//  MaterialLabel.swift
//  Prime-IT
//
//  Created by IT Mac on 1/6/16.
//  Copyright © 2016 IT Mac. All rights reserved.
//

import UIKit

class MaterialLabel: UILabel {
    override func awakeFromNib() {
        layer.masksToBounds = true
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
        
    }
    
    override func drawTextInRect(rect: CGRect) {
        let primeRect = CGRectOffset(rect, 10, 0)
        super.drawTextInRect(primeRect)
    }
    
}
