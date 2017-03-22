//
//  EntityTableViewController.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/9/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit


//I'll just stick this here for now, this is the class that uses it
protocol sortTableViewDelegate: class {
    func sortWasSelected(_ data:Int)
}


class EntityTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, sortTableViewDelegate {
    
    //needs internal?
    //MARk: Mark: does sorting
    func sortWasSelected(_ data: Int) {
        sortOption = data
        sortChanged = true
        
        if (sortChanged){
            switch sortOption {
            case 0:
                //Relevance sort, repeated code?
                self.entities = entities?.sorted(by: { (ent1, ent2) -> Bool in
                    return !ent1.relevance.isLess(than: ent2.relevance)// == ComparisonResult.orderedAscending
                    
                })
                self.entityTable.reloadData()
                sortChanged = false
                break;
                
            case 1:
                //Sentiment Sort
                self.entities = entities?.sorted(by: { (ent1, ent2) -> Bool in
                    return !ent1.sentimentScore.isLess(than: ent2.sentimentScore)// == ComparisonResult.orderedAscending
                    
                })
                self.entityTable.reloadData()
                sortChanged = false
                break;
                
            case 2:
                //Alphabet sort
                self.entities = entities?.sorted(by: { (ent1, ent2) -> Bool in
                    return !(ent1.entityName < ent2.entityName) //.isLess(than: ent2.entityName)// == ComparisonResult.orderedAscending
                    
                })
                self.entityTable.reloadData()
                sortChanged = false
                break;
                
            case 3:
                self.entities = entities?.sorted(by: { (ent1, ent2) -> Bool in
                    return !ent1.count.isLess(than: ent2.count)// == ComparisonResult.orderedAscending
                    
                })
                self.entityTable.reloadData()
                sortChanged = false
                break;
            case 4:
                self.entities = entities?.sorted(by: { (ent1, ent2) -> Bool in
                    return !ent1.articles.count.isLess(than: ent2.articles.count)// == ComparisonResult.orderedAscending
                    
                })
                self.entityTable.reloadData()
                sortChanged = false
                break;
                
                
            default:
                //invalid sort? Shouldn't get here.
                break;
            }
            
        }
        
    }

    
    @IBOutlet weak var entityTable: UITableView!
    
    var entities:[Entity]?
    
    var articles:[Article]?
    
    var sortOption = 1
    
    var searchTerm = ""
    
    var searchDone = false
    
    var sortChanged = false
    
    let posColor = 0xB1F2F0
    let negColor = 0xCFF69D
    
    
    //THE ORDER var options = ["Relevance","Sentiment Score", "Alphabetically", "Number of Mentions", "Number of Articles"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let HeaderView = entityTable.tableHeaderView as? HeaderView {
                HeaderView.searchTitle.text = searchTerm
            }
        
        
        self.title = searchTerm
        
        if (!searchDone){
            AlchemyNewsGetter.search(searchText: searchTerm, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main, completionHandler: { (userInfo, entities, articles, errorString) in
                if errorString != nil {
                    print(errorString!)
                    self.entities = nil
                    self.articles = nil
                }
                else {
                    self.entities = entities
                    self.articles = articles
                    self.entities = entities?.sorted(by: { (ent1, ent2) -> Bool in
                        return !ent1.count.isLess(than: ent2.count)// == ComparisonResult.orderedAscending
                        
                    })
                    self.entityTable.reloadData()
                }
            })
            searchDone = true
        }
        
        
        else{
            //do nothing if navigated back here and search has already been done and sort has not been changed? 
        }

        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entitycell", for: indexPath) as! EntityTableViewCell
        
        cell.entityText.text = entities?[indexPath.row].entityName
        
        //let relString = String(describing: entities?[indexPath.row].relevance) as String
        
        
        let relevance = entities?[indexPath.row].relevance
        if let relevance = relevance{
            let rel = Float(relevance)
            //rel = Float(round((100+rel)/100))
            cell.relevanceLabel.text = String(format: "%.2f", rel) //How to get 2 decimal points?
            cell.infoBar.progress = rel
        }
        else {cell.infoBar.progress = 0}
        
        
        //cell.infoBar.progress = entities[indexPath.row].relevance! as Float
        let sentiment = entities?[indexPath.row].sentimentType
        if sentiment == "negative" {
            cell.backgroundColor = UIColor(netHex: negColor)
            //cell.infoBar.progressTintColor = UIColor(netHex: 0xfab43f) //neg:fab43f pos:a9c326
        }
            
        else if sentiment == "positive" {
            cell.backgroundColor = UIColor(netHex: posColor)
            //cell.infoBar.progressTintColor = UIColor(netHex: 0xa9c326)
        }
            
        else {
            //cell.infoBar.progressTintColor = UIColor.gray
        }
        cell.infoBar.setProgress(cell.infoBar.progress, animated: true)
        
        return cell
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let entities = entities {
            return entities.count
        }
        else {return (1)} //Hopefully this doesn't happen? Empty cell. Can be zero?
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EntityDetailViewController{
            if let entities = entities {
                destination.entity = entities[(entityTable.indexPathForSelectedRow?.row)!] //weird unwrapping but okay?
                destination.entityPass  = entities
                destination.term1Pass = searchTerm
            }
            
        }
//        if let destination = segue.destination as? SortTableViewController {
//            destination.delegate = self
//            destination.numSelected = sortOption
//        }
        if let destination = segue.destination as? OptionsTableViewController {
            destination.previousViewController = self 
        }
        
    }
    

}
