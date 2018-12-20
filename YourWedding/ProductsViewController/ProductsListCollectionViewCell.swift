//
//  ProductsListCollectionViewCell.swift
//  Ribbons
//
//  Created by Alekh Verma on 02/07/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit

class ProductsListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var productimage : UIImageView?
    @IBOutlet var productName : UILabel?
    @IBOutlet var productRate :  UILabel?
    @IBOutlet var productShadowView : UIView?
    @IBOutlet var productAvailableLabel : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
