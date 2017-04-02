//
//  ViewOptionsTableViewController.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/29/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import UIKit

class ViewOptionsTableViewController: UITableViewController {
    @IBOutlet var viewOptionsTable: UITableView!

    var options = ["Show entities with date:", "Show entities with type:", "Show entities from articles with taxonomy:", "Show hidden entities..."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewOptionsTable.dequeueReusableCell(withIdentifier: "optionscell", for:indexPath) as! ViewOptionsTableViewCell
        cell.optionLabel.text = options[indexPath.row]
        return cell
    }

   

}
