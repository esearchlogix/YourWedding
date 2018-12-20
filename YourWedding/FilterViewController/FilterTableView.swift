//
//  FilterTableView.swift
//  Ribbons
//
//  Created by Alekh Verma on 10/07/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit

protocol FilterTableViewdelegate {
    func toggleSection(header:FilterTableView, section: Int)
}

class FilterTableView: UITableViewHeaderFooterView {

    @IBOutlet var labelText : UILabel?
    var delegate : FilterTableViewdelegate?
    var section : Int?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        Utility.giveShadowEffectToView(view: self)
        // self.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(headerAction)))
    }
    
    @IBAction func buttonClick(sender: UIButton){
        print("button clicked")
        let cell = sender.superview?.superview as! FilterTableView
        delegate?.toggleSection(header: self, section: cell.section!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // self.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(headerAction)))
        
    }
    @objc func headerAction(gestureRecognizer: UIGestureRecognizer) {
        
        let cell = gestureRecognizer.view as! ExpendableTableView
        delegate?.toggleSection(header: self, section: cell.section!)
        
    }
    
    func customInit(title:String, section: Int, delegate:FilterTableViewdelegate ) {
        self.labelText?.text = title
        
        self.section = section
        self.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.labelText?.textColor =  UIColor.white
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
