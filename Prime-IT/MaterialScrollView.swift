//
//  MaterialScrollView.swift
//  Prime-IT
//
//  Created by IT Mac on 1/7/16.
//  Copyright © 2016 IT Mac. All rights reserved.
//

import UIKit

class MaterialScrollView: UIScrollView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 6.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.6).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 8.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
    
}
