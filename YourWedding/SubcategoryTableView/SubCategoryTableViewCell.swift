//
//  SubCategoryTableViewCell.swift
//  YourWedding
//
//  Created by Alekh Verma on 30/11/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit

class SubCategoryTableViewCell: UITableViewCell {

    @IBOutlet var superViewCategory : UIView?
    @IBOutlet var imageViewCategory : UIImageView?
    @IBOutlet var categoryName : UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
