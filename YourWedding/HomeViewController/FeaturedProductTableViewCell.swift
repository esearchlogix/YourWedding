//
//  FeaturedProductTableViewCell.swift
//  Ribbons
//
//  Created by Alekh Verma on 22/06/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit

class FeaturedProductTableViewCell: UITableViewCell {

    @IBOutlet var featuredCollectionView : UICollectionView?
    @IBOutlet var buttonViewAllFeaturedProduct : UIButton?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
