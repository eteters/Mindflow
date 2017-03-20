//
//  SortTableViewController.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/12/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit

class SortTableViewController: UITableViewController {

    //weak var delegate: sortTableViewDelegate?

    var numSelected = 0
    
    weak var delegate: sortTableViewDelegate?

    
    @IBOutlet var sortTable: UITableView!
    //TODO: todo: add descending/ascending
    let options = ["Relevance","Sentiment Score", "Alphabetically", "Number of Mentions", "Number of Articles"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
    }

    func back(sender: UIBarButtonItem) {
        
        if let row = sortTable.indexPathForSelectedRow?.row {
            delegate?.sortWasSelected(row)
        }

        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortcell", for: indexPath) as! SortTableViewCell
        
        cell.optionLabel.text = options[indexPath.row]
        
        if indexPath.row == numSelected {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if(self.isMovingFromParentViewController) {
            if let row = sortTable.indexPathForSelectedRow?.row {
                delegate?.sortWasSelected(row)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    

}
