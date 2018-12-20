//
//  OrderHistoryViewController.swift
//  Ribbons
//
//  Created by Alekh Verma on 23/07/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import CoreData
class OrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet var labelOrderID : UILabel?
    @IBOutlet var labeShipingDetailCustomerName : UILabel?
    @IBOutlet var labelBillingDetailCustomerAddress : UILabel?
    @IBOutlet var labeBillingDetailCustomerName : UILabel?
    @IBOutlet var labelShipingDetailCustomerAddress : UILabel?
    @IBOutlet var labelSubTotalPrice : UILabel?
    @IBOutlet var labelShippingPrice : UILabel?
    @IBOutlet var labelDiscountPrice : UILabel?
    @IBOutlet var labelTotalPrice : UILabel?
    @IBOutlet var textViewOrderNote : UITextView?
    @IBOutlet var orderNoteSuperView : UIView?
    @IBOutlet var orderPriceDetailSuperView : UIView?
    @IBOutlet var tableViewOrderlist : UITableView?
    @IBOutlet var tableViewHeightConstraint : NSLayoutConstraint?
    @IBOutlet var scrollViewOrder : UIScrollView?
    
    var orderDict : NSDictionary? = [:]
    var listItemArray : NSArray? = []
    
    override func viewDidLoad() {
       
        //self.methodNavigationBarBackGroundColor()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            self.methodToSetNavigationBarWithoutLogoImage(title: "Log In", badgeNumber: 4)
        }catch{
            print("failed")
        }
        tableViewOrderlist?.register(UINib(nibName: "OrderDetailProductCell", bundle: nil), forCellReuseIdentifier: "orderDetailCell")

        
        listItemArray = (orderDict?.object(forKey: "line_items") as? NSArray?) ?? []
       
        tableViewOrderlist?.reloadData()
        tableViewHeightConstraint?.constant = CGFloat(((listItemArray?.count) ?? 0) * 81)
        // code for scroll view
        scrollViewOrder?.contentSize = CGSize(width: self.view.frame.size.width, height: ((tableViewHeightConstraint?.constant) ?? 70) + 500)
        scrollViewOrder?.contentInset=UIEdgeInsets(top: 0.0,left: 0.0,bottom: ((tableViewHeightConstraint?.constant) ?? 81) - 81,right: 0.0);
        scrollViewOrder?.isExclusiveTouch = false
        scrollViewOrder?.delaysContentTouches = false
      
        
        labelOrderID?.text = "Order ID : \(orderDict?.object(forKey: "id") as? Int ?? 0)"
        labeShipingDetailCustomerName?.text = (((orderDict?.object(forKey: "shipping_address") as? NSDictionary)?.object(forKey: "first_name") as? String) ?? "") + " " + (((orderDict?.object(forKey: "shipping_address") as? NSDictionary)?.object(forKey: "last_name") as? String) ?? "")
        let addressShipping1 = ((orderDict?.object(forKey: "shipping_address") as? NSDictionary)?.object(forKey: "address1") as? String) ?? ""
         let addressShipping2 = ((orderDict?.object(forKey: "shipping_address") as? NSDictionary)?.object(forKey: "address2") as? String) ?? ""
        let addressShipping3 = ((orderDict?.object(forKey: "shipping_address") as? NSDictionary)?.object(forKey: "city") as? String) ?? ""
        let addressShipping4 = ((orderDict?.object(forKey: "shipping_address") as? NSDictionary)?.object(forKey: "province") as? String) ?? ""
        let addressShipping5 = ((orderDict?.object(forKey: "shipping_address") as? NSDictionary)?.object(forKey: "zip") as? String) ?? ""
        let addressShipping6 = ((orderDict?.object(forKey: "shipping_address") as? NSDictionary)?.object(forKey: "country") as? String) ?? ""
        labelShipingDetailCustomerAddress?.text = addressShipping1  + "," + addressShipping2 + "," + addressShipping3  + ","  + addressShipping4 + ","  + addressShipping5 +  "," + addressShipping6
        
        labeBillingDetailCustomerName?.text = (((orderDict?.object(forKey: "billing_address") as? NSDictionary)?.object(forKey: "first_name") as! String) ) + " " + ((orderDict?.object(forKey: "billing_address") as? NSDictionary)?.object(forKey: "last_name") as! String)
        
        let addressBilling1 = ((orderDict?.object(forKey: "billing_address") as? NSDictionary)?.object(forKey: "address1") as? String) ?? ""
        let addressBilling2 = ((orderDict?.object(forKey: "billing_address") as? NSDictionary)?.object(forKey: "address2") as? String) ?? ""
        let addressBilling3 = ((orderDict?.object(forKey: "billing_address") as? NSDictionary)?.object(forKey: "city") as? String) ?? ""
        let addressBilling4 = ((orderDict?.object(forKey: "billing_address") as? NSDictionary)?.object(forKey: "province") as? String) ?? ""
        let addressBilling5 = ((orderDict?.object(forKey: "billing_address") as? NSDictionary)?.object(forKey: "zip") as? String) ?? ""
        let addressBilling6 = ((orderDict?.object(forKey: "billing_address") as? NSDictionary)?.object(forKey: "country") as? String) ?? ""
        labelBillingDetailCustomerAddress?.text = addressBilling1  + "," + addressBilling2 + "," + addressBilling3  + ","  + addressBilling4 + ","  + addressBilling5 +  "," + addressBilling6
        
        labelSubTotalPrice?.text = "$\(orderDict?.object(forKey: "subtotal_price") as? String ?? "0.00")"
        if ((orderDict?.object(forKey: "shipping_lines") as? NSArray)?.count ?? 0) > 0{
            labelShippingPrice?.text = "$\(((orderDict?.object(forKey: "shipping_lines") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "price") as? String ?? "0.00")"
        }else{
            labelShippingPrice?.text = "$0.00"
        }
        
        labelDiscountPrice?.text = "$\(orderDict?.object(forKey: "total_discounts") as? String ?? "0.00")"
        labelTotalPrice?.text = "$\(orderDict?.object(forKey: "total_price_usd") as? String ?? "0.00")"
        
        textViewOrderNote?.text = (orderDict?.object(forKey: "note") as? String ?? "")
        
        Utility.giveShadowEffectToView(view: orderPriceDetailSuperView!)
        Utility.giveShadowEffectToView(view: orderNoteSuperView!)

        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return (listItemArray?.count) ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewOrderlist?.dequeueReusableCell(withIdentifier: "orderDetailCell", for: indexPath) as! OrderDetailProductCell
        let data = listItemArray![indexPath.section] as? NSDictionary
        cell.labelForProductName?.text = data?.object(forKey: "title") as? String
        cell.labelForProductQuantity?.text = "\(data?.object(forKey: "quantity") ?? 0)"
        cell.LabelForSingleProductPrice?.text = data?.object(forKey: "price") as? String
        let floatPriceOri = (data?.object(forKey: "price") as? NSString)?.floatValue
        let productPrice = Float((data?.object(forKey: "quantity") as? Int) ?? 0) * floatPriceOri!
        cell.LabelForProductPrice?.text = "$ \(productPrice)"
        
        cell.labelForProductQuantity?.layer.cornerRadius = 2.0
       
        Utility.giveBorderToView(view: cell.labelForProductQuantity!, colour: UIColor.init(red: 247.0/255.0, green:166.0/255.0, blue: 28.0/255.0, alpha: 1.0))
        Utility.giveBorderToView(view: cell.cellView!, colour: UIColor.darkGray)
        cell.selectionStyle = .none
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footerView : UIView?
        footerView?.backgroundColor = UIColor.white
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
