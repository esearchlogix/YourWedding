//
//  WebViewViewController.swift
//  Ribbons
//
//  Created by Alekh Verma on 05/12/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class WebViewViewController: UIViewController,WKNavigationDelegate {
 var webView: WKWebView? = WKWebView()
    var cart : Bool? = false
 var checkoutView : CheckoutViewModel?
    let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.progressTintColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    deinit {
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float((webView?.estimatedProgress)!)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("jdvsbczxjgvbjvdfsjvsdjhvdjhv fjshdxzvchjscvjdhsbvchjxvzbjhcvxjhzvcbjh")
        self.methodToSetSideMenuButtonInNavigationBarPaymentShopify()
        self.webView?.addObserver(self,
                                  forKeyPath: #keyPath(WKWebView.estimatedProgress),
                                  options: .new,
                                  context: nil)
        
        let activeCustomerAccessToken = UserDefaults.standard.string(forKey: keyToken)
        let url = checkoutView?.webURL
        var request = URLRequest(url: url!)
        request.setValue(activeCustomerAccessToken, forHTTPHeaderField: "X-Shopify-Customer-Access-Token")
        
        
        // init and load request in webview.
        self.webView?.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        //webView?.frame  =
        self.webView?.navigationDelegate = self
        self.webView?.load(request as URLRequest)
        self.webView?.allowsBackForwardNavigationGestures = true
        
        self.view.addSubview(self.webView! )
        [self.progressView].forEach { self.view.addSubview($0) }
        self.progressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.progressView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            self.progressView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        self.progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true
       

        // Do any additional setup after loading the view.
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        print("webview url.........\(webView.url)")
        if webView.url?.absoluteString.range(of: "thank_you") != nil {
            webView.stopLoading()
            DispatchQueue.main.async {
                let alertController = UIAlertController(title:kAppName, message:"Order is created Successfully." , preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler:{ action in
                    webView.removeFromSuperview()
                    let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                    do {
                        try context.execute(deleteRequest)
                        try context.save()
                        let destinationViewController = OrderHistoryViewController(nibName: "OrderHistoryViewController", bundle: nil)
                        self.navigationController?.pushViewController(destinationViewController, animated: true)
                    } catch {
                        print ("There was an error")
                    }
                })
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            
        }else{
            
        }
        
    }
    func showProgressView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 1
        }, completion: nil)
    }
    
    func hideProgressView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 0
        }, completion: nil)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
    
    
    func methodToSetSideMenuButtonInNavigationBarPaymentShopify(){
        
        let backPaymentButton = UIButton()
        backPaymentButton.setImage(#imageLiteral(resourceName: "BackIcon"), for: .normal)
        backPaymentButton.frame = CGRect(x:0,y:0,width:47,height:47)
        backPaymentButton.addTarget(self, action: #selector(paymentBackButtonAction(sender:)), for: .touchUpInside)
        let navigateSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        navigateSpacer.width = 0
        
        
        let leftBarButton = UIBarButtonItem()
        // leftBarButton.style = .plain
        leftBarButton.customView = backPaymentButton
        
        self.navigationItem.setLeftBarButtonItems([navigateSpacer,leftBarButton], animated: false)
        
        let titleImage = UIImageView(frame: CGRect(x: 0.0, y: 10.0, width: 100, height: 40))
        titleImage.image = #imageLiteral(resourceName: "logoImage")
        
        self.navigationItem.titleView = titleImage
        
        
        let closeButton = UIButton()
        closeButton.setImage(#imageLiteral(resourceName: "cellCrossImage"), for: .normal)
        closeButton.frame = CGRect(x:0,y:0,width:30,height:30)
        closeButton.addTarget(self, action: #selector(self.methodCloseButton), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = closeButton
        
        
        
        self.navigationItem.setRightBarButtonItems([rightBarButton], animated: false)
        
        
        
    }
    @objc  func methodCloseButton(sender:UIButton?){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title:kAppName, message:"Do you want to close your payment" , preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "YES", style: .default, handler:{ action in
                if self.cart == true{
                    let destinationViewController = CustomTabBarViewController(nibName: "CustomTabBarViewController", bundle: nil)
                    
                    let navigationController = UINavigationController(rootViewController:  destinationViewController)
                    UIApplication.shared.delegate?.window??.rootViewController  = navigationController
                }else{
                self.navigationController?.popViewController(animated: true)
                }
            })
            let CancelAction = UIAlertAction(title: "NO", style: .default, handler:{ action in
                
            })
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @objc  func paymentBackButtonAction(sender:UIButton?){
        
        if (self.webView?.canGoBack)! {
            print("Can go back")
            self.webView?.goBack()
        } else {
            print("Can't go back")
            DispatchQueue.main.async {
                let alertController = UIAlertController(title:kAppName, message:"Do you want to close your payment" , preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "YES", style: .default, handler:{ action in
                    if self.cart == true{
                        let destinationViewController = CustomTabBarViewController(nibName: "CustomTabBarViewController", bundle: nil)
                        
                        let navigationController = UINavigationController(rootViewController:  destinationViewController)
                        UIApplication.shared.delegate?.window??.rootViewController  = navigationController
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                })
                let CancelAction = UIAlertAction(title: "NO", style: .default, handler:{ action in
                    
                })
                alertController.addAction(CancelAction)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
