//
//  EntityDetailViewController.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/9/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit

class EntityDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var articleCountLabel: UILabel!

    @IBOutlet weak var entityNameLabel: UILabel!
    
    var entityPass:[Entity]?
    
    var entity:Entity!
    
    var term1Pass = ""
    
    
    @IBOutlet weak var articleTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entityNameLabel.text = entity.entityName
//        countLabel.text = "Mentions: \(entity.count)"
        articleCountLabel.text = "articleTotal: \(entity.articles.count)"
        
        articleTable.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articlecell", for: indexPath) as! ArticleTableViewCell
        
        cell.articleTitleLabel.text = entity.articles[indexPath.row].title
        cell.articleInfo3Label.text = entity.articles[indexPath.row].author
        if let relevance = entity.articles[indexPath.row].entityRelevance {
            cell.articleInfo4Label.text = String(relevance)
        }
        cell.articleInfo5Label.text = ""
        
        if let date = entity.articles[indexPath.row].pubDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "'Published 'MM-dd-yyyy"
            
            
            cell.pubDateLabel.text = dateFormatter.string(from: date)

        }
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return entity.articles.count
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WebViewController{
            
            let url = URL(string: entity.articles[(articleTable.indexPathForSelectedRow?.row)!].url)
            let request = URLRequest(url: url!)
            destination.request = request
            destination.term = entity.entityName
        }
        else if let destination = segue.destination as? EntityTableViewController {
            destination.searchDone = false
            destination.searchTerm = entity.entityName
        }
        
        else if let destination = segue.destination as? StationaryExpandingAboveTextViewController {
            destination.entities1 = entityPass
            destination.termOne = term1Pass
            destination.termTwo = entity.entityName
        }
    }
    
}
