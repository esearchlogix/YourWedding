//
//  LoginViewController.swift
//  Ribbons
//
//  Created by Alekh Verma on 19/06/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin
import GoogleSignIn
import MBProgressHUD
import CoreData

var customerArray : NSDictionary? = [:]
class LoginViewController: UIViewController,UITextFieldDelegate,GIDSignInDelegate,GIDSignInUIDelegate {

    @IBOutlet var textFieldUserName :  UITextField?
    @IBOutlet var textFieldPassword :  UITextField?
    @IBOutlet var buttonLogIn :  UIButton?
    @IBOutlet var buttonSignUp :  UIButton?
    
    var destViewController : UIViewController?

    let loginManager: FBSDKLoginManager = FBSDKLoginManager()
    var dict : NSDictionary? = [:]
    var islogInFacebook : Bool? = false
    var islogInGmail : Bool? = false
    var firstName : String? = ""
    var lastName : String? = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        self.methodToSetNavigationBarWithoutLogoImage(title: "Log In", badgeNumber: 4)
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
//
//        request.returnsObjectsAsFaults = false
//        do {
//            let result = try context.fetch(request)
//            self.methodToSetSideMenuButtonInNavigationBarWithPopBack(badgeNumber: result.count)
//
//        }catch{
//            print("failed")
//        }
        //self.methodNavigationBarBackGroundColor()
       textFieldUserName?.becomeFirstResponder()

        Utility.giveShadowEffectToView(view: buttonLogIn!)
       
 
       

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if(textField == textFieldUserName)
        {
            textFieldPassword?.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    // MARK: - forget password Button Press
    @IBAction func forgetPasswordButtonPress(sender:UIButton){
        if textFieldUserName?.text == ""{
         ModalViewController.showAlert(alertTitle: "Wrong Email", andMessage: "Please fill the valid Email-ID.", withController: self)
        }else{
            Client.shared.forgetPassWord(with: (textFieldUserName?.text) ?? "", activeViewController: self) { checkout in
                if checkout.userErrors.count == 0{
                  ModalViewController.showAlert(alertTitle: kAppName, andMessage: "A link has sent to your mail id for generate new password.", withController: self)
                }else{
                ModalViewController.showAlert(alertTitle: "UNDEFINED CUSTOMER", andMessage: checkout.userErrors[0].message, withController: self)

                }
            }
        }
    }
    
      // MARK: - Google Button Press
    @IBAction func googleButtonPress(sender:UIButton){
     
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
   //MARK:Google SignIn Delegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //completed sign In
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                       withError error: Error!) {
        if (error == nil) {
            islogInGmail = true
            firstName = user.profile.givenName
            lastName = user.profile.familyName
          self.methodForLogIn(userName: user.profile.email , password: user.userID)
            

        } else {
            print("\(error.localizedDescription)")
        }
    }
    
// MARK: - Facebook Button Press
    @IBAction func facebookButtonPress(sender:UIButton){
        //Check FB session validation
        if FBSDKAccessToken.current() == nil {
            //Session is not active
            //Go for Facebook login
            //Take default permissions("public_profile","email","user_friends")
            loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
                if error != nil {
                    //error
                } else if (result?.isCancelled)!{
                    return
                }
                else
                {
                    
                    self.getFBUserData()
                }
            }
        } else {
            //Facebook session is active
        }
    }
    //function is fetching the user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as? NSDictionary
                    self.islogInFacebook = true
                    let fullName = self.dict?.object(forKey: "name") as! String
                    var components = fullName.components(separatedBy: " ")
                    if(components.count > 0)
                    {
                        self.firstName = components.removeFirst()
                        self.lastName = components.joined(separator: " ")
                    }
                    self.islogInFacebook = true
            self.methodForLogIn(userName: self.dict?.object(forKey: "email") as! String , password: self.dict?.object(forKey: "id") as! String)
                    
                }
            })
        }
    }

// MARK: - LogIn button Press
    @IBAction func logInButtonPress(sender:UIButton){
        if textFieldUserName?.text == "" || textFieldPassword?.text == ""{
            if textFieldUserName?.text == ""{
                ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Please fill the valid Email-ID.", withController: self)
            }else{
                ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Please fill password first.", withController: self)
            }
        }else{
            let isEmail = Utility.isValidEmail(testStr: (textFieldUserName?.text) ?? "")
        if isEmail == false{
        ModalViewController.showAlert(alertTitle: "Wrong Email", andMessage: "Please fill the valid Email-ID.", withController: self)
        }else{
        methodForLogIn(userName: (textFieldUserName?.text) ?? "", password: (textFieldPassword?.text) ?? "")

            
            }
            
        }
    }
    // MARK: - recieve API data
    func didReceiveResponse(dataDic: NSDictionary?, response:URLResponse?) {
        customerArray = dataDic?.object(forKey: "customer") as? NSDictionary
        let preferences = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: customerArray ?? [:])
        preferences.set(encodedData, forKey: "customer")
        // Checking the preference is saved or not
        
        
    }
    
    
    func didFailWithError(error: String) {
        
        let customerID = UserDefaults.standard.object(forKey: keyCustomerID) as? String
            if customerArray?.count == 0{
                let ObjServer = Server()
                ObjServer.delegate = self
                ObjServer.hitGetRequest(url:  fetchCustomerDetail + "\(customerID).json", inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:nil, completion: {_,_,_ in })
            }
 
        
    }

    
// MARK: - Method For Sign In
    func methodForLogIn(userName: String,password:String)  {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Client.shared.createLogin(with: (textFieldUserName?.text) ?? "", activeViewController: self, passWord: (textFieldPassword?.text) ?? "") { checkout in
            if let checkout = checkout.customerAccessToken {
                UserDefaults.standard.set(checkout.accessToken, forKey: keyToken)
                UserDefaults.standard.set(checkout.expiresAt, forKey: keyValidDateToken)
                UserDefaults.standard.set(true, forKey: keyIsLogIN)
                Client.shared.getCustomerDetail(activeViewController: self){ customer in
                MBProgressHUD.hide(for: self.view, animated: true)
                let base64Encoded :  String = ((customer?.id)?.rawValue) ?? ""
                let decodedData = Data(base64Encoded: base64Encoded)!
                let decodedString = String(data: decodedData, encoding: .utf8)!
                let customerID = decodedString.replacingOccurrences(of: "gid://shopify/Customer/", with: "", options: NSString.CompareOptions.literal, range: nil)
               
                UserDefaults.standard.set(customer?.firstName, forKey: keyCustomerFirstName)
                UserDefaults.standard.set(customer?.lastName, forKey: keyCustomerLastName)
                UserDefaults.standard.set(customerID, forKey: keyCustomerID)
                
                let ObjServer = Server()
                ObjServer.delegate = self
                ObjServer.hitGetRequest(url: fetchCustomerDetail + "\(customerID).json", inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:self, completion: {_,_,_ in })
                    
                    let navigationController = UINavigationController(rootViewController:  self.destViewController ?? CustomTabBarViewController())
                    UIApplication.shared.delegate?.window??.rootViewController  = navigationController
               
                }
                
               
            } else {
                print(checkout.userErrors)
                MBProgressHUD.hide(for: self.view, animated: true)
                if checkout.userErrors[0].message == "Unidentified customer" || checkout.userErrors[0].message == "Customer is not enabled"
                {
                    if self.islogInFacebook == true  {
                      self.methodForSignUp(userName: userName, password: password, firstName: self.firstName!, lastName: self.lastName!)
                    }else if self.islogInGmail == true{
                        self.methodForSignUp(userName: userName, password: password, firstName: self.firstName!, lastName: self.lastName!)
                    }else{
                        ModalViewController.showAlert(alertTitle: "UNDEFINED CUSTOMER", andMessage: "User does not exist.Please check your Email or password.", withController: self)
                }
                }
            }
        }

    }
    func methodForSignUp(userName: String,password:String,firstName : String,lastName: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Client.shared.createCustomer(with: firstName, lastName: lastName, activeViewController: self, userMail: userName, passWord: password){ checkout in
            Client.shared.createLogin(with: (checkout?.customer?.email)!, activeViewController: self, passWord: password ) { checkout in
                MBProgressHUD.hide(for: self.view, animated: true)
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
                        
                        
                    }
                    
                } else {
                    print(checkout.userErrors)
                    if checkout.userErrors[0].message == "Unidentified customer" || checkout.userErrors[0].message == "Customer is not enabled"
                    {
                ModalViewController.showAlert(alertTitle: "UNDEFINED CUSTOMER", andMessage: "User does not exist", withController: self)
                    }
                    
                }
            }
            
        }
        
    }
    
 // MARK: - LogIn button Press
    @IBAction func SignUPButtonPress(sender:UIButton){
        let destinationViewController = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
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
