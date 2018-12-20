//
//  NotificationTableViewCell.swift
//  Ribbons
//
//  Created by Alekh Verma on 12/10/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet var lablelDate : UILabel?
    @IBOutlet var lablelBody : UILabel?
    @IBOutlet var lablelTitle : UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
