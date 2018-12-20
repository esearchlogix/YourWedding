//
//  ImageTemplateTableViewCell.swift
//  Ribbons
//
//  Created by Alekh Verma on 26/06/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit

class ImageTemplateTableViewCell: UITableViewCell {
    @IBOutlet var imageViewTemp : UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
