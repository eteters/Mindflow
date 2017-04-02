//
//  StationaryExpandingAboveTextViewController.swift
//  TwoComparisonsPrototype
//
//  Created by Shawn Moore on 2/26/17.
//  Copyright © 2017 Shawn Moore. All rights reserved.
//

import UIKit

class StationaryExpandingAboveTextViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var termOneLabel: UILabel?
    @IBOutlet weak var termTwoLabel: UILabel?
    @IBOutlet weak var rightFacingArrowImageView: UIImageView!
    @IBOutlet weak var leftFacingArrowImageView: UIImageView!
    @IBOutlet weak var leftLabelView: UIView!
    @IBOutlet weak var rightLabelView: UIView!
    
  
    var searchDone = false
    
    var termOne: String = "" {
        didSet {
            termOneLabel?.text = termOne
        }
    }
    
    var termTwo: String = "" {
        didSet {
            termTwoLabel?.text = termTwo
        }
    }
    
    
    var leftTruncationStatus = false
    var rightTruncationStatus = false
    
    var historyDelegate:SearchViewController?
    
    
    var entities1:[Entity]? {
        didSet {
            leftTruncationStatus = termOneLabel?.isTruncating ?? false
            
            if leftTruncationStatus {
                rightFacingArrowImageView.isHidden = false
            }
            
            rightTruncationStatus = termTwoLabel?.isTruncating ?? false
            
            if rightTruncationStatus {
                leftFacingArrowImageView.isHidden = false
            }

            if (!searchDone) {
                
            
                AlchemyNewsGetter.search(searchText: termTwo, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main, completionHandler: { (userInfo, entities, articles, errorString) in
                    if errorString != nil {
                        print(errorString!)
                        self.entities2 = nil
                        self.articles = nil
                        if errorString == "server did not return OK" {
                            self.retrySearch()
                        }

                    }
                    else {
                        self.entities2 = entities
                        self.articles = articles
                        //                self.entities2 = entities?.sorted(by: { (ent1, ent2) -> Bool in
                        //                    return !ent1.count.isLess(than: ent2.count)// == ComparisonResult.orderedAscending
                        //
                        //                })
                        for entityCompare in self.entities2! {
                            if let entity = self.entities1?.first(where: {$0.entityName == entityCompare.entityName}) {
                                self.combinedArray.append(CombinedEntity(name: entityCompare.entityName, entity1: entityCompare, entity2: entity))
                            }
                            else {
                                self.combinedArray.append(CombinedEntity(name: entityCompare.entityName, entity1: nil, entity2: entityCompare))
                            }
                            
                            
                            
                        }
                        
                        var uniqueElements = self.entities1?.filter({ (entity) -> Bool in
                            return !(self.entities2?.contains(where: {$0.entityName == entity.entityName}) ?? false )
                        }) ?? []
                        
                        
                        for element in uniqueElements {
                            self.combinedArray.append(CombinedEntity(name: element.entityName, entity1: element, entity2: nil))
                        }
                        //Adding to the history
                        self.historyDelegate?.historyPass.append(History(term1:self.termOne, term2: self.termTwo, entCompares:self.combinedArray))
                        
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    var entities2:[Entity]?
    var articles:[Article]?
    var combinedArray: [CombinedEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "" //termOne + "And" + termTwo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        termOneLabel?.text = termOne
        termTwoLabel?.text = termTwo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combinedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let result = combinedArray[indexPath.row]
        
        if let term1 = result.entity1, let term2 = result.entity2{
            (cell as? ComparisonTableViewCell)?.configure(withTitle: result.entityName, relevance1: term1.relevance, relevance2: term2.relevance)
            
        }
        else if let term1 = result.entity1 {
            (cell as? ComparisonTableViewCell)?.configure(withTitle: result.entityName, relevance1: term1.relevance, relevance2: 0)
            
        }
        else if let term2 = result.entity2 {
            (cell as? ComparisonTableViewCell)?.configure(withTitle: result.entityName, relevance1: 0, relevance2: term2.relevance)
            
        }
        
        
        
        
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    @IBAction func showFullLeftLabel(_ sender: UITapGestureRecognizer) {
        guard leftTruncationStatus else { return }
        
        rightFacingArrowImageView.image = rightLabelView.isHidden ? UIImage(named: "Right Arrow") : UIImage(named: "Left Arrow")
        
        rightLabelView.isHidden = !rightLabelView.isHidden
    }
    
    @IBAction func showFullRightLabel(_ sender: UITapGestureRecognizer) {
        guard rightTruncationStatus else { return }
        
        leftFacingArrowImageView.image = leftLabelView.isHidden ? UIImage(named: "Left Arrow") : UIImage(named: "Right Arrow")
        
        leftLabelView.isHidden = !leftLabelView.isHidden
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CompareDetailViewController {
            destination.combinedEntity = combinedArray[(tableView.indexPathForSelectedRow?.row)!]
            destination.search1 = termTwo
            destination.search2 = termOne
        }
        if let destination = segue.destination as? OptionsTableViewController {
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
        
        AlchemyNewsGetter.search(searchText: termTwo, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main, completionHandler: { (userInfo, entities, articles, errorString) in
            if errorString != nil {
                print(errorString!)
                self.entities2 = nil
                self.articles = nil
                if errorString == "server did not return OK" {
                    self.retrySearch()
                }
            }
            else {
                self.entities2 = entities
                self.articles = articles
                self.entities2 = entities?.sorted(by: { (ent1, ent2) -> Bool in
                    return !ent1.count.isLess(than: ent2.count)// == ComparisonResult.orderedAscending
                    
                })
                self.historyDelegate?.historyPass.append(History(term: self.termTwo, ents: self.entities2))
                self.tableView.reloadData()
            }
        })
        searchDone = true
        
    }

    
    
    
}
