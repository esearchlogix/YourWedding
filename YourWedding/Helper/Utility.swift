//
//  Utility.swift
//  VistarApp
//
//  Created by thinksysuser on 30/01/17.
//  Copyright © 2017 thinksysuser. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import CoreData
import SystemConfiguration

class Utility: NSObject {
    
    //#MARK:- Social promotion in Application
    class func SocialPromotionAction(urlString:String)
    {
        if let webURl = URL(string: urlString){

        if UIApplication.shared.canOpenURL(webURl) {
            UIApplication.shared.openURL(webURl)
        }
        else
        {
       print("weburl not open")
        
    }
    }
    }
    
    //MARK:- Move to view controller
    class func pushToViewController(callingViewController:UIViewController, moveToViewController: UIViewController){
        
        callingViewController.navigationController?.pushViewController(moveToViewController, animated: true)
        
    }
 
    //MARK:- give layer to view
    class func giveBorderToView(view:UIView, colour: UIColor){
        
   view.layer.borderWidth = 1.0
   view.layer.borderColor = colour.cgColor
    }
    class func giveDoubleBorderToView(view:UIView, colour: UIColor){
        
        view.layer.borderWidth = 3.0
        view.layer.borderColor = colour.cgColor
    }
    
    //#MARK:- changeDateFormat
    class func changeDateFormat(dateString:String) -> String
    {
        let origdate = Utility.dateExtractor2(dateString: dateString)
        
        let day = origdate.day
        let month = origdate.month
        let year = origdate.year
        var changedDate:String = ""
        changedDate = "\(month)/\(day)/\(year)"
        
        if month < 10 {
            changedDate  = "0\(month)/\(day)/\(year)"
        }
        if day < 10
        {
            changedDate  = "\(month)/0\(day)/\(year)"
        }
        
        return changedDate
        
    }
    //#MARK:- textfieldLeftViewMethod
    class func textfieldLeftViewMethod(textFieldName:UITextField,text:String){
        
        // set label in leftview of textfield
        let containerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 125, height: textFieldName.bounds.size.height))
        
        let tfPartLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 115, height: textFieldName.bounds.size.height))
        
        tfPartLabel.text = text
        tfPartLabel.font = UIFont.init(name: appFont, size: 14)
        tfPartLabel.textColor = UIColor.init(red: 49/255.0, green: 49/255.0, blue: 49/255.0, alpha: 1)
        tfPartLabel.textAlignment = .center
        tfPartLabel.numberOfLines = 0
        tfPartLabel.backgroundColor = UIColor.init(red: 178.0/255.0, green: 174.0/255.0, blue: 220/255.0, alpha: 1)
        let maskLayer = CAShapeLayer()
        
        let path = UIBezierPath(roundedRect:tfPartLabel.bounds,
                                byRoundingCorners:[.topLeft, .bottomLeft],
                                cornerRadii: CGSize(width: 6, height:  6))
        
        maskLayer.path = path.cgPath
        tfPartLabel.layer.mask = maskLayer
        
        containerView.addSubview(tfPartLabel)
        textFieldName.leftView = containerView
        textFieldName.leftViewMode = .always
        
    }
    //#MARK: - getTabBarInstance
    class func getTabBarInstance() -> CustomTabBarViewController?{
        
        let tabController:CustomTabBarViewController? = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarViewController
        return tabController
    }
    
    //#MARK: - ACTIVITY INDICATOR
    class func showActivityIndicator(controller:UIViewController){
        
        let activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.center = controller.view.center
        activityView.startAnimating()
        controller.view.addSubview(activityView)
    }
    //#MARK: - DATA MANAGEMENT
    class  func clearAllData(){
        let defaults = UserDefaults.standard
    //    let keyChain = KeychainWrapper.standard
    //    keyChain.removeObject(forKey: keySessionID)
       
        
        defaults.removeObject(forKey:keyToken )

        
 //       defaults.removeObject(forKey:keyInitialRep )
        defaults.removeObject(forKey:keyValidDateToken )
        defaults.removeObject(forKey: keyIsLogIN)
        defaults.removeObject(forKey: keyCustomerFirstName)
        defaults.removeObject(forKey: keyCustomerLastName)
        defaults.removeObject(forKey: keyCustomerID)
        
       // defaults.removeObject(forKey: isNotificationReceived)

        
        DispatchQueue.main.async {
           // UIApplication.shared.delegate?.window??.rootViewController = LoginViewControllerNewViewController()
        }
    }
    //#MARK:- check Internet dictionary
   class func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    //#MARK:- get dictionary
   class func getDictionary(key: String) -> NSDictionary {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: key) != nil{
            let decoded = preferences.object(forKey: key)  as! Data
            let decodedDict = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? NSDictionary
            
            
            return decodedDict!
        } else {
            let emptyDict = NSDictionary()
            return emptyDict as NSDictionary
        }
    }
    //#MARK:- clearUserDefaults
    class func clearUserDefaults(){
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey:keyRepCount )

      //  defaults.removeObject(forKey:keyInitialRep )
        defaults.removeObject(forKey:keyCurrentRep )
        
        defaults.removeObject(forKey: keyCustomerDetailDic)
        defaults.removeObject(forKey: keyUserName)
        
        defaults.removeObject(forKey: keyCustomerAccount)
        defaults.removeObject(forKey: keyCustomerCity)
        defaults.removeObject(forKey: keyCustomerName)
        defaults.removeObject(forKey: keyCustomerPlant)
        defaults.removeObject(forKey: keyCustomerState)
        defaults.removeObject(forKey: keyCustomerID)
        defaults.removeObject(forKey: keyAMname)
       // defaults.removeObject(forKey: isNotificationReceived)

        defaults.synchronize()
    }
    //#MARK:- getArrayNames
    
    class func getArrayNames() -> NSArray{
        var array:NSArray = NSArray()
        if let filepath = Bundle.main.path(forResource: "CSV_Database_of_First_Names", ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filepath)
                //  print(contents)
                array = contents.components(separatedBy: "\r") as NSArray
                
                //  print(array)
                
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        return array
    }
    //#MARK:- isInitialRepZero
    //checks if rep count is zero at login
    class func isInitialRepZero() -> Bool
    {
//        var isZero = false
//        if let initialRep = Utility.getInitialRep()
//        {  if initialRep == 0 {
//            isZero = true
//            }
//        }
        var isZero = false
         let initialRep = Utility.getRepCount()
         if initialRep == 0 {
            isZero = true
            }
        
        
       //  isZero = true

        
        
        return isZero
    }
    //#MARK:- getInitialRep
    
//    class func getInitialRep() -> Int?{
//        let initialRep:Int? = UserDefaults.standard.value(forKey: keyInitialRep) as? Int
//        return initialRep
//    }
    class func getCurrentRep() -> Int?{
        let repCount:Int? = UserDefaults.standard.value(forKey: keyCurrentRep) as? Int
        return repCount
    }
//    class  func setInitialRep(repCount:Int)  {
//        //  UserDefaults.standard.set(0, forKey: keyInitialRep)
//        
//        UserDefaults.standard.set(repCount, forKey: keyInitialRep)
//    }
    
    
    
    
    
    
    
    
    class  func setCurrentRep(currentRep:Int)  {
        //UserDefaults.standard.set(0, forKey: keyInitialRep)
        
        UserDefaults.standard.set(currentRep, forKey: keyCurrentRep)
    }
    
    
    
    class func getRepCount() -> Int{
        let repCount:Int? = UserDefaults.standard.value(forKey: keyRepCount) as? Int
        return repCount ?? 0
    }
    class  func setRepCount(repCount:Int)  {
        //  UserDefaults.standard.set(0, forKey: keyInitialRep)
        
        UserDefaults.standard.set(repCount, forKey: keyRepCount)
    }
    
    class  func setEnvironmentType(envType:EnvironmentType)  {
        //  UserDefaults.standard.set(0, forKey: keyInitialRep)
  //      let type:Int = envType.rawValue.hashValue
        UserDefaults.standard.set(envType.rawValue, forKey: keyEnvironmentType)
    }
    
    
    
    class  func getEnvironmentType() -> EnvironmentType  {
        //  UserDefaults.standard.set(0, forKey: keyInitialRep)
        var environmentT:EnvironmentType = .Production
        
     if   let environmentType:String = UserDefaults.standard.value(forKey: keyEnvironmentType) as? String
        
     {  if environmentType == "Production"
        {
        environmentT = .Production
        
        }
        else if environmentType == "Development"
        {
            environmentT = .Development

        }
        }
        
        return environmentT
    }
    
    
    
    
    
    
    
    //#MARK:- setAMName
    
    class func setAMName(amName:String){
        UserDefaults.standard.set(amName, forKey: keyAMname)
    }
    //#MARK:- getAMName
    
    class func getAMName() -> String{
        let currentAMName:String? = UserDefaults.standard.value(forKey: keyAMname) as? String
        return currentAMName ?? ""
    }
    
    //#MARK: - SESSIONID MAMAGEMET
    
    class  func setSessionID(sessionID:String)  {
     //   let keyChain = KeychainWrapper.standard
        
       // let _:Bool =    keyChain.set(sessionID, forKey:keySessionID , withAccessibility: .always)
        
     //   UserDefaults.standard.set(sessionID, forKey: keySessionID)
        
                let defaults = UserDefaults.standard
        
                defaults.set(sessionID, forKey: keySessionID)
                defaults.synchronize()
    }
    class   func getSissionID() -> String?{
//        let keyChain = KeychainWrapper.standard
//        var sessionID:String? = nil
//        
//        if let data = keyChain.data(forKey: keySessionID)
//        {
//            sessionID = String(data: data, encoding: .utf8)
//
//        
//        }
        
          let sessionID:String? = UserDefaults.standard.value(forKey: keySessionID) as? String
        print(sessionID ?? "session id is nil" )

        return sessionID
        
    }
    class func setFresh(fresh:Bool){
        UserDefaults.standard.set(fresh, forKey: keyFresh)
    }
    class func isFresh() -> Bool?{
        let isFresh:Bool? = UserDefaults.standard.value(forKey: keyFresh) as! Bool?
        return  isFresh
    }
    //    class   func getDeviceToken() -> String?{
    //        let deviceToken:String? = UserDefaults.standard.value(forKey: keyDeviceToken) as! String?
    //        return deviceToken
    //    }
    
    //#MARK:- setDeviceTooken
    
    class  func setDeviceTooken(deviceToken:String)  {
        UserDefaults.standard.set(deviceToken, forKey: keyDeviceToken)
    }
    
    //    class   func getCustomerDetails() -> NSDictionary?{
    //        let customerDetailsDic:NSDictionary? = UserDefaults.standard.value(forKey: keyCustomerDetailDic) as! NSDictionary?
    //        return customerDetailsDic
    //
    //
    //    }
    //#MARK:- setCustomerDetails
    
    class  func setCustomerDetails(customerDetailsDic:NSDictionary)  {
        let account = customerDetailsDic["account"]
        UserDefaults.standard.set(account ?? "", forKey: keyCustomerAccount)
        
        let city:String? = customerDetailsDic["city"] as? String
        UserDefaults.standard.set(city ?? "", forKey: keyCustomerCity)
        
        let name:String? = customerDetailsDic["name"] as? String
        UserDefaults.standard.set(name ?? "", forKey: keyCustomerName)
        
        let plant = customerDetailsDic["plant"]
        UserDefaults.standard.set(plant ?? "", forKey: keyCustomerPlant)
        
        let state:String? = customerDetailsDic["state"] as? String
        UserDefaults.standard.set(state ?? "", forKey: keyCustomerState)
        
        let id:Int? = customerDetailsDic["id"] as? Int
        UserDefaults.standard.set(id ?? 1, forKey: keyCustomerID)
        
    }
    //#MARK: - getCustomerDetails
    class func getCustomerDetails() -> NSDictionary?
    {
        let defaults = UserDefaults.standard
        let userDic = [keyCustomerID:defaults.value(forKey: keyCustomerID) ?? 1,keyCustomerAccount:  defaults.value(forKey: keyCustomerAccount) ?? "",keyCustomerCity:defaults.value(forKey: keyCustomerCity) ?? "",keyCustomerName:defaults.value(forKey: keyCustomerName) ?? "",keyCustomerPlant:defaults.value(forKey: keyCustomerPlant) ?? "",keyCustomerState:defaults.value(forKey: keyCustomerState) ?? ""] as NSDictionary
        return userDic
    }
    //#MARK:- getCustomerID
    
    class func getCustomerID() -> Int?{
        let defaults = UserDefaults.standard
        
        return (defaults.value(forKey: keyCustomerID) as? Int)
        
        
    }
    
    
    class func setNotificationReceivedStatus(status:Bool)
    {
  //  if let sessionID = Utility.getSissionID()
 //   {
        
        UserDefaults.standard.set(status, forKey: isNotificationReceived)

        
   //     }
    
    
    }
    
    
    class func getNotificationReceivedStatus() -> Bool?
    {
        
            let defaults = UserDefaults.standard
            
            return (defaults.value(forKey: isNotificationReceived) as? Bool)
            
        
        
    }
    //#MARK: - getUserTitle
    class   func getUserTitle() -> String?{
        let keyChain = KeychainWrapper.standard
        var userTitle:String? = nil
        if keyChain.data(forKey: keyUserTitle) != nil
        {
        userTitle = String(data: keyChain.data(forKey: keyUserTitle)!, encoding: .utf8)!
        
        }
        //    let userName:String? = UserDefaults.standard.value(forKey: keyUserName) as! String?
        return userTitle
    }
    //#MARK: - setUserTitle
    class  func setUserTitle(userName:String)  {
  
        
        let keyChain = KeychainWrapper.standard
        
        let _:Bool =    keyChain.set(userName, forKey:keyUserTitle , withAccessibility: .always)
        
        // UserDefaults.standard.set(userName, forKey: keyUserName)
    }
  
    //#MARK: - getUserName
    class   func getUserDisplayName() -> String?{
        let keyChain = KeychainWrapper.standard
        var userDisplayName:String? = nil
        if keyChain.data(forKey: keyUserDisplayName) != nil
        {   userDisplayName = String(data: keyChain.data(forKey: keyUserDisplayName)!, encoding: .utf8)!
        }
        
        //    let userName:String? = UserDefaults.standard.value(forKey: keyUserName) as! String?
        return userDisplayName
    }
    //#MARK: - setUserName
    class  func setUserDisplayName(userName:String)  {
        let keyChain = KeychainWrapper.standard
        var newString:String =   userName.replacingOccurrences(of: "User" , with: "")
        newString =  newString.replacingOccurrences(of: "user" , with: "")
        
        newString =  newString.replacingOccurrences(of: "," , with: "")
        newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
        let _:Bool =    keyChain.set(newString, forKey:keyUserDisplayName , withAccessibility: .always)
        
        // UserDefaults.standard.set(userName, forKey: keyUserName)
    }
    
    
    
    
    //#MARK: - getUserName
    class   func getUserName() -> String?{
        let keyChain = KeychainWrapper.standard
        let userName:String = String(data: keyChain.data(forKey: keyUserName)!, encoding: .utf8)!
        
        
        //    let userName:String? = UserDefaults.standard.value(forKey: keyUserName) as! String?
        return userName
    }
    //#MARK: - setUserName
    class  func setUserName(userName:String)  {
        let keyChain = KeychainWrapper.standard
        
        let _:Bool =    keyChain.set(userName, forKey:keyUserName , withAccessibility: .always)
        
        // UserDefaults.standard.set(userName, forKey: keyUserName)
    }
    //#MARK: - setArrayPlants
    class func setArrayPlants(array:[String]){
        
        let unique = Array(Set(array))
        
        UserDefaults.standard.set(unique, forKey: keyArrayPlots)
        
    }
    //#MARK: - getArrayPlants
    class func getArrayPlants() -> [String]?
    {
        let array:[String]? =   UserDefaults.standard.value(forKey: keyArrayPlots) as! [String]?
        return array ;
    }

    class func dateExtractor(dateString:String) -> (day:Int ,month:String , year:Int){
        
        var year = 0
        var month = ""
        var day = 0
        
        
        let inputFormatter = DateFormatter()
        
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let dateO:Date? = inputFormatter.date(from: dateString)
        
        if  let date:Date = dateO
            
        {
            // let date = Date()
            let calendar = Calendar.current
            let arrayMonth:[String] =  calendar.shortMonthSymbols
            
            year = calendar.component(.year, from: date)
            let monthInt = calendar.component(.month, from: date)
            day = calendar.component(.day, from: date)
            month = arrayMonth[monthInt-1]
            print("day = \(day):\(arrayMonth[monthInt-1]):\(year)")
            
            
        }
        return  (day,month,year)
        
        
    }
    
    
    class func dateExtractor2(dateString:String) -> (day:Int ,month:Int , year:Int){
        
        var year = 0
        var month = 0
        var day = 0
        
        
        let inputFormatter = DateFormatter()
        
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let dateO:Date? = inputFormatter.date(from: dateString)
        
        if  let date:Date = dateO
            
        {
            // let date = Date()
            let calendar = Calendar.current
            // let arrayMonth:[String] =  calendar.shortMonthSymbols
            
            year = calendar.component(.year, from: date)
            month = calendar.component(.month, from: date)
            day = calendar.component(.day, from: date)
            // month = arrayMonth[monthInt-1]
            //  print("day = \(day):\(arrayMonth[monthInt-1]):\(year)")
            
            
        }
        return  (day,month,year)
        
        
    }
    
    
    class func createNotificationIconView(type:NotificationType , height :CGFloat, color:UIColor ,haveTarget:Bool) -> UIView{
        
        let viewdate = UIView.init(frame: CGRect(x: 0, y: 0, width: 80, height: height))
        var image:UIImage = UIImage()
        if type == NotificationType.PriceApproval
        {
           viewdate.backgroundColor = color
            if haveTarget
            {
                image = UIImage(named: "PriceApprovalN")!

            }
            else{
                image = UIImage(named: "PriceApprovalNgray")!

            }
        }
     else if type == NotificationType.QuoteAdded
        {
       //  viewdate.backgroundColor = UIColor(colorLiteralRed: 221/255.0, green: 70/255.0, blue: 51/255.0, alpha:1)
            viewdate.backgroundColor = UIColor.clear
            if haveTarget
            {
                image = UIImage(named: "QuoteN")!
                
            }
            else{
                image = UIImage(named: "QuoteNgray")!
                
            }

        }
        
            let imageView = UIImageView.init(image: image)
viewdate.addSubview(imageView)
        imageView.center = viewdate.center

        
        let maskLayer = CAShapeLayer()
        
        let path = UIBezierPath(roundedRect:viewdate.bounds,
                                byRoundingCorners:[.topRight, .bottomRight],
                                cornerRadii: CGSize(width: 8, height:  8))
        
        maskLayer.path = path.cgPath
        viewdate.layer.mask = maskLayer
      //  viewdate.clipsToBounds = true
        
        return viewdate
    }

    
    
    
    
    
    
    
    class func createViewForDate(day:Int ,month:String , year:Int, height:CGFloat) -> UIView{
        
        let viewdate = UIView.init(frame: CGRect(x: 0, y: 0, width: 80, height: height))
        
        let labeldate = UILabel.init(frame: CGRect(x: 0, y: 5, width:35, height:40 ))
        let labelMonth = UILabel.init(frame: CGRect(x: (labeldate.frame.maxX)+5, y: 10, width: 40, height:15))
        let    labelYear = UILabel.init(frame: CGRect(x: (labeldate.frame.maxX)+5, y: (labelMonth.frame.maxY), width: 40, height: 15))
        
        viewdate.backgroundColor = UIColor(red: 7/255.0, green: 138/255.0, blue: 156/255.0, alpha:1)
        var dayString:String = ""
        if day < 10{
            dayString = "0\(day)"
            
        }
        else{
            
            dayString = "\(day)"
            
        }
        
        labeldate.text =  dayString
        labeldate.textAlignment = .right
        labeldate.textColor = UIColor.white
        labeldate.font = UIFont.boldSystemFont(ofSize: 24)
        
        
        labelMonth.text = month 
        labelMonth.textAlignment = .left
        labelMonth.font = UIFont.boldSystemFont(ofSize: 11)
        labelMonth.textColor = UIColor.white
        
        labelYear.text =   String(year)
        labelYear.font = UIFont.boldSystemFont(ofSize: 11)
        labelYear.textAlignment = .left
        labelYear.textColor = UIColor.white
        let maskLayer = CAShapeLayer()
        
        let path = UIBezierPath(roundedRect:viewdate.bounds,
                                byRoundingCorners:[.topRight, .bottomRight],
                                cornerRadii: CGSize(width: 8, height:  8))
        
        maskLayer.path = path.cgPath
        viewdate.layer.mask = maskLayer
        
        viewdate.addSubview(labelMonth)
        viewdate.addSubview(labelYear)
        viewdate.addSubview(labeldate)
        
        return viewdate
    }
    
    
    class func createViewForDateInPriceApproval(day:Int ,month:String , year:Int, height:CGFloat) -> UIView{
        
        let viewdate = UIView.init(frame: CGRect(x: 0, y: 0, width: 80, height: height))
        
        let labeldate = UILabel.init(frame: CGRect(x: 0, y: 25, width:35, height:40 ))
        let labelMonth = UILabel.init(frame: CGRect(x: (labeldate.frame.maxX)+5, y: 30, width: 40, height:15))
        let    labelYear = UILabel.init(frame: CGRect(x: (labeldate.frame.maxX)+5, y: (labelMonth.frame.maxY), width: 40, height: 15))
        
        viewdate.backgroundColor = UIColor(red: 7/255.0, green: 138/255.0, blue: 156/255.0, alpha:1)
        var dayString:String = ""
        if day < 10{
            dayString = "0\(day)"
            
        }
        else{
            
            dayString = "\(day)"
            
        }
        
        labeldate.text =  dayString
        labeldate.textAlignment = .right
        labeldate.textColor = UIColor.white
        labeldate.font = UIFont.boldSystemFont(ofSize: 24)
        
        
        labelMonth.text = month
        labelMonth.textAlignment = .left
        labelMonth.font = UIFont.boldSystemFont(ofSize: 11)
        labelMonth.textColor = UIColor.white
        
        labelYear.text =   String(year)
        labelYear.font = UIFont.boldSystemFont(ofSize: 11)
        labelYear.textAlignment = .left
        labelYear.textColor = UIColor.white
        let maskLayer = CAShapeLayer()
        
        let path = UIBezierPath(roundedRect:viewdate.bounds,
                                byRoundingCorners:[.topRight, .bottomRight],
                                cornerRadii: CGSize(width: 8, height:  8))
        
        maskLayer.path = path.cgPath
        viewdate.layer.mask = maskLayer
        
        viewdate.addSubview(labelMonth)
        viewdate.addSubview(labelYear)
        viewdate.addSubview(labeldate)
        
        return viewdate
    }
    
    
    class  func giveShadowEffectToView(view:UIView){
        
        view.layer.shadowOffset = CGSize(width: 3, height: 5)
        //view.layer.shadowRadius = 4.0
        view.layer.shadowOpacity = 0.60
        view.layer.shadowColor = UIColor.black.cgColor
        //  view.layer.shouldRasterize = true
        
        
        
    }
    
    class   func indexPathsForRowsInSection(_ section: Int, oldCount: Int, newCount :Int) -> [NSIndexPath] {
        return (oldCount-1..<newCount-1).map{NSIndexPath(row: $0, section: section)}
    }
    class   func indexPathsForRowsInSectionInStarting(_ section: Int, oldCount: Int, newCount :Int) -> [NSIndexPath] {
        return (0..<newCount).map{NSIndexPath(row: $0, section: section)}
    }
    
    
   class func readJson() -> NSDictionary? {
    var jsonDic:NSDictionary?
    
        do {
            if let file = Bundle.main.url(forResource: "response", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? NSDictionary {
                    // json is a dictionary
                    print(object)
                    jsonDic = object
                    
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    
    return jsonDic
    
    }
    
    
    class func setApplicationBadgeCount(count:Int)
    {
        DispatchQueue.main.async {
            
//            UIApplication.shared.applicationIconBadgeNumber = 78

            
 UIApplication.shared.applicationIconBadgeNumber = count
         //   NotificationCenter.default.post(name: <#T##NSNotification.Name#>, object: <#T##Any?#>)
            
            NotificationCenter.default.post(name: NSNotification.Name(badgeCountUpdateNotification), object: nil)

            
        }
    
    
    
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func addGestureRecignoizer(toView:UIView , action: Selector? , target:Any?)
    {
        
        toView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        
        
    }
    
    class func getApplicationBadgeCount() -> Int
    {
        var count = 0
        //DispatchQueue.main.async {
        
        count =    UIApplication.shared.applicationIconBadgeNumber
            
            
           
        return count

            
    //    }
     
    }
    
    
}
