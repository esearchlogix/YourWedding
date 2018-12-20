//
//  Section.swift
//  ExpendableTableView
//
//  Created by Alekh Verma on 08/06/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import Foundation

struct Section{
    var category : String?
    var subCategory : [String]?
    var subCategoryImage : [String]?
    var Ids : [UInt64]?
    var expended :  Bool?
    var colorFilter : [String]?
    var sizeFilter : [String]?
    var  shapeFilter : [String]?
    
    init(category: String, subCategory : [String], colorFilter : [String], sizeFilter : [String], shapeFilter : [String],subCategoryImage : [String], id: [UInt64], expended : Bool) {
        self.category = category
        self.subCategory = subCategory
           self.colorFilter = colorFilter
           self.sizeFilter = sizeFilter
           self.shapeFilter = shapeFilter
        self.subCategoryImage = subCategoryImage
        self.Ids = id
        self.expended = expended
    }
}
