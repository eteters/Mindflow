//
//  HistoryTableViewController.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/28/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    @IBOutlet var historyTable: UITableView!

    var historyDelegate:SearchViewController?{
        didSet{
            if let history = historyDelegate?.historyPass{
                self.history = history
                
            }
        }
    }
    var history:[History]?
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTable.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let history = history {
            return history.count

        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "historycell", for: indexPath) as! HistoryTableViewCell
        
        guard let hist = history else { return cell }
        if hist[indexPath.row].crossSearch {
            cell.termLabel.text = hist[indexPath.row].term1 + " x " + hist[indexPath.row].term2!
            if let entcomps = hist[indexPath.row].entityCompares {
                cell.numResultLabel.text = "\(entcomps.count)"
            }
            else {
                cell.numResultLabel.text = "0"
            }
            
        }
        else{
            cell.termLabel.text = hist[indexPath.row].term1
            if let ents = hist[indexPath.row].entities {
                cell.numResultLabel.text = "\(ents.count)"

            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let history = history {
            if history[indexPath.row].crossSearch{
                performSegue(withIdentifier: "crosssearch", sender: self)
            }
            else {
                performSegue(withIdentifier: "singlesearch", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EntityTableViewController{
            destination.searchDone = true
            if let term = history?[(historyTable.indexPathForSelectedRow?.row)!].term1{
                destination.searchTerm = term
            }
            destination.entities = history?[(historyTable.indexPathForSelectedRow?.row)!].entities
            
        }
        else if let destination = segue.destination as? StationaryExpandingAboveTextViewController {
            destination.searchDone = true
            destination.termOne = (history?[(historyTable.indexPathForSelectedRow?.row)!].term1)!
            destination.termTwo = (history?[(historyTable.indexPathForSelectedRow?.row)!].term2)!
            destination.combinedArray = (history?[(historyTable.indexPathForSelectedRow?.row)!].entityCompares)! //This horrible mess SHOUUUUld be fine?
        }
    }

   
}
