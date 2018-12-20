//
//  OfferListTableViewCell.swift
//  Ribbons
//
//  Created by Alekh Verma on 20/07/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit

class OfferListTableViewCell: UITableViewCell {
    @IBOutlet var labelName : UILabel?
    @IBOutlet var labelPrice : UILabel?
    @IBOutlet var labelQuantity : UILabel?
    @IBOutlet var imageProduct : UIImageView?
    @IBOutlet var imageSuperView : UIView?
    @IBOutlet var cellView: UIView?
    @IBOutlet var buttonRefund : UIButton?
    @IBOutlet var buttonTrackOrder : UIButton?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
