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
    }
    
    func configure(withTitle entity: String, relevance1: Double, relevance2: Double) {
        resultLabel?.text = entity.capitalized
        termOneComparisonResultLabel?.text = String(format: "%.2f", relevance1)
        termTwoComparisonResultLabel?.text = String(format: "%.2f", relevance2)
    }

}
