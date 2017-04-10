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
    
    //I Need to pass the two search terms! They are headers, not the entity names
    var search1 = ""
    var search2 = ""
    
    var headers = [String]()
    var combinedEntity:CombinedEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = combinedEntity?.entityName
        self.title = combinedEntity?.entityName
        
        if let _ = combinedEntity?.entity1{
            headers.append(search1)
        }
        if let _ = combinedEntity?.entity2{
            headers.append(search2)
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
        if let term1 = combinedEntity?.entity1, headers[section] == search1{
            return term1.articles.count
        }
        if let term2 = combinedEntity?.entity2, headers[section] == search2 {
            return term2.articles.count
        }// TODO: check add a boolean!!!! needs to know what section
        else {return 0}

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articlecell", for: indexPath) as! ArticleTableViewCell
        if headers.count == 0{
            return cell
        }
        
        if let term1 = combinedEntity?.entity1, headers[indexPath.section] == search1  {
            cell.articleTitleLabel.text = term1.articles[indexPath.row].title
            cell.pubDateLabel.text = term1.articles[indexPath.row].title
            cell.articleInfo3Label.text = term1.articles[indexPath.row].author
            if let relevance = term1.articles[indexPath.row].entityRelevance{
            
            cell.articleInfo4Label.text = "Relevance: \(String(relevance.percentage())) "
            }
            cell.twoDetailViewController = self
            cell.url = URL(string:term1.articles[indexPath.row].url)
            
        }
    
        if let term2 = combinedEntity?.entity2, headers[indexPath.section] == search2  {
            cell.articleTitleLabel.text = term2.articles[indexPath.row].title
            cell.pubDateLabel.text = term2.articles[indexPath.row].title
            cell.articleInfo3Label.text = term2.articles[indexPath.row].author
            if let relevance = term2.articles[indexPath.row].entityRelevance{
                cell.articleInfo4Label.text = "Relevance: \(String(relevance.percentage())) "
            }
            cell.twoDetailViewController = self
            cell.url = URL(string:term2.articles[indexPath.row].url)
        }
        cell.articleInfo5Label.text = ""
        cell.twoDetailViewController = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination  = segue.destination as? WebViewController {
            var url:URL?
            if let _ = combinedEntity?.entity1, headers[(tableView.indexPathForSelectedRow?.section)!] == search1{
                url = URL(string: (combinedEntity?.entity1?.articles[(tableView.indexPathForSelectedRow?.row)!].url)!)
            }
            if let _ = combinedEntity?.entity2, headers[(tableView.indexPathForSelectedRow?.section)!] == search2{
                 url = URL(string: (combinedEntity?.entity2?.articles[(tableView.indexPathForSelectedRow?.row)!].url)!)
            }
            let request = URLRequest(url: url!)
            destination.request = request
            
        }
    }
    
    

    
}
