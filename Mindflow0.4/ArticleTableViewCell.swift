//
//  ArticleTableViewCell.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/11/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    var url:URL?
    var detailViewController:EntityDetailViewController?
    var twoDetailViewController:CompareDetailViewController?
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var articleInfo3Label: UILabel!
    
    @IBOutlet weak var articleInfo4Label: UILabel!
    
    @IBOutlet weak var articleInfo5Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func share(_ sender: Any) {
        displayShareSheet(shareContent: self.url!)
    }
    func displayShareSheet(shareContent:URL) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSURL], applicationActivities: nil)
        //presentViewConroller(activityViewController, animated: true, completion: {})
        if let detailViewController = detailViewController {
            detailViewController.present(activityViewController, animated: true, completion: {})

        }
        else if let compareControler = twoDetailViewController {
            compareControler.present(activityViewController, animated: true, completion: {})
        }
        
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
