//
//  OrderDetailProductCell TableViewCell.swift
//  PetStylo
//
//  Created by Alekh Verma on 01/10/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit

class OrderDetailProductCell: UITableViewCell {
    
    @IBOutlet var labelForProductName : UILabel?
    @IBOutlet var labelForProductQuantity : UILabel?
    @IBOutlet var LabelForSingleProductPrice : UILabel?
    @IBOutlet var LabelForProductPrice : UILabel?
    @IBOutlet var cellView : UIView?
    

    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
