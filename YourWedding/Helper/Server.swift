//
//  Server.swift
//  VistarApp
//
//  Created by thinksysuser on 19/01/17.
//  Copyright © 2017 thinksysuser. All rights reserved.
//
import MBProgressHUD
import Foundation
import UIKit
import SystemConfiguration
import Alamofire
import SwiftyJSON


//#MARK: - PROTOCOLS

@objc protocol ServerCallback {
    @objc optional  func logoutFailed();
    @objc optional  func logoutSuccessful();
    @objc optional  func didReceiveResponse(dataDic:NSDictionary? , response:URLResponse?) -> Void ;
    @objc optional  func didFailWithError(error:String) -> Void;
}


class Server :NSObject{
    struct AFSessionManager {
        static let sharedManager:SessionManager = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            let serverTrustPolicies: [String: ServerTrustPolicy] = [
                "kBaseUrl": .disableEvaluation
            ]
            
            // Create custom manager
            
            configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            
            let manager = SessionManager(
                configuration: configuration
                ,
                serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
            )

            
            return manager
        }()
        
        
    }

    
    weak var delegate: ServerCallback?
    var callingViewController:UIViewController?
    
    

    
    func makeSessionWithTimeout() -> URLSession{
    
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 30.0
        let session = URLSession(configuration: configuration)
    
    return session
    }
    
 
    
    //#MARK: - REQUEST HELPERS
    
    func hitPutRequest(url:String ,inputIsJson:Bool  ,callingViewController:UIViewController?, completion:@escaping  (Data?, URLResponse?, Error?) -> Swift.Void){
        
        
        // AFSessionManager.sharedManager.request(URL(string: url)!, method: .post, parameters: parametresJsonDic, encoding: URLEncoding.default, headers: ["":""])
        //  sharedManager.request
        //    let _:UIViewController = self.delegate as! UIViewController
        if isInternetAvailable(){
            self.callingViewController = callingViewController
            if self.callingViewController?.view != nil {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: (callingViewController?.view)!, animated: true)
                    
                }
            }
            //  print(postString)
            
            if  let encodedRequest:URLRequest = makeEncodedRequest(urlString: url, method: HTTPMethod.put, parametresJsonDic: nil, isLoginRequest: false)
            {
                let urlPost = URL(string: url)
                let session = makeSessionWithTimeout()
                let task = session.dataTask(with: encodedRequest) { data, response, error in
                    DispatchQueue.main.async {
                        if self.callingViewController?.view != nil {
                            MBProgressHUD.hide(for: (self.callingViewController?.view)!, animated: true)
                        }
                    }
                    self.handelRsponse(data: data, response: response, error: error, inputIsJson: inputIsJson, url: url, parametresJsonDic: nil, parametresJsonArray: nil,callingViewController:callingViewController, completion: completion, isGet:false , isLazy:false)
                }
                task.resume()
            }
                
            else{
                self.delegate?.didFailWithError?(error:kMessageParametresError)
            }
            
        }
        else{
            self.delegate?.didFailWithError?(error:kMessageNoInternetError)
            
            
            //   ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Internet Not Available.", withController: vc)
        }
    }


    func hitDeleteRequest(url:String ,inputIsJson:Bool  ,callingViewController:UIViewController?, completion:@escaping  (Data?, URLResponse?, Error?) -> Swift.Void){
        
        
        // AFSessionManager.sharedManager.request(URL(string: url)!, method: .post, parameters: parametresJsonDic, encoding: URLEncoding.default, headers: ["":""])
        //  sharedManager.request
        //    let _:UIViewController = self.delegate as! UIViewController
        if isInternetAvailable(){
            self.callingViewController = callingViewController
            if self.callingViewController?.view != nil {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: (callingViewController?.view)!, animated: true)
                    
                }
            }
            //  print(postString)
            
            if  let encodedRequest:URLRequest = makeEncodedRequest(urlString: url, method: HTTPMethod.delete, parametresJsonDic: nil, isLoginRequest: false)
            {
                let urlPost = URL(string: url)
                let session = makeSessionWithTimeout()
                let task = session.dataTask(with: encodedRequest) { data, response, error in
                    DispatchQueue.main.async {
                        if self.callingViewController?.view != nil {
                            MBProgressHUD.hide(for: (self.callingViewController?.view)!, animated: true)
                        }
                    }
                    self.handelRsponse(data: data, response: response, error: error, inputIsJson: inputIsJson, url: url, parametresJsonDic: nil, parametresJsonArray: nil,callingViewController:callingViewController, completion: completion, isGet:false , isLazy:false)
                }
                task.resume()
            }
                
            else{
                self.delegate?.didFailWithError?(error:kMessageParametresError)
            }
            
        }
        else{
            self.delegate?.didFailWithError?(error:kMessageNoInternetError)
            
            
            //   ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Internet Not Available.", withController: vc)
        }
    }
    
    
    
    func hitPostWithData(url:String ,inputIsJson:Bool  , postDict : NSMutableDictionary? , parametresJsonDic :NSDictionary?  ,parametresJsonArray:NSArray?,callingViewController:UIViewController?, completion:@escaping  (Data?, URLResponse?, Error?) -> Swift.Void){
        
        
        // AFSessionManager.sharedManager.request(URL(string: url)!, method: .post, parameters: parametresJsonDic, encoding: URLEncoding.default, headers: ["":""])
        //  sharedManager.request
        //    let _:UIViewController = self.delegate as! UIViewController
        if isInternetAvailable(){
            self.callingViewController = callingViewController
            if self.callingViewController?.view != nil {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: (callingViewController?.view)!, animated: true)
                    
                }
            }
            //  print(postString)
            
            if  let encodedRequest:URLRequest = makeEncodedRequest(urlString: url, method: HTTPMethod.post, parametresJsonDic: parametresJsonDic, isLoginRequest: false)
            {
                var encodeRequest = encodedRequest
                let session = makeSessionWithTimeout()
                let postData: Data = NSKeyedArchiver.archivedData(withRootObject:postDict ?? [:])
               encodeRequest.httpBody = postData
                let task = session.dataTask(with: encodeRequest) { data, response, error in
                    DispatchQueue.main.async {
                        if self.callingViewController?.view != nil {
                            MBProgressHUD.hide(for: (self.callingViewController?.view)!, animated: true)
                        }
                    }
                    self.handelRsponse(data: data, response: response, error: error, inputIsJson: inputIsJson, url: url, parametresJsonDic: parametresJsonDic, parametresJsonArray: parametresJsonArray,callingViewController:callingViewController, completion: completion, isGet:false , isLazy:false)
                }
                task.resume()
            }
                
            else{
                self.delegate?.didFailWithError?(error:kMessageParametresError)
            }
            
        }
        else{
            self.delegate?.didFailWithError?(error:kMessageNoInternetError)
            
            
            //   ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Internet Not Available.", withController: vc)
        }
    }
    
    func hitPostRequest(url:String ,inputIsJson:Bool  , parametresJsonDic :NSDictionary? ,parametresJsonArray:NSArray?,callingViewController:UIViewController?, completion:@escaping  (Data?, URLResponse?, Error?) -> Swift.Void){
      
        
       // AFSessionManager.sharedManager.request(URL(string: url)!, method: .post, parameters: parametresJsonDic, encoding: URLEncoding.default, headers: ["":""])
      //  sharedManager.request
    //    let _:UIViewController = self.delegate as! UIViewController
        if isInternetAvailable(){
            self.callingViewController = callingViewController
            if self.callingViewController?.view != nil {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: (callingViewController?.view)!, animated: true)

                }
            }
            //  print(postString)
            
            if  let encodedRequest:URLRequest = makeEncodedRequest(urlString: url, method: HTTPMethod.post, parametresJsonDic: parametresJsonDic, isLoginRequest: false)
            {
              let urlPost = URL(string: url)
                let session = makeSessionWithTimeout()
                let task = session.dataTask(with: encodedRequest) { data, response, error in
                    DispatchQueue.main.async {
                        if self.callingViewController?.view != nil {
                            MBProgressHUD.hide(for: (self.callingViewController?.view)!, animated: true)
                        }
                    }
                    self.handelRsponse(data: data, response: response, error: error, inputIsJson: inputIsJson, url: url, parametresJsonDic: parametresJsonDic, parametresJsonArray: parametresJsonArray,callingViewController:callingViewController, completion: completion, isGet:false , isLazy:false)
                }
                task.resume()
            }
                
            else{
                self.delegate?.didFailWithError?(error:kMessageParametresError)
            }

        }
        else{
                 self.delegate?.didFailWithError?(error:kMessageNoInternetError)

            
         //   ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Internet Not Available.", withController: vc)
        }
    }
    
    
    
    
    func hitPostRequestInBackground(url:String ,inputIsJson:Bool  , parametresJsonDic :NSDictionary? ,parametresJsonArray:NSArray?,callingViewController:UIViewController?, completion:@escaping  (Data?, URLResponse?, Error?) -> Swift.Void){
        //    let _:UIViewController = self.delegate as! UIViewController
        if isInternetAvailable(){

            let urlPost = URL(string: url)
                let session = makeSessionWithTimeout()
            let task = session.dataTask(with: urlPost!) { data, response, error in
                    DispatchQueue.main.async {
                        //                    if self.callingView != nil {
                        //
                        //                        MBProgressHUD.hide(for: self.callingView!, animated: true)
                        //                    }
                    }
                    self.handelRsponse(data: data, response: response, error: error, inputIsJson: inputIsJson, url: url, parametresJsonDic: parametresJsonDic, parametresJsonArray: parametresJsonArray,callingViewController:callingViewController, completion: completion, isGet:false , isLazy:false)
                }
                task.resume()
            
            
        
            
        }
        else{
           self.delegate?.didFailWithError?(error:kMessageNoInternetError)
            
            
            //   ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Internet Not Available.", withController: vc)
        }
    }


    
    func makeEncodedRequest(urlString:  String  ,method:HTTPMethod , parametresJsonDic :NSDictionary? , isLoginRequest:Bool) -> URLRequest?{
        
  
        
        var encodedRequest:URLRequest? = nil
        var request:URLRequest? = nil
        do{
            
                  request = try URLRequest(url: URL(string:urlString)!, method: method, headers: appliedHeaders)
            
        }
        catch{
            
            
        }
   
        if request != nil{
            
          //  let sessionID = Utility.getSissionID()
            
            
            
            let parametresDicWithSessionID:NSMutableDictionary = NSMutableDictionary(dictionary: parametresJsonDic ?? NSDictionary())
            
            if !isLoginRequest
            {
               // parametresDicWithSessionID.setValue(sessionID, forKey: "session")

                
            }
            
            
            let encoding = URLEncoding.init(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .numeric)
            do {
                
                encodedRequest =   try encoding.encode(request!, with: parametresDicWithSessionID as? Parameters)
            }
            catch{
                
                
            }
            
        }
        print("request going to hit url--- \(encodedRequest?.url?.absoluteString ?? "no url") and parametres --- \(String(describing: String(data: encodedRequest?.httpBody ?? Data() , encoding: .utf8))) and original parametres --- \(String(describing:  parametresJsonDic))")

    
        return encodedRequest
    }
    func hitGetRequestForLazyLoading(url:String ,inputIsJson:Bool  , parametresJsonDic :NSDictionary? ,parametresJsonArray:NSArray?,callingViewController:UIViewController?, completion:@escaping (Data?, URLResponse?, Error?) -> Swift.Void){
        if isInternetAvailable(){

            
            if  let encodedRequest:URLRequest = makeEncodedRequest(urlString: url, method: HTTPMethod.get, parametresJsonDic: parametresJsonDic, isLoginRequest: false)
            {
                let session = makeSessionWithTimeout()
                
                let task = session.dataTask(with: encodedRequest) { data, response, error in
                    
                    self.handelRsponse(data: data, response: response, error: error, inputIsJson: inputIsJson, url: url, parametresJsonDic: parametresJsonDic, parametresJsonArray: parametresJsonArray, callingViewController:callingViewController, completion: completion , isGet:true , isLazy:true)
                }
                task.resume()
            }
                
            else{
                self.delegate?.didFailWithError?(error:kMessageParametresError)
            }
        }
        else{
            
            self.delegate?.didFailWithError?(error: kMessageNoInternetError)
        }
    }
    
    func hitGetRequest(url:String ,inputIsJson:Bool  , parametresJsonDic :NSDictionary? ,parametresJsonArray:NSArray?,callingViewController:UIViewController?, completion:@escaping (Data?, URLResponse?, Error?) -> Swift.Void){
     //   let vc:UIViewController =       self.delegate as! UIViewController
        if isInternetAvailable(){
            self.callingViewController = callingViewController
            if self.callingViewController?.view != nil {
                DispatchQueue.main.async {
        
             //    _ =  MBProgressHUD.addHudApplied(view: (self.callingViewController?.view)!, animated: true)
                    MBProgressHUD.showAdded(to: (callingViewController?.view)!, animated: true)
                }
            }
      
//            if  let encodedRequest:URLRequest = makeEncodedRequest(urlString: url, method: HTTPMethod.get, parametresJsonDic: parametresJsonDic, isLoginRequest: false)
//            {
            var urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

            let urlGet = URL(string: urlString!)
                let session = makeSessionWithTimeout()
                
            let task = session.dataTask(with: urlGet!) { data, response, error in
                    DispatchQueue.main.async {
                        if self.callingViewController?.view != nil {
                            MBProgressHUD.hide(for: (self.callingViewController?.view)!, animated: true)
                            
                        }
                    }
                    
                    self.handelRsponse(data: data, response: response, error: error, inputIsJson: inputIsJson, url: url, parametresJsonDic: parametresJsonDic, parametresJsonArray: parametresJsonArray,callingViewController:callingViewController, completion: completion, isGet:true , isLazy:false)
                    
                }
                task.resume()
           }
        else{
            self.delegate?.didFailWithError?(error:kMessageNoInternetError)
            
        }
    }

    
    
    func handelRsponse(data:Data?, response:URLResponse?, error:Error? , inputIsJson :Bool , url:String , parametresJsonDic:NSDictionary? , parametresJsonArray:NSArray? ,callingViewController:UIViewController?, completion : @escaping (Data?, URLResponse?, Error?) -> Swift.Void , isGet:Bool , isLazy:Bool){
       // let vc:UIViewController =       self.delegate as! UIViewController
        
        guard let data = data, error == nil else {                                                 // check for fundamental networking error
            //  print("error=\(error)")
        self.delegate?.didFailWithError?(error:kMessageNetworkError)
            return
        }
        let httpStatus = response as? HTTPURLResponse
        if (httpStatus != nil) {
            
            print("error=\(String(describing: httpStatus?.statusCode))")
            
            if (httpStatus?.statusCode == 401){
                
                print("code 401 received for URL --- \(String(describing: response?.url))")
                
              if  let vc =       callingViewController 
              {
                if let vcNav:UINavigationController = vc.navigationController
                {

                
                }
                }
            }
            else  if  httpStatus?.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(String(describing: httpStatus?.statusCode))")
                print("response = \(String(describing: response))")
                
                //                        DispatchQueue.main.async {
                //                            ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Internal Server Error, Please retry.", withController: vc, action: UIAlertAction(title: "OK", style: .default, handler: nil)
                //                            )
                //                        }
                self.delegate?.didFailWithError?(error:kMessageServerError)
            }
                
            else {
                
                do {
                    if   let parsedData:NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    {
                        if let error = parsedData.value(forKey: "error") as? String
                        {
                            self.delegate?.didFailWithError?(error:"error:\(error)")
                            
                            //    ModalViewController.showAlert(alertTitle: "error", andMessage: "Error Received from server - \(error)", withController: vc)
                            
                        }
                        else{
                            self.delegate?.didReceiveResponse?(dataDic: parsedData as NSDictionary?,response: response)
                            print(parsedData)
                            completion(nil, nil, nil)

                        }
                        
                    }
                    
                } catch let error as NSError {
                    
                    self.delegate?.didFailWithError?(error:kMessageInvalidResponseError)
                    
                    
                    //   ModalViewController.showAlert(alertTitle: "error", andMessage: "Invalid Response Received from server ", withController: vc)
                    
                    print(error)
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                
            }
            
        }
        
    }
    func requestWith(endUrl: String, parameters: [String : Any], onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let url = endUrl
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
//            if let data = imageData{
//                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
//            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
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
    
}
