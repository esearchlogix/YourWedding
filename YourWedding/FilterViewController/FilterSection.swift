//
//  FilterSection.swift
//  Ribbons
//
//  Created by Alekh Verma on 10/07/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import Foundation

struct FilterSection{
    var category : String?
    var subCategory : [String]?
    
    var expended :  Bool?
    
    init(category: String, subCategory : [String],expended : Bool) {
        self.category = category
        self.subCategory = subCategory
       
        self.expended = expended
    }
}
