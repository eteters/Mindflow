//
//  UILabelExtensions.swift
//  TwoComparisonsPrototype
//
//  Created by Shawn Moore on 2/27/17.
//  Copyright © 2017 Shawn Moore. All rights reserved.
//

import UIKit

extension UILabel {
    var isTruncating: Bool {
        guard let text = self.text else { return false }
        
        guard let font = self.font else { return false }
        
        let size = (text as NSString).size(attributes: [NSFontAttributeName : font])
        
        return size.width > self.bounds.size.width
    }
}
