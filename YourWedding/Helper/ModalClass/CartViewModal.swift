//
//  CartViewModal.swift
//  Ribbons
//
//  Created by Alekh Verma on 24/07/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit

class CartViewModal: NSObject {
 
    var productName:String?
    var productPrice:String?
    var productQuantity:Int?
    var productImageUrl:String?

    init(arraCart:NSDictionary? , quantity:Int?) {
        
        super.init()
        
        
        productName = (arraCart as AnyObject).value(forKey: "title") as? String
        productPrice = (((arraCart as AnyObject).value(forKey: "variants") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "price") as? String
        productImageUrl = (((arraCart as AnyObject).value(forKey: "images") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "src") as? String
        productQuantity = quantity
    }
    
    
    
    
}
