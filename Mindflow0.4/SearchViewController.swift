//
//  SearchViewController.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/9/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit
import CoreGraphics

class SearchViewController: UIViewController {
    
    var entities:[Entity]?
    var articles:[Article]?
    var compareTerm = ""
    var historyPass:[History] = []

    @IBOutlet weak var searchSwitch: UISwitch!
    @IBOutlet weak var dateSwitch: UISwitch!
    @IBOutlet weak var compareSearchField: UITextField!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var unHideButton: UIButton!

    @IBAction func showCompare(_ sender: Any) {
        
        compareButton.isHidden = false
        compareSearchField.isHidden = false
        
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? EntityTableViewController{
            destination.searchDone = false
            destination.searchTerm = searchField.text!
            //destination.historyPass = self.historyPass
            destination.historyDelegate = self
            if dateSwitch.isOn {
                destination.days = "now-30d"
            }
            else {
                destination.days = "now-1d"
            }
            if searchSwitch.isOn {
                destination.aylien  = true
            }
        }
        else if let destination = segue.destination as? StationaryExpandingAboveTextViewController {
            guard let text = searchField.text else {
                return
            }
            guard let text2 = compareSearchField.text else {
                return
            }
            compareTerm = text2
            AlchemyNewsGetter.search(searchText: text, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main, completionHandler: { (userInfo, entities, articles, errorString) in
                if errorString != nil {
                    print(errorString!)
                    if errorString == "server did not return OK" {
                        self.retrySearch()
                    }
                    destination.entities1 = nil
                }
                else {
                    destination.historyDelegate = self
                    //destination.entities1 = entities
                    destination.termOne = text
                    destination.termTwo = text2
                    destination.entities1 = entities
                    //destination.tableView.reloadData()
                    
                }
            })

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
        
        AlchemyNewsGetter.search(searchText: self.compareTerm, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main, completionHandler: { (userInfo, entities, articles, errorString) in
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
                self.historyPass.append(History(term: self.compareTerm, ents: self.entities))
                
            }
        })
        
    }
    
}
