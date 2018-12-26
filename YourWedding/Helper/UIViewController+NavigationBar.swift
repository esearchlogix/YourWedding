//
//  UIViewController+NavigationBar.swift
//  Ribbons
//
//  Created by Alekh Verma on 15/06/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import MBProgressHUD
import Crashlytics

extension UIViewController:ServerCallback,UINavigationControllerDelegate{
    

    //#MARK: methodTodismissKeyboardOnBackgroundClick
    func methodTodismissKeyboardOnBackgroundClick(){
        let tapGes :UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(touch:)))
        tapGes.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGes)
    }
    //#MARK: HIDE KEYBOARD METHOD
    @objc func hideKeyboard(touch:UITouch){
        self.view.endEditing(true)
    }
    // #MARK: methodToPlaceBackButtonWithPopNavigation
    func methodToPlaceBackButtonWithPopNavigation(){
        let backButton = UIButton()
        
       // backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backButton.frame = CGRect(x:0,y:0,width:40,height:30)
        backButton.addTarget(self, action: #selector(backButtonActionPop(sender:)), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    
    
    
    // #MARK: backButtonActionPop
    
    @objc func backButtonActionPop(sender:UIButton){
        
        // var count = 0
       navigationController?.popViewController(animated: true)
        
    }
    // #MARK: methodToSetButtonInNavigationBar
    func methodToSetButtonInNavigationBar(){
        
        let buttonCart = UIButton()
        buttonCart.setImage(#imageLiteral(resourceName: "logout"), for: .normal)
        buttonCart.frame = CGRect(x:0,y:0,width:30,height:30)
        buttonCart.addTarget(self, action: #selector(self.methodCartButton), for: .touchUpInside)
        let rightBarButton1 = UIBarButtonItem()
        rightBarButton1.customView = buttonCart
        
        
        
        let accountButton = UIButton()
        accountButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        accountButton.frame = CGRect(x:0,y:0,width:30,height:30)
        accountButton.addTarget(self, action: #selector(self.methodAccountButton), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = accountButton
      
        let navigateSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        navigateSpacer.width = 0
        
      
        
        self.navigationItem.setLeftBarButtonItems([rightBarButton1,navigateSpacer,rightBarButton], animated: false)
        _ = self.navigationController?.navigationBar
       
    }
    //#MARK:- methodHomeButtonPress
    
    @objc func methodAccountButton(){
        
//        let isLogIn = UserDefaults.standard.bool(forKey: keyIsLogIN)
//        if isLogIn == true{
//            let tokenActiveDate = UserDefaults.standard.object(forKey: keyValidDateToken) as! Date
//            if tokenActiveDate > Date(){
//                let destinationViewController = AddressViewController(nibName: "AddressViewController", bundle: nil)
//              if self is AddressViewController{
//
//                }else{
//                Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
//                }
//            }else{
//                UserDefaults.standard.set("", forKey: keyToken)
//                UserDefaults.standard.set("", forKey: keyValidDateToken)
//                UserDefaults.standard.set(false, forKey: keyIsLogIN)
//                ModalViewController.showAlert(alertTitle: "Session Expire", andMessage: "Your session is Expire,Please LogIn Again", withController: self)
//                let destinationViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
//                Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
//            }
//
//        }else{
//            let destinationViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
//            Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
//        }

    
    }
    
    //#MARK:- action for cell click of side menu table
//    func sideMenuBarAction(indexpath : IndexPath){
//        
//        
//        switch indexpath.row {
//            
//        case 0:
//            self.navigationController?.popToRootViewController(animated: true)
//            
//        case 1:
//            let destinationViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
//            destinationViewController.productsArray = []
//            destinationViewController.collectionID = 235961729
//            destinationViewController.isRequest = true
//            Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
//            
//        case 2:
//            let destinationViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
//            destinationViewController.productsArray = []
//            destinationViewController.collectionID = 235961921
//            destinationViewController.isRequest = true
//            Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)           //
//        case 3:
//            let destinationViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
//            destinationViewController.productsArray = []
//            destinationViewController.collectionID = 239200449
//            destinationViewController.isRequest = true
//            Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
//            
//        case 4:
//            let destinationViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
//            destinationViewController.productsArray = []
//            destinationViewController.collectionID = 239199937
//            destinationViewController.isRequest = true
//            Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
//            
//        case 5:
//            let destinationViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
//            destinationViewController.productsArray = []
//            destinationViewController.collectionID = 240510913
//            destinationViewController.isRequest = true
//            Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
//            
//        case 6:
//            let destinationViewController = OfferViewController(nibName: "OfferViewController", bundle: nil)
//            Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
//            
//        case 7:
//            let destinationViewController = OfferViewController(nibName: "OrderHistoryViewController", bundle: nil)
//            Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
//        case 8:
//            let destinationViewController = OfferViewController(nibName: "CartViewController", bundle: nil)
//            Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
//        case 9:
//            let destinationViewController = OfferViewController(nibName: "NotificationViewController", bundle: nil)
//            Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
//        case 10:
//            let destinationViewController = OfferViewController(nibName: "AccountViewController", bundle: nil)
//            Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
//            
//        default:
//            print("")
//        }
//        
//    }
    
    
    //#MARK:- methodForBackButtonPress
    
    @objc func methodbackButton(){
      self.navigationController?.popViewController(animated: true)
        
    }
    //#MARK:- methodCartButton
    
    @objc func methodCartButton(){
        let destinationViewController = CustomTabBarViewController(nibName: "CustomTabBarViewController", bundle: nil)
  
        destinationViewController.selectedIndex = 2
        let navigationController = UINavigationController(rootViewController:  destinationViewController)
        UIApplication.shared.delegate?.window??.rootViewController  = navigationController

    }
    //#MARK:- logoutSuccessful
    
    func logoutSuccessful() {
        DispatchQueue.main.async {
            
            Utility.clearAllData()
            MBProgressHUD.hide(for: self.view, animated: true)
            
            // UserDefaults.standard.removeObject(forKey:keySessionID)
        }
    }
    //    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    //        if (operation == .push)
    //        {  return ;}
    //
    //        if (operation == .pop)
    //        {return;}
    //    }
    //#MARK:- methodNavigationBarBackGroundColor
    
    func methodNavigationBarBackGroundColor()  {
        
        self.navigationController?.delegate = self;
        
     //   self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: font]
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        
        
    }
    
    //#MARK:- methodNavigationBarBackGroundColorWithoutBottomLine
    
    func methodNavigationBarBackGroundColorWithoutBottomLine()  {
        
        self.navigationController?.delegate = self;
        
      //  self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.isTranslucent = false
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.barTintColor = UIColor(red: 247.0/255.0, green:166.0/255.0, blue: 28.0/255.0, alpha: 1.0)
    }
}
