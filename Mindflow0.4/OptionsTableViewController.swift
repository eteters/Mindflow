//
//  OptionsTableViewController.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/19/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit

class OptionsTableViewController: UITableViewController {

    let headers = ["Sort By","View Options", "History"]
    
    var numSelected = 0
    
    //weak var delegate: optionTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optioncell", for: indexPath) as! OptionsTableViewCell
        
        cell.optionTitle.text = headers[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "sortsegue", sender: self)
            
            break
        case 1:
            performSegue(withIdentifier: "viewoptionssegue", sender: self)
            break
        case 2:
            performSegue(withIdentifier: "historysegue", sender: self)
            break
            
            
        default:
            return //never happens
        }
    }
    
}
