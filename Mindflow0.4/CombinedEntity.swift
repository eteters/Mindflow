//
//  CombinedEntity.swift
//  Mindflow0.4
//
//  Created by Evan Teters on 3/16/17.
//  Copyright © 2017 Evan Teters. All rights reserved.
//

import Foundation

struct CombinedEntity {
    var entityName:String
    
    var entity1:Entity?
    var entity2:Entity?
    
    init(name:String, entity1:Entity?, entity2:Entity?) {
        entityName = name
        self.entity1 = entity1
        self.entity2 = entity2
    }
    
}
