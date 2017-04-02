//
//  EntitySpreadsheetViewController.swift
//  EntitySpreadsheet
//
//  Created by Shawn Moore on 3/19/17.
//  Copyright © 2017 Shawn Moore. All rights reserved.
//

import UIKit

class EntitySpreadsheetViewController: UIViewController {
    
    var entities: [Entity] = Entity.randomEntities(amount: 100)
    
    var titleColumn: SpreadsheetColumn!
    var detailColumns: [SpreadsheetColumn] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleColumn = SpreadsheetColumn(reuseIdentifier: "TextCell", title: "Entity", configurationHandler: { (rowIndex, cell) -> UICollectionViewCell in
            let entity = self.entities[rowIndex]
            
            if let cell = cell as? TextCollectionViewCell {
                cell.configure(with: entity.name)
            }
            
            return cell
        })
        
        detailColumns = [
            SpreadsheetColumn(reuseIdentifier: "TextCell", title: "Relavence", configurationHandler:  { (rowIndex, cell) -> UICollectionViewCell in
                let entity = self.entities[rowIndex]
                
                if let cell = cell as? TextCollectionViewCell {
                    cell.configure(with: "\(entity.relevance.percentage)%")
                }
                
                return cell
            }),
            SpreadsheetColumn(reuseIdentifier: "TextCell", title: "Sentiment", configurationHandler:  { (rowIndex, cell) -> UICollectionViewCell in
                let entity = self.entities[rowIndex]
                
                if let cell = cell as? TextCollectionViewCell {
                    cell.configure(with: "\(entity.sentiment.description)")
                }
                
                return cell
            }),
            SpreadsheetColumn(reuseIdentifier: "TextCell", title: "Count", configurationHandler:  { (rowIndex, cell) -> UICollectionViewCell in
                let entity = self.entities[rowIndex]
                
                if let cell = cell as? TextCollectionViewCell {
                    cell.configure(with: "\(entity.count)")
                }
                
                return cell
            }),
            SpreadsheetColumn(reuseIdentifier: "TextCell", title: "Article Count", configurationHandler:  { (rowIndex, cell) -> UICollectionViewCell in
                let entity = self.entities[rowIndex]
                
                if let cell = cell as? TextCollectionViewCell {
                    cell.configure(with: "\(entity.articleCount)")
                }
                
                return cell
            })
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EntitySpreadsheetViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return entities.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailColumns.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (indexPath.section, indexPath.item) {
        case (0, let item):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! SpreadsheetHeaderCollectionViewCell
            
            if item == 0 {
                cell.configure(with: titleColumn.title)
            } else {
                cell.configure(with: detailColumns[item - 1].title)
            }
            
            return cell
        case (let section, let item):
            let column: SpreadsheetColumn! = (item == 0 ? titleColumn : detailColumns[item - 1])
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: column.reuseIdentifier, for: indexPath)
            
            return column.configurationHandler(section - 1, cell)
        }
    }
}
