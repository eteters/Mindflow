//
//  History.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/28/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import Foundation

class History {
    var term1:String
    var term2:String?
    var entities:[Entity]?
    var entityCompares:[CombinedEntity]?
    var crossSearch:Bool
    
    //For a single search
    init(term:String, ents: [Entity]?) {
        self.term1 = term
        term2 = nil
        entities = ents
        crossSearch = false
    }
    
    //For a cross search
    init(term1:String, term2:String, entCompares:[CombinedEntity]?) {
        self.term1 = term1
        self.term2 = term2
        self.entityCompares = entCompares
        crossSearch = true
    }
    
    
}
