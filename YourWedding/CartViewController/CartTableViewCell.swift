//
//  CartTableViewCell.swift
//  Ribbons
//
//  Created by Alekh Verma on 25/07/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet var productImage : UIImageView?
    @IBOutlet var productImageSuperView : UIView?
    @IBOutlet var productName : UILabel?
    @IBOutlet var productPrice : UILabel?
    @IBOutlet var productQuantitiView : UIView?
    @IBOutlet var productQuantityLabel : UILabel?
    @IBOutlet var productCrossButton : UIButton?
    @IBOutlet var positiveCounter : UIButton?
    @IBOutlet var negativeCounter : UIButton?
    @IBOutlet var labelShippingCharge : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
