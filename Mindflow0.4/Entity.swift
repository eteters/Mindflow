//
//  Entity.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/9/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import Foundation
struct Entity {
    var count:Int //Will we need count per article? probably
    //var disambiguatedInfo:DisambiguatedLinks
    //var knowledgeGraph:KnowledgeGraph
    //var quotes: String
    var relevance:Double
    var sentimentType:String
    var sentimentScore: Double
    var entityName:String
    var entityType:String
    var articles = [Article]()
    var isHighlighted = false //Could also be an enum with state NONE HIDDEN HIGLIGHT
    var myHidden = false //Need this, actually/
    // Do we only pick out a unique entity once and store all doc info in here?
    //Or do we make a new entity for each article just to keep everything straight?
    //Will this make querying harder?
    //var articleCount:Int
    
    
    init(count:Int, relevance:Double, sentimentType:String, sentimentScore:Double, entityName:String, entityType:String, article:Article) {
        self.count = count
        self.relevance = relevance
        self.sentimentType = sentimentType
        self.sentimentScore = sentimentScore
        self.entityName = entityName
        self.entityType = entityType
        self.articles.append(article)
        //self.articleCount = articleCount
    }
    
    init(AylienScore count:Int, relevance:Double, entityName:String, entityTypes:[String], article:Article) {
        
        
        
    }
    
    init(AylienNoScore count:Int, entityName:String, entityTypes:[String], article:Article) {
        <#statements#>
    }
}


extension Int {
    func isLess(than: Int) -> Bool {
        return self < than
    }
}

extension Double {
    func percentage() -> Int {
        return Int(self*100)
    }
}




