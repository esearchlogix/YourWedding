//
//  SideMenuTable.swift
//  VistarApp
//
//  Created by thinksysuser on 06/12/16.
//  Copyright © 2016 thinksysuser. All rights reserved.
//

import UIKit
import CoreData

class SideMenuTable: UIView,UITableViewDataSource,UITableViewDelegate {
    var controller = UIViewController()
    var menuTable = UITableView()
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        menuTable.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        menuTable.frame = CGRect(x:-20,y:20,width:self.frame.size.width,height:screenheight)
        menuTable.separatorStyle = .none
        self.addSubview(menuTable)// here we are adding tableview on a subview
        menuTable.backgroundColor = UIColor.init(red: 0.0/255.0, green:67.0/255.0, blue: 82.0/255.0, alpha: 1.0)
        menuTable.delegate = self
        menuTable.dataSource = self
        self.addSubview(menuTable)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 20.0, y: 0.0, width: self.bounds.size.width, height: 110.0))
        headerView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 67.0/255.0, blue: 82.0/255.0, alpha: 1.0)
        //        let userImageView = UIImageView(frame: CGRect(x: 40.0, y: 15.0, width: 82, height: 82))
        //        userImageView.image = UIImage()
        //        userImageView.backgroundColor = .gray
        //        userImageView.layer.cornerRadius = userImageView.bounds.width/2
        let userNameLabel = UILabel(frame: CGRect(x: 40, y: 30, width: headerView.bounds.size.width - 120 , height: 30))
       // userNameLabel.text = Utility.getUserDisplayName()
        let isLogIn = UserDefaults.standard.bool(forKey: keyIsLogIN)
        if isLogIn == true{
        
            userNameLabel.text = (UserDefaults.standard.string(forKey: keyCustomerFirstName) ?? " ")
            
        }else{
            userNameLabel.text = kAppName
           
        }
       
        userNameLabel.textColor = .white
        userNameLabel.font = UIFont(name: appFontBold, size: 24)
        let userDesignationLabel = UILabel(frame: CGRect(x: 40, y: userNameLabel.bounds.maxY+5 + 15, width: headerView.bounds.size.width - 120 , height: 40))
        //userDesignationLabel.text = Utility.getUserTitle()
        
        userDesignationLabel.textColor = .white
        userDesignationLabel.font = UIFont(name: appFont, size: 18)
        //headerView.addSubview(userImageView)
        headerView.addSubview(userNameLabel)
        headerView.addSubview(userDesignationLabel)
        //8368552280
        return headerView
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sideMenuDataSection.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)
        tableCell.backgroundColor = UIColor.init(red: 0.0/255.0, green: 67.0/255.0, blue: 82.0/255.0, alpha: 1)
        tableCell.subviews.forEach({$0.removeFromSuperview()})
        let viewForImages = UIImageView.init(frame: CGRect(x:40, y:7,width:30,height:30))
        viewForImages.image = UIImage(named:sideMenuImages.object(at: indexPath.item) as! String)
        let labelForTableItems = UILabel.init(frame: CGRect(x:viewForImages.frame.maxX+10,y:7,width:tableCell.frame.size.width,height:30))
        labelForTableItems.textAlignment = .left
        labelForTableItems.textColor = UIColor.white
        labelForTableItems.font = UIFont.init(name: appFont, size: 17)
        labelForTableItems.text = sideMenuDataSection.object(at: indexPath.item) as? String
        tableCell.addSubview(viewForImages)
        tableCell.addSubview(labelForTableItems)
       // labelForTableItems.sizeToFit()
      //  if tableView.numberOfRows(inSection: 0) == 11
       // {
         if let value:String = sideMenuImages[indexPath.row] as? String
            {
                if value == "notificationSM"
                {
                self.addBadgeLabelWithCount(onButton: tableCell, text: Utility.getApplicationBadgeCount())
                }
                //            self.addBadgeLabelWithCount(onButton: labelForTableItems, text: 9900)
                
            }
            
      //  }
      //  else if
      
        
        
        
        return tableCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     
            var   selectedIndex = indexPath.row


            switch selectedIndex {

            case 0:
                let navigationController = UINavigationController(rootViewController:  CustomTabBarViewController())
                UIApplication.shared.delegate?.window??.rootViewController  = navigationController                //            controller.menuButtonAction(sender: nil)

            case 1:

                Utility.SocialPromotionAction(urlString: keyDiscountOfferUrl)

            case 2:
                let isLogIn = UserDefaults.standard.bool(forKey: keyIsLogIN)
                if isLogIn == true{
                    let tokenActiveDate = UserDefaults.standard.object(forKey: keyValidDateToken) as! Date
                    if tokenActiveDate > Date(){
                        let navigationController = UINavigationController(rootViewController:  OrderHistoryViewController())
                        UIApplication.shared.delegate?.window??.rootViewController  = navigationController
                        
                    }else{
                        let destinationViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                        destinationViewController.destViewController = OrderHistoryViewController(nibName: "OrderHistoryViewController", bundle: nil)

                        UserDefaults.standard.set("", forKey: keyToken)
                        UserDefaults.standard.set("", forKey: keyValidDateToken)
                        UserDefaults.standard.set(false, forKey: keyIsLogIN)
                        ModalViewController.showAlert(alertTitle: "Session Expire", andMessage: "Your session is Expire,Please LogIn Again", withController: destinationViewController)
                        
                        let navigationController = UINavigationController(rootViewController:  LoginViewController())
                        UIApplication.shared.delegate?.window??.rootViewController  = navigationController
                        
                    }
                    
                }else{
                     let destinationViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                  
                    destinationViewController.destViewController = OrderHistoryViewController(nibName: "OrderHistoryViewController", bundle: nil)
                      let navigationController = UINavigationController(rootViewController:  destinationViewController)
                    UIApplication.shared.delegate?.window??.rootViewController  = navigationController
                    
                }
               
            //
            case 3:
                Utility.SocialPromotionAction(urlString: keyContactUsURL)
                //
                //        case 4:
            //
            case 4:
                   Utility.SocialPromotionAction(urlString: keyTermsURL)
               

            case 5:
               Utility.SocialPromotionAction(urlString: keyPrivacyPolicyURL)

            case 6:
               Utility.SocialPromotionAction(urlString: keyRefundPolicyURL)
            case 7:
               Utility.SocialPromotionAction(urlString: keyCancelPolicyURL)
            case 8:
                let isLogIn = UserDefaults.standard.bool(forKey: keyIsLogIN)
                if isLogIn == true{
                    let tokenActiveDate = UserDefaults.standard.object(forKey: keyValidDateToken) as! Date
                    if tokenActiveDate > Date(){
                        Utility.clearAllData()
                        
                        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
                        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                        
                        do {
                            try context.execute(deleteRequest)
                            try context.save()
                            let navigationController = UINavigationController(rootViewController:  CustomTabBarViewController())
                            UIApplication.shared.delegate?.window??.rootViewController  = navigationController                           } catch {
                            print ("There was an error")
                        }
                        
                    }else{
                        let destinationViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                        UserDefaults.standard.set("", forKey: keyToken)
                        UserDefaults.standard.set("", forKey: keyValidDateToken)
                        UserDefaults.standard.set(false, forKey: keyIsLogIN)
                        ModalViewController.showAlert(alertTitle: "Session Expire", andMessage: "Your session is Expire,Please LogIn Again", withController: destinationViewController)
                        destinationViewController.destViewController = CustomTabBarViewController(nibName: "CustomTabBarViewController", bundle: nil)
                        let navigationController = UINavigationController(rootViewController:  destinationViewController)
                        UIApplication.shared.delegate?.window??.rootViewController  = navigationController
                        
                    }
                    
                }else{
                    let destinationViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                    destinationViewController.destViewController = CustomTabBarViewController(nibName: "CustomTabBarViewController", bundle: nil)

                    let navigationController = UINavigationController(rootViewController:  destinationViewController)
                    UIApplication.shared.delegate?.window??.rootViewController  = navigationController
                    
                }
                
            default:
                print("")
            }
        
    
    }
    
    func addBadgeLabelWithCount(onButton:UIView , text:Int){
        
        if let badgeLabel:UITextField = onButton.viewWithTag(1122) as? UITextField  {
            
          //  badgeLabel.text = "\(text.formattedWithSeparator)"
        }
        else{
            //adding badge label
             //   var yValue:CGFloat = (onButton.frame.origin.y)
                
                //                if onButton == buttonCompleted
                //                {
                //                    yValue -= 5
                //
                //                }
                let badgeLabel = UITextField.init(frame: CGRect(x: (onButton.frame.maxX)-87, y: 0, width: 20, height: 20))
            
                
                badgeLabel.backgroundColor = UIColor.init(red: 226/255.0, green: 67/255.0, blue: 57/255.0, alpha: 1)
                badgeLabel.textColor = .white
                badgeLabel.text = "\(text)"
                badgeLabel.textAlignment = .center
                badgeLabel.clipsToBounds = true;
                badgeLabel.tag = 1122;
            badgeLabel.font = UIFont.init(name: appFont, size: 14.0)
            
                //                let widthIs = self.badgeLabel.text.
                //                        boundingRectWithSize:self.badgeLabel.frame.size
                //                        options:NSStringDrawingUsesLineFragmentOrigin
                //                        attributes:@{ NSFontAttributeName:self.badgeLabel.font }
                //                context:nil]
                //                .size.width;
                
                // NSLog(@"the width of yourLabel is %f", widthIs);
                
            
            
            
            if text > 99 {
                badgeLabel.sizeToFit()
                badgeLabel.frame = CGRect(x: onButton.frame.maxX - badgeLabel.frame.size.width - 20, y: badgeLabel.frame.origin.y , width: badgeLabel.frame.size.width+10.0, height: 10+10.0)
                badgeLabel.layer.cornerRadius = badgeLabel.frame.size.height/2
                
            }
           
          else  if text == 0
            {
            
            badgeLabel.isHidden = true
            }
            
            else{
                badgeLabel.layer.cornerRadius = badgeLabel.frame.size.width/2
                badgeLabel.sizeToFit()
                badgeLabel.frame = CGRect(x: onButton.frame.maxX - badgeLabel.frame.size.width - 20, y: badgeLabel.frame.origin.y , width: badgeLabel.frame.size.width+10.0, height: badgeLabel.frame.size.width+10.0)
                badgeLabel.layer.cornerRadius = badgeLabel.frame.size.width/2
                
            }
            

            badgeLabel.center.y = onButton.frame.size.height/2
                onButton.addSubview(badgeLabel)
            onButton.bringSubviewToFront(badgeLabel)
            badgeLabel.contentVerticalAlignment = .center

           // badgeLabel.text = "\(text.formattedWithSeparator)"
            badgeLabel.contentVerticalAlignment = .center
badgeLabel.isUserInteractionEnabled = false
        }
    }
    
    func updateBadgeLabel(){
    let text = Utility.getApplicationBadgeCount()
    
        if let badgeLabel:UITextField = self.viewWithTag(1122) as? UITextField  {
           // badgeLabel.text = "\(text.formattedWithSeparator)"

          
            if text > 99 {
                
                badgeLabel.sizeToFit()
                
                
                
                badgeLabel.frame = CGRect(x: badgeLabel.superview!.frame.maxX - badgeLabel.frame.size.width - 20, y: badgeLabel.frame.origin.y , width: badgeLabel.frame.size.width+10.0, height: 10+10.0)
                badgeLabel.layer.cornerRadius = badgeLabel.frame.size.height/2
                badgeLabel.isHidden = false

            }
                
            else  if text == 0
            {
                
                badgeLabel.isHidden = true
            }
                
            else{
                badgeLabel.layer.cornerRadius = badgeLabel.frame.size.width/2
                badgeLabel.sizeToFit()
                badgeLabel.frame = CGRect(x: badgeLabel.superview!.frame.maxX - badgeLabel.frame.size.width - 20, y: badgeLabel.frame.origin.y , width: badgeLabel.frame.size.width+10.0, height: badgeLabel.frame.size.width+10.0)
                badgeLabel.layer.cornerRadius = badgeLabel.frame.size.width/2
                badgeLabel.isHidden = false

            }
            badgeLabel.center.y = badgeLabel.superview!.frame.size.height/2
            badgeLabel.contentVerticalAlignment = .center
    
           // badgeLabel.text = "\(text.formattedWithSeparator)"

            
            badgeLabel.contentVerticalAlignment = .center
badgeLabel.isUserInteractionEnabled = false
          //  badgeLabel.center.y = badgeLabel.superview!.center.y

        }
    }
    
}
