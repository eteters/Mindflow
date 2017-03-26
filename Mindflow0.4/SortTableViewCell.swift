//
//  SortTableViewCell.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/12/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit

class SortTableViewCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        optionLabel.text = nil
    }

}
