//
//  CartViewController.swift
//  Ribbons
//
//  Created by Alekh Verma on 28/06/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD
import WebKit

class CartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate {
    
    @IBOutlet var tableViewcart: UITableView?
    @IBOutlet var labelTotalPrice : UILabel?
 
    @IBOutlet var heighConstraintTable : NSLayoutConstraint?
    @IBOutlet var viewForEmptyCart : UIView?
    @IBOutlet var shopNowButton : UIButton?
      fileprivate var collections: PageableArray<CollectionViewModel>!
    var cartItemArray : [Any]? = []
    var totalPrice : Float? = 0
  
    var emailId : String?


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
             //self.methodToSetSideMenuButtonInNavigationBarWithPopBack(badgeNumber: result.count)
            
        }catch{
            print("failed")
        }
        
       self.navigationController?.navigationBar.isHidden = true
       
        self.methodToSetBottamNavigationBar(title: "My Cart")
        //self.methodNavigationBarBackGroundColor()
        
        tableViewcart?.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "cartCell")
       
        Utility.giveShadowEffectToView(view: shopNowButton!)
        fetchCartItems()
        // Do any additional setup after loading the view.
    }

    
  

     // MARK: - fetchCartIems
    func fetchCartItems(){
        MBProgressHUD.showAdded(to: self.view, animated: true)

        totalPrice = 0
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            if result.count == 0{
            viewForEmptyCart?.isHidden = false
                tableViewcart?.isHidden = true
                
               
            }else{
                viewForEmptyCart?.isHidden = true
                tableViewcart?.isHidden = false
            cartItemArray = result
            totalPrice = 0.0
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "productPrice") as! String)
                let quantity = data.value(forKey: "quantity") as! Int
                let price = data.value(forKey: "productPrice") as! String
                let floatPrice = price.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
                let floatPriceOri = (floatPrice as? NSString)?.floatValue
                let productPrice = Float(quantity) * floatPriceOri!
                totalPrice = totalPrice! + productPrice
                
            }
                if cartItemArray?.count == 1{
                heighConstraintTable?.constant = 280
                }else if cartItemArray?.count == 2{
                  heighConstraintTable?.constant = 140
                }else{
                    heighConstraintTable?.constant = 0
                }
                tableViewcart?.reloadData()
                labelTotalPrice?.text = "Subtotal : $ \(totalPrice ?? 0.00)"
            }
            
        } catch {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            print("Failed")
        }
        
    }

// MARK: - tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
      
        return (cartItemArray?.count)!
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 129
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
            return 1
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableViewcart?.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        let data = cartItemArray![indexPath.section] as? NSManagedObject
        cell.labelShippingCharge?.text = data?.value(forKey: "shippingCharge") as? String
        cell.productName?.text = data?.value(forKey: "productName") as? String //
        cell.productPrice?.text = "\(data?.value(forKey: "productPrice") as? String ?? "0.00")"
        cell.productQuantityLabel?.text = "\(data?.value(forKey: "quantity") as? Int ?? 0)"
        let imageUrl = data?.value(forKey: "productImageUrl") as? String
        cell.productImage?.sd_setImage(with: URL(string: imageUrl ?? "" ))
        
        cell.negativeCounter?.tag = 100 + indexPath.section
        cell.negativeCounter?.addTarget(self, action: #selector(self.negativeButtonClicked), for: .touchUpInside)

        cell.positiveCounter?.tag = 1000 + indexPath.section
        cell.positiveCounter?.addTarget(self, action: #selector(self.positiveButtonClicked), for: .touchUpInside)
        
        cell.productCrossButton?.tag =  indexPath.section
        cell.productCrossButton?.addTarget(self, action: #selector(self.crossButtonClicked), for: .touchUpInside)
    
        
        //Utility.giveBorderToView(view: cell.productQuantitiView!, colour: UIColor.lightGray)
        Utility.giveBorderToView(view: cell.contentView, colour: UIColor.lightGray)
        Utility.giveShadowEffectToView(view: cell.productImage!)
        
        cell.selectionStyle = .none
            return cell
            
    
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var headerView : UIView?
        headerView?.backgroundColor = UIColor(red: 235.0/255.0, green:235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        return headerView
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 10
    }

// MARK: - button Action
    
   @objc func crossButtonClicked(sender: UIButton!) {
        context.delete((cartItemArray![sender.tag] as? NSManagedObject)!)
        cartItemArray?.remove(at: sender.tag)
         fetchCartItems()
    }
    
    @objc func negativeButtonClicked(sender: UIButton!) {
     
        let tagValue = sender.tag % 100
        let data = cartItemArray![tagValue] as? NSManagedObject
        let cell = tableViewcart?.cellForRow(at: IndexPath(row: 0, section: tagValue)) as? CartTableViewCell
        var currentValue = Int((cell?.productQuantityLabel?.text)!)
        
        if currentValue! > 1{
            currentValue = currentValue! - 1
            cell?.productQuantityLabel?.text = "\(currentValue ?? 0)"
        }
        updateTotalPrice(clickedCell: cell, currentItem: currentValue!, tag: tagValue)

    }
     @objc func positiveButtonClicked(sender: UIButton!) {
               let tagValue = sender.tag % 100
        let data = cartItemArray![tagValue] as? NSManagedObject
        var cell = tableViewcart?.cellForRow(at: IndexPath(row: 0, section: tagValue)) as? CartTableViewCell
        var currentValue = Int((cell?.productQuantityLabel?.text)!)
        let maxvalue = data?.value(forKey: "maxQuantity") as? Int
        
        if currentValue! < maxvalue!{
            currentValue = currentValue! + 1
             cell?.productQuantityLabel?.text = "\(currentValue ?? 0)"
            
        }else{
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Only \(maxvalue!) Products available for this Category", withController: self)
        }
        updateTotalPrice(clickedCell: cell, currentItem: currentValue!, tag: tagValue)
    }
    
    func updateTotalPrice(clickedCell : CartTableViewCell? , currentItem : Int, tag : Int){
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let result = try? context.fetch(fetchRequest)
        let resultData = result as! [NSManagedObject]
        var index = 0
        resultData[tag].setValue(currentItem, forKey: "quantity")
    
        do {
       
            try context.save()
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
             fetchCartItems()
        }
            
        catch let error as NSError  {
            print("Not able to update value right now")
        }
        
//        var index = 0
//        totalPrice = 0.0
//
//        for data in cartItemArray as! [NSManagedObject] {
//            print(data.value(forKey: "productPrice") as! String)
//            var cell : CartTableViewCell?
//            cell = tableViewcart?.cellForRow(at: IndexPath(row: 0, section: index)) as? CartTableViewCell
//            if cell == nil || cell == CartTableViewCell(){
//                tableViewcart?.scrollToRow(at: IndexPath(row: 0, section: index), at: .bottom , animated: true)
//                cell = tableViewcart?.cellForRow(at: IndexPath(row: 0, section: index)) as? CartTableViewCell
//            }else{
//
//            }
//            let quantity = Int((cell?.productQuantityLabel?.text)!)
//11
//            let price = data.value(forKey: "productPrice") as! String
//            let floatPrice = price.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
//            let floatPriceOri = (floatPrice as? NSString)?.floatValue
//            let productPrice = Float(quantity!) * floatPriceOri!
//            totalPrice = totalPrice! + productPrice
//            index = index + 1
//
//        }
//        labelTotalPrice?.text = "Subtotal : $ \(totalPrice ?? 0.00)"

    }
    @IBAction func shopNowButtonAction(sender : UIButton){
        let navigationController = UINavigationController(rootViewController:  CustomTabBarViewController())
        
        UIApplication.shared.delegate?.window??.rootViewController  = navigationController
    }
    
    @IBAction func continueButtonAction(sender : UIButton){
        MBProgressHUD.showAdded(to: self.view, animated: true)

        Client.shared.createCheckOutCart(with: cartItemArray!, activeViewController: self){ checkout in
            
                 if let checkout1 = checkout.checkout {
         print(checkout)
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    let isLogIn = UserDefaults.standard.bool(forKey: keyIsLogIN)
                    if isLogIn == true{
                        let tokenActiveDate = UserDefaults.standard.object(forKey: keyValidDateToken) as! Date
                        print("tokenActiveDate.......\(tokenActiveDate)")
                        if tokenActiveDate > Date(){
                           
                            let destinationViewController = WebViewViewController(nibName: "WebViewViewController", bundle: nil)
                            destinationViewController.cart = true
                            destinationViewController.checkoutView = checkout.checkout?.viewModel
                            let navigationController = UINavigationController(rootViewController:  destinationViewController)
                            UIApplication.shared.delegate?.window??.rootViewController  = navigationController
           
                                return

                        }else{
                            let destinationViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                            destinationViewController.destViewController = CustomTabBarViewController(nibName: "CustomTabBarViewController", bundle: nil)
                            UserDefaults.standard.set("", forKey: keyToken)
                            UserDefaults.standard.set("", forKey: keyValidDateToken)
                            UserDefaults.standard.set(false, forKey: keyIsLogIN)
                            ModalViewController.showAlert(alertTitle: "Session Expire", andMessage: "Your session is Expire,Please LogIn Again", withController: destinationViewController)
                            let navigationController = UINavigationController(rootViewController:  destinationViewController)
                            self.present(navigationController, animated: true)
                        }
                    }
                        
                    else{
                        let destinationViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                        destinationViewController.destViewController = CustomTabBarViewController(nibName: "CustomTabBarViewController", bundle: nil)
                        let navigationController = UINavigationController(rootViewController:  destinationViewController)
                        UIApplication.shared.delegate?.window??.rootViewController  = navigationController
                    }

                        
//           
                }else
                 {
                    print("errot.......\(checkout.userErrors)")
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Please try after some time.", withController: self)
                }
            }
            
     

        
       
        
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
