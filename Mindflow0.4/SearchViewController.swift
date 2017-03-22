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
            destination.searchTerm = searchField.text!
        }
        else if let destination = segue.destination as? StationaryExpandingAboveTextViewController {
            guard let text = searchField.text else {
                return
            }
            guard let text2 = compareSearchField.text else {
                return
            }
            AlchemyNewsGetter.search(searchText: text, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main, completionHandler: { (userInfo, entities, articles, errorString) in
                if errorString != nil {
                    print(errorString!)
                    destination.entities1 = nil
                }
                else {
                    destination.entities1 = entities
                    destination.termOne = text
                    destination.termTwo = text2
                }
            })

        }
        
    }
    
}
