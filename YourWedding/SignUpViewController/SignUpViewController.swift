//
//  SignUpViewController.swift
//  Ribbons
//
//  Created by Alekh Verma on 19/07/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData

class SignUpViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var textFieldFirstName : UITextField?
    @IBOutlet var textFieldLastName : UITextField?
    @IBOutlet var textFieldEmail : UITextField?
    @IBOutlet var textFieldPassword : UITextField?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.methodToSetNavigationBarWithoutLogoImage(title: "Log In", badgeNumber: 4)

//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
//        //request.predicate = NSPredicate(format: "age = %@", "12")
//        request.returnsObjectsAsFaults = false
//        do {
//            let result = try context.fetch(request)
//           // self.methodToSetSideMenuButtonInNavigationBar(title: arrayMenuItems.object(at: 0) as! String)
//        }catch{
//            print("failed")
//        }
       // self.methodNavigationBarBackGroundColor()
        // Do any additional setup after loading the view.
    }
     // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if(textField == textFieldFirstName)
        {
            textFieldLastName?.becomeFirstResponder()
        }
        else if textField == textFieldLastName{
            textFieldEmail?.becomeFirstResponder()
        }else if textField == textFieldEmail{
            textFieldPassword?.becomeFirstResponder()
        }else
        {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
        if textField ==  textFieldFirstName || textField ==  textFieldLastName {
            if let range = string.rangeOfCharacter(from:set ){
            return true
        }
        else {
            return false
        }
        }
    return true
    }
     // MARK: - Buutton Actions
    @IBAction func signUpButtonClick(sender : UIButton){
        
        if textFieldFirstName?.text == ""{
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Please fill your name first.", withController: self)

        }else if textFieldEmail?.text == ""{
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Please fill your mail-ID first.", withController: self)

        }else if textFieldPassword?.text == ""{
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Please fill your password first.", withController: self)

        }else{
            if Utility.isValidEmail(testStr: (textFieldEmail?.text)!) == false{
                ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Please enter a valid email-ID.", withController: self)

            }else{
                Client.shared.createCustomer(with: (textFieldFirstName?.text)!, lastName: (textFieldLastName?.text)!, activeViewController: self, userMail: (textFieldEmail?.text)!, passWord: (textFieldPassword?.text)!){ checkout in
                    if checkout?.userErrors.count == 0{
                        Client.shared.createLogin(with: (checkout?.customer?.email)!, activeViewController: self, passWord: (self.textFieldPassword?.text)! ) { checkout in
                        if let checkout = checkout.customerAccessToken {
                            UserDefaults.standard.set(checkout.accessToken, forKey: keyToken)
                            UserDefaults.standard.set(checkout.expiresAt, forKey: keyValidDateToken)
                            UserDefaults.standard.set(true, forKey: keyIsLogIN)
                            Client.shared.getCustomerDetail(activeViewController: self){ customer in
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let base64Encoded :  String = (customer?.id)!.rawValue
                                let decodedData = Data(base64Encoded: base64Encoded)!
                                let decodedString = String(data: decodedData, encoding: .utf8)!
                                let customerID = decodedString.replacingOccurrences(of: "gid://shopify/Customer/", with: "", options: NSString.CompareOptions.literal, range: nil)
                                
                                UserDefaults.standard.set(customer?.firstName, forKey: keyCustomerFirstName)
                                UserDefaults.standard.set(customer?.lastName, forKey: keyCustomerLastName)
                                UserDefaults.standard.set(customerID, forKey: keyCustomerID)
                                
                                let ObjServer = Server()
                                ObjServer.delegate = self
                                ObjServer.hitGetRequest(url: fetchCustomerDetail + "\(customerID).json", inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:self, completion: {_,_,_ in })
                                self.navigationController?.popViewController(animated: true)
                                if let aPop = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count ?? 0) - 2 ] {
                                    self.navigationController?.popToViewController(aPop, animated: true)
                                }
                                
                                
                            }
                            

                            
                        } else {
                            print(checkout.userErrors)
                            if checkout.userErrors[0].message == "Unidentified customer"
                            {
ModalViewController.showAlert(alertTitle: "UNDEFINED CUSTOMER", andMessage: "User does not exist", withController: self)
                            }
                            
                        }
                    }
                    }else{
                        ModalViewController.showAlert(alertTitle: kAppName, andMessage: checkout?.userErrors[0].message, withController: self)

                    }
                }
            }
        }
    }
    @IBAction func signInButtonClick(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
        
    }

    // MARK: - recieve API data
    func didReceiveResponse(dataDic: NSDictionary?, response:URLResponse?) {
        customerArray = dataDic?.object(forKey: "shop") as? NSDictionary
        UserDefaults.standard.set(customerArray, forKey: "customer")
    }
    
    
    func didFailWithError(error: String) {
        
        let customerID = UserDefaults.standard.object(forKey: keyCustomerID) as? String
        if customerArray?.count == 0{
            let ObjServer = Server()
            ObjServer.delegate = self
            ObjServer.hitGetRequest(url:  fetchCustomerDetail + "\(customerID).json", inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:nil, completion: {_,_,_ in })
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
