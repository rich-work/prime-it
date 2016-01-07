//
//  MaterialTextView.swift
//  Prime-IT
//
//  Created by IT Mac on 12/31/15.
//  Copyright © 2015 IT Mac. All rights reserved.
//

import UIKit

class MaterialTextView: UITextView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    override func awakeFromNib() {
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
        self.textContainerInset = UIEdgeInsetsMake(5, 5, 0, 0)
    }
    
    
    
    // for placeholder
    
//    override func textRectForBounds(bounds: CGRect) -> CGRect {
//        return CGRectInset(bounds, 10, 0)
//    }
//    
//    // for editable text
//    
//    override func editingRectForBounds(bounds: CGRect) -> CGRect {
//        return CGRectInset(bounds, 10, 0)
//    }
}
