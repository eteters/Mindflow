//
//  ComparisonTableViewCell.swift
//  TwoComparisonsPrototype
//
//  Created by Shawn Moore on 2/26/17.
//  Copyright © 2017 Shawn Moore. All rights reserved.
//

import UIKit

class ComparisonTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var resultLabel: UILabel?
    @IBOutlet fileprivate weak var termOneComparisonResultLabel: UILabel?
    @IBOutlet fileprivate weak var termTwoComparisonResultLabel: UILabel?
    
    @IBOutlet weak var infobar1: UIProgressView!
    @IBOutlet weak var infobar2: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        resultLabel?.text = nil
        termOneComparisonResultLabel?.text = nil
        termTwoComparisonResultLabel?.text = nil
        infobar1.progress = 0.0
        infobar2.progress = 0.0
    }
    
    func configure(withTitle entity: String, relevance1: Double, relevance2: Double) {
        resultLabel?.text = entity.capitalized
        termOneComparisonResultLabel?.text = String(format: "%.2f", relevance1)
        termTwoComparisonResultLabel?.text = String(format: "%.2f", relevance2)
        
        let rotationAngle = CGFloat(M_PI)
        
        infobar1.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        infobar1.progress = Float(relevance1)
        infobar2.progress = Float(relevance2)
        
//        let rotationAngle: CGFloat
//        if facingRight {
//            rotationAngle = CGFloat(M_PI * (3.0/2.0))
//        } else {
//            rotationAngle = CGFloat( (90.0 * M_PI) / 180.0 )
//        }
//        
//        label.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }

}
