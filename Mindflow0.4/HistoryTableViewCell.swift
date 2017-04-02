//
//  HistoryTableViewCell.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/28/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var numResultLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
