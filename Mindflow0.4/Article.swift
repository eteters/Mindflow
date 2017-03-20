//
//  Article.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/9/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import Foundation
struct Article {
    var title:String
    var url:String
    var author:String?
    var pubDate:Date?
    var entityRelevance:Double?
    
    init(title:String, url:String, author:String, pubDate:Date) {
        self.title = title
        //TODO: Set this to a real url in the init?
        self.url = url
        self.author = author
        self.pubDate = pubDate
    }
    
    mutating func addEntityRelevance(relevance:Double) -> Bool {
        entityRelevance = relevance
        return true
    }
}
