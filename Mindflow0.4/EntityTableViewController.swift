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
    
    @IBAction func relInfo(_ sender: Any) {
        
    }
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
                //self.entityTable.provideImageData(<#T##data: UnsafeMutableRawPointer##UnsafeMutableRawPointer#>, bytesPerRow: <#T##Int#>, origin: <#T##Int#>, <#T##y: Int##Int#>, size: <#T##Int#>, <#T##height: Int##Int#>, userInfo: <#T##Any?#>)
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
    
    var historyPass = [History]()
    
    var sortOption = 1
    
    var searchTerm = ""
    
    var searchDone = false
    
    var sortChanged = false
    
    var historyDelegate:SearchViewController?
    
    var days = ""
    
    let posColor = 0xB1F2F0
    let negColor = 0xCFF69D
    
    
    //THE ORDER var options = ["Relevance","Sentiment Score", "Alphabetically", "Number of Mentions", "Number of Articles"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let HeaderView = entityTable.tableHeaderView as? HeaderView {
//            
//        }
    
        
        self.title = searchTerm
        
        if (!searchDone){
            AlchemyNewsGetter.start = days
            AlchemyNewsGetter.search(searchText: searchTerm, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main, completionHandler: { (userInfo, entities, articles, errorString) in
                if errorString != nil {
                    print(errorString!)
                    self.entities = nil
                    self.articles = nil
                    if errorString == "server did not return OK" {
                     self.retrySearch()
                    }
                }
                else {
                    self.entities = entities
                    self.articles = articles
                    self.entities = entities?.sorted(by: { (ent1, ent2) -> Bool in
                        return !ent1.count.isLess(than: ent2.count)// == ComparisonResult.orderedAscending
                        
                    })
                    self.historyDelegate?.historyPass.append(History(term: self.searchTerm, ents: self.entities))
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
        
        
        let relevance = entities?[indexPath.row].relevance.percentage()
        if let relevance = relevance{
            cell.relevanceLabel.text = String(format: "%d", relevance) + "%"
            
        }
        
        
        
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let highlight:UITableViewRowAction
        guard let ents = entities?[indexPath.row] else {
            return nil
        }
        if ents.isHighlighted {
            highlight = UITableViewRowAction(style: .default, title: "de-Highlight", handler: { (UITableViewRowAction, indexPath) in
                UITableViewRowAction.backgroundColor = UIColor.white
                let cell = self.entityTable.cellForRow(at: indexPath) as? EntityTableViewCell
                cell?.backgroundColor = UIColor.white
                self.entities?[indexPath.row].isHighlighted = false
            })
            
        }
        else {
            
            highlight = UITableViewRowAction(style: .default, title: "Highlight") { (UITableViewRowAction, indexPath) in
                let cell = self.entityTable.cellForRow(at: indexPath) as? EntityTableViewCell
                cell?.backgroundColor = UIColor(netHex: 0xFFFD90)
                self.entities?[indexPath.row].isHighlighted = true
                UITableViewRowAction.backgroundColor = UIColor(netHex: 0xFFFD90)
                
            }
        }
        let hide = UITableViewRowAction(style: .default, title: "Hide") { (UITableViewRowAction, indexPath) in
            let cell = self.entityTable.cellForRow(at: indexPath) as? EntityTableViewCell
            cell?.isHidden = true
            UITableViewRowAction.backgroundColor = UIColor(netHex: 0xFFFD90)
            
        }
        
        return[highlight, hide]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EntityDetailViewController{
            if let entities = entities {
                destination.entity = entities[(entityTable.indexPathForSelectedRow?.row)!] //weird unwrapping but okay?
                destination.entityPass  = entities
                destination.term1Pass = searchTerm
                destination.historyDelegate = self.historyDelegate
            }
            
        }
//        if let destination = segue.destination as? SortTableViewController {
//            destination.delegate = self
//            destination.numSelected = sortOption
//        }
        if let destination = segue.destination as? OptionsTableViewController {
            destination.previousViewController = self
            destination.historyDelegate = self.historyDelegate
        }
        
    }
    
    func retrySearch(){
        if AlchemyNewsGetter.currentKey < AlchemyNewsGetter.apiKeys.count {
            AlchemyNewsGetter.currentKey += 1
        }
        else {
            self.title = "Out of keys"
            return
        }
        
        AlchemyNewsGetter.start = days
        AlchemyNewsGetter.search(searchText: searchTerm, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main, completionHandler: { (userInfo, entities, articles, errorString) in
            if errorString != nil {
                print(errorString!)
                self.entities = nil
                self.articles = nil
                if errorString == "server did not return OK" {
                    self.retrySearch()
                }
            }
            else {
                self.entities = entities
                self.articles = articles
                self.entities = entities?.sorted(by: { (ent1, ent2) -> Bool in
                    return !ent1.relevance.isLess(than: ent2.relevance)// == ComparisonResult.orderedAscending
                    
                })
                self.historyDelegate?.historyPass.append(History(term: self.searchTerm, ents: self.entities))
                self.entityTable.reloadData()
            }
        })
        searchDone = true
        
    }
    

}
