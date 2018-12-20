//
//  CategoriesCollectionViewCell.swift
//  Ribbons
//
//  Created by Alekh Verma on 26/06/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet var categoryImage : UIImageView?
    @IBOutlet var categoryName : UILabel?
    @IBOutlet var categoryImageSuperView : UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
