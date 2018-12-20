//
//  ModalViewController.swift
//  VistarApp
//
//  Created by thinksysuser on 21/11/16.
//  Copyright © 2016 thinksysuser. All rights reserved.
//

import UIKit

class ModalViewController: NSObject {
    
    //#MARK:- methodStatusBarColorChange
    class func methodStatusBarColorChange() {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        let statusBar:UIView = UIApplication.shared.value(forKey: "statusBar")as!UIView
        statusBar.backgroundColor = UIColor(red: 0.0/255.0, green:140.0/255.0, blue: 154.0/255.0, alpha: 1.0)
    }
    //#MARK:- methodStatusBarColorChangeGray
    
    class func methodStatusBarColorChangeGray() {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        let statusBar:UIView = UIApplication.shared.value(forKey: "statusBar")as!UIView
        statusBar.backgroundColor = UIColor(red: 217.0/255.0, green:217.0/255.0, blue: 217.0/255.0, alpha: 2.0)
    }
    //#MARK:- validateEmail
    class func validateEmail(strEmail: String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", kRegexEmailValidate)
        if emailTest.evaluate(with: strEmail) == false {
            return false
        }
        else {
            return true
        }
    }
    //#MARK:- showAlert
    
    class func showAlert(alertTitle: String, andMessage alertMessage: String?, withController view: UIViewController){
        let alertController = UIAlertController(title:alertTitle, message:alertMessage ?? "", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler:nil)
        alertController.addAction(OKAction)
        view.present(alertController, animated: true, completion: nil)
        
        
        // toast with all possible options
        //        view.view.makeToast(alertMessage, duration: 3.0, position: .top/*CGPoint(x: 110.0, y: 110.0)*/, title: "Applied", image: UIImage(named: "InfoIcon"), style:nil) { (didTap: Bool) -> Void in
        //            if didTap {
        //                print("completion from tap")
        //            } else {
        //                print("completion without tap")
        //            }
        //        }
        
    }
    // MARK:- methodForApplicationVersion
    class func methodForApplicationVersion() ->String{
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        _ = nsObject as! String
        
        let buildNumber: AnyObject? =  Bundle.main.infoDictionary?["CFBundleVersion"] as AnyObject?
        let number = buildNumber as! String
        
        let stringApplicationVersion = "v"+ModalViewController.getApplicationVersion()+"("+number+")"
        return stringApplicationVersion
    }
    
    class func getApplicationVersion() ->String{
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        let version = nsObject as! String
        
      
        return version
    }
    
    
    class func showAlert(alertTitle: String, andMessage alertMessage: String?, withController view: UIViewController ,action: UIAlertAction){
        let alertController = UIAlertController(title:alertTitle, message:alertMessage ?? "", preferredStyle: .alert)
        //  let OKAction = UIAlertAction(title: "Ok", style: .default, handler:{ action in
        
     
        //   })
        if  view.navigationController != nil || view.presentingViewController != nil{
        alertController.addAction(action)
        view.present(alertController, animated: true, completion: nil)
        }
    }

    
}
