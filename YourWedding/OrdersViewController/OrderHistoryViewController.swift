//
//  OrderHistoryViewController.swift
//  Ribbons
//
//  Created by Alekh Verma on 03/07/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData
import MessageUI

class OrderHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableViewOrder: UITableView?
    @IBOutlet weak var emptylabel: UILabel?
    
    
    var orderArray : NSMutableArray? = []
    var indexpath : Int? = nil
    override func viewDidLoad() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")

        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            self.methodToSetNavigationBarWithoutLogoImage(title: "Log In", badgeNumber: 4)

        }catch{
            print("failed")
        }
       // self.methodNavigationBarBackGroundColor()
      
        tableViewOrder?.register(UINib(nibName: "OfferListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        let customerID = UserDefaults.standard.value(forKey: keyCustomerID)
        let ObjServer = Server()
        ObjServer.delegate = self
        ObjServer.hitGetRequest(url: fetchCustomerDetail + "\(customerID ?? 0000)/orders.json", inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:self, completion: {_,_,_ in })
        super.viewDidLoad()

        // Do any additional setup after loading the view.`
    }
    
    // MARK: - recieve API data
    func didReceiveResponse(dataDic: NSDictionary?, response:URLResponse?) {
        if let val = dataDic!["orders"] {
         
       
        let arrayOrder = dataDic?.object(forKey: "orders") as? NSArray
        if arrayOrder?.count == 0{
         emptylabel?.isHidden = false
          tableViewOrder?.isHidden = true

        }else{
            orderArray = arrayOrder?.mutableCopy() as? NSMutableArray
        DispatchQueue.main.async {
            self.emptylabel?.isHidden = true
            self.tableViewOrder?.isHidden = false
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            self.tableViewOrder?.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        }
        }else{
        if let val = dataDic!["order"] {
            let cancelArray = dataDic?.object(forKey: "order") as? NSArray
            if cancelArray?.count == 0{
               ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Please try again", withController: self)
            }else{
                 ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Order canceled successfully", withController: self)
                orderArray?.removeObject(at: indexpath ?? 0)
                self.emptylabel?.isHidden = true
                self.tableViewOrder?.isHidden = false
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                self.tableViewOrder?.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }else{
            let refundArray = dataDic?.object(forKey: "refund") as? NSArray
            if refundArray?.count == 0{
                ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Please try again", withController: self)
            }else{
                ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Amount will credited in your account within 4-7 days.", withController: self)
            }
            }
        }}
    func didFailWithError(error: String) {
        if orderArray?.count == 0{
             DispatchQueue.main.async {
        self.emptylabel?.isHidden = false
        self.tableViewOrder?.isHidden = true
            }
        }else{
             DispatchQueue.main.async {
            self.emptylabel?.isHidden = true
            self.tableViewOrder?.isHidden = false
            }
        }
        let alertController = UIAlertController(title:kAppName, message:error , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler:{ action in
        self.navigationController?.popViewController(animated: true)
        })
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }

  // MARK: - tableView delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (orderArray?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (((orderArray?.object(at: section) as? NSDictionary)?.object(forKey: "line_items") as? NSArray)?.count) ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
  
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 65))
        
        var labelOrderID = UILabel(frame: CGRect(x: 10, y: 5, width: view.frame.size.width - 150, height: 25))
        labelOrderID.text = " Order No \((orderArray?.object(at: section) as? NSDictionary)?.object(forKey: "id") as? Int ?? 0000000)"
        labelOrderID.font = UIFont.boldSystemFont(ofSize: 16.0)
        labelOrderID.textColor = UIColor.black
        
        view.addSubview(labelOrderID)
        
        let buttonDetail = UIButton(frame : CGRect(x: view.frame.size.width - 100, y: 5, width: 80, height: 25))
        buttonDetail.setTitle("Order Detail", for: .normal)
        buttonDetail.setTitleColor(UIColor.white, for: .normal)
        buttonDetail.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        buttonDetail.layer.cornerRadius = 12.5
        buttonDetail.clipsToBounds = true
        buttonDetail.backgroundColor = UIColor.init(red: 247.0/255.0, green:102.0/255.0, blue: 138.0/255.0, alpha: 1.0)
        buttonDetail.tag = section
        buttonDetail.addTarget(self, action: #selector(self.buttonOrderDetail), for: .touchUpInside)
        view.addSubview(buttonDetail)
        
        var labelOrderDate = UILabel(frame: CGRect(x: 10, y: 35, width: view.frame.size.width, height: 25))
        let myDateString = ((orderArray?.object(at: section) as? NSDictionary)?.object(forKey: "created_at") as? String ?? "0000-00-00T00:00:00-00:00")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let myDate = dateFormatter.date(from: myDateString)!
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
         let orderDate = dateFormatter.string(from: myDate)
        
        labelOrderDate.text = " \(orderDate)"
        labelOrderDate.font = UIFont.boldSystemFont(ofSize: 16.0)
        labelOrderDate.textColor = UIColor.darkGray
        
        view.addSubview(labelOrderDate)
        
        //        var header : ExpendableTableView0
        
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 3))
        view.backgroundColor = UIColor.white
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOrder?.dequeueReusableCell(withIdentifier: "cell") as? OfferListTableViewCell
        var products = (orderArray?.object(at: indexPath.section) as? NSDictionary)?.object(forKey: "line_items") as? NSArray
        cell?.labelName?.text = (products?.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "title") as? String
        let quantitity = (products?.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "quantity") as? Int
        cell?.labelQuantity?.text = "\(quantitity ?? 0)"
        cell?.labelPrice?.text = (products?.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "price") as? String
        
        let productIDImage  =  (products?.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "product_id") as? Int
        if productIDImage == nil{
            cell?.imageProduct?.image = UIImage(named: "defaultOrderImage")
        }else{
        fetchImagesProduct(productId: productIDImage!, cell: cell!)
        }
       let imageStr = (products?.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "") as? String
        Utility.giveShadowEffectToView(view: (cell?.imageSuperView)!)
        
     // Code for track order button
        cell?.buttonTrackOrder?.tag = indexPath.section
        cell?.buttonTrackOrder?.addTarget(self, action: #selector(self.buttonTrackOrderClicked), for: .touchUpInside)
        

    // Code for return Button/cancel button
        
        cell?.buttonRefund?.tag = indexPath.section
        cell?.buttonRefund?.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        if ((orderArray?.object(at: indexPath.section) as? NSDictionary)?.object(forKey: "fulfillments") as? NSArray)?.count == 0{
            cell?.buttonRefund?.isHidden = false
        
            cell?.buttonTrackOrder?.isHidden = true
            cell?.buttonRefund?.setTitle("Cancel", for: .normal)
            
        }
        else{
            let status = (((orderArray?.object(at: indexPath.section) as? NSDictionary)?.object(forKey: "fulfillments") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "shipment_status") as? String
            cell?.buttonTrackOrder?.isHidden = false
            let trackingURLString = (((orderArray?.object(at: indexPath.section) as? NSDictionary)?.object(forKey: "fulfillments") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "tracking_url") as? String
            if trackingURLString == nil{
                cell?.buttonTrackOrder?.isHidden = true
            }else{
                cell?.buttonTrackOrder?.isHidden = false
                
            }
            
            if status == "delivered"{
                let dateDelivered =  (((orderArray?.object(at: indexPath.section) as? NSDictionary)?.object(forKey: "fulfillments") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "updated_at") as? String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let myDate = dateFormatter.date(from: dateDelivered!)!
                let refundLastDate = Calendar.current.date(byAdding: .day, value: 15, to: myDate)
                
                if  refundLastDate! > Date(){
                    cell?.buttonRefund? .setTitle("Return", for: .normal)
                    cell?.buttonRefund?.isHidden = true
                }else{
                    cell?.buttonRefund?.isHidden = true
                }
                
            }else{
                cell?.buttonRefund?.isHidden = false
                
                cell?.buttonRefund?.setTitle("Cancel", for: .normal)
            }
        }
         Utility.giveBorderToView(view: (cell?.imageSuperView)!, colour: UIColor.init(red: 247.0/255.0, green:102.0/255.0, blue: 138.0/255.0, alpha: 1.0))
          Utility.giveShadowEffectToView(view: (cell?.cellView)!)
        cell?.selectionStyle = .none
        return cell!
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let destinationViewController = OrderViewController(nibName: "OrderViewController", bundle: nil)
//       destinationViewController.orderDict = orderArray?.object(at: indexPath.section) as? NSDictionary
//        self.navigationController?.pushViewController(destinationViewController, animated: true)
//
//
//    }
    
      // MARK: - button Action
     @objc func buttonTrackOrderClicked(sender: UIButton) {
    let trackingURLString = (((orderArray?.object(at: sender.tag) as? NSDictionary)?.object(forKey: "fulfillments") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "tracking_url") as? String
        Utility.SocialPromotionAction(urlString: trackingURLString ?? "")
    
    
    }
    @objc func buttonOrderDetail(sender: UIButton) {
        let destinationViewController = OrderViewController(nibName: "OrderViewController", bundle: nil)
        destinationViewController.orderDict = orderArray?.object(at: sender.tag) as? NSDictionary
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    @objc func buttonClicked(sender: UIButton!) {
        let alertController = UIAlertController(title:kAppName, message:"If you want to cancel/return your product, then you can contact us on cs@yourweddinglinen.com . Support team  contact to you after recieving your E-mail. " , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Cancel", style: .default, handler:{ action in
          
        })
        let laterAction = UIAlertAction(title: "Later", style: .default, handler:{ action in
            
        })
        let contactNowAction = UIAlertAction(title: "Contact Now", style: .default, handler:{ action in
        if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([kSupportEmail])
              
                
                self.present(mail, animated: true)
            } else {
           ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Your device could not send e-mail.  Please check e-mail configuration and try again.", withController: self)
            }
        })
        
        
        alertController.addAction(OKAction)
         alertController.addAction(laterAction)
         alertController.addAction(contactNowAction)
        self.present(alertController, animated: true, completion: nil)
        

    }
      // MARK: - Mail delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - fetch Images
    func fetchImagesProduct(productId : Int , cell : OfferListTableViewCell){
  
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://a74ea1421fb13439b649fe9d44e0f3f6:3b423920ac3190c872a7c1569763da3f@petstylo.myshopify.com/admin/products/\(productId)/images.json")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
     
        
        let session = URLSession.shared
          if Utility.isInternetAvailable(){
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {

                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 200{
                   print(httpResponse)
                    do {
                        if   let parsedData:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                            if let error = parsedData.value(forKey: "error") as? String
                            {
                                print(error)
                            }
                            else{
                                let dataDic  = parsedData as NSDictionary?
                                let imageStr = (( parsedData.object(forKey: "images") as? NSArray)?.object(at: 0) as? NSDictionary?)??.object(forKey: "src") as? String
                                cell.imageProduct?.sd_setImage(with: URL(string: imageStr as! String ))
                            }
                        
                    }
                    }catch {
                        print("Something went wrong")
                    }
                    
                    
                }
                
            }
        })
        
        dataTask.resume()
          }else{
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController: self)
        }
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
