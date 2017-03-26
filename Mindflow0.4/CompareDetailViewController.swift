//
//  CompareDetailViewController.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/20/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit

class CompareDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //I Need to pass the two search terms! They are heders, not the entity names
    var search1 = ""
    var search2 = ""
    
    var headers = [String]()
    var combinedEntity:CombinedEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = combinedEntity?.entityName
        self.title = combinedEntity?.entityName
        
        if let _ = combinedEntity?.entity1{
            headers.append(search2)
        }
        if let _ = combinedEntity?.entity2{
            headers.append(search1)
        }
        
        tableView.reloadData()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let term1 = combinedEntity?.entity1{
            return term1.articles.count
        }
        if let term2 = combinedEntity?.entity2 {
            return term2.articles.count
        }// TODO: check add a boolean!!!! needs to know what section
        else {return 0}

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articlecell", for: indexPath) as! ArticleTableViewCell
        if headers.count == 0{
            return cell
        }
        
        if let term1 = combinedEntity?.entity1  {
            cell.articleTitleLabel.text = term1.articles[indexPath.row].title
            cell.pubDateLabel.text = term1.articles[indexPath.row].title
            cell.articleInfo3Label.text = term1.articles[indexPath.row].author
            let relevance = term1.articles[indexPath.row].entityRelevance
            cell.articleInfo4Label.text = "Relevance: \(relevance?.percentage()) "
        }
    
        if let term2 = combinedEntity?.entity2  {
            cell.articleTitleLabel.text = term2.articles[indexPath.row].title
            cell.pubDateLabel.text = term2.articles[indexPath.row].title
            cell.articleInfo3Label.text = term2.articles[indexPath.row].author
            let relevance = term2.articles[indexPath.row].entityRelevance
            cell.articleInfo4Label.text = "Relevance: \(relevance?.percentage()) "
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    

    
}
