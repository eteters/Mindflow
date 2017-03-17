//
//  EntityTableViewCell.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/9/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit

class EntityTableViewCell: UITableViewCell {

    @IBOutlet weak var entityText: UILabel!
    @IBOutlet weak var infoBar: UIProgressView!
    @IBOutlet weak var relevanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    override func prepareForReuse() {
        infoBar.progress = 0.0
        infoBar.progressTintColor = UIColor.blue
        entityText.text = nil
        relevanceLabel.text = nil
    }
    
}
