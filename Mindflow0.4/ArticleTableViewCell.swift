//
//  ArticleTableViewCell.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/11/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var articleInfo3Label: UILabel!
    
    @IBOutlet weak var articleInfo4Label: UILabel!
    
    @IBOutlet weak var articleInfo5Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        articleTitleLabel.text = nil
        pubDateLabel.text = nil
        articleInfo3Label.text = nil
        articleInfo4Label.text = nil
        articleInfo5Label.text = nil

    }

}
