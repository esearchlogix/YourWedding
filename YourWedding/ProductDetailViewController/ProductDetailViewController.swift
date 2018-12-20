//
//  ProductDetailViewController.swift
//  Ribbons
//
//  Created by Alekh Verma on 29/06/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD
import ImageSlideshow

class ProductDetailViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var scrollViewShipment : UIScrollView?
    @IBOutlet var productName : UILabel?
    @IBOutlet var productImageView : ImageSlideshow?
    @IBOutlet var productImageSuperView :  UIView?
     @IBOutlet var productPriceSuperView :  UIView?
    @IBOutlet var productPriceLabel : UILabel?
    @IBOutlet var productVendorLabel : UILabel?
     @IBOutlet var productStatusLabel : UILabel?
    @IBOutlet var productActualPriceLabel : UILabel?
    @IBOutlet var productCounterSuperView : UIView?
    @IBOutlet var negativeCounterButton : UIButton?
    @IBOutlet var positiveCounterButton : UIButton?
    @IBOutlet var productCounterlabel : UILabel?
    @IBOutlet var addToCartButton : UIButton?
    @IBOutlet var buyButton : UIButton?
    @IBOutlet var textFieldColour : UITextField?
    @IBOutlet var textFieldSize : UITextField?
   
    @IBOutlet var productDescriptionTitle : UILabel?
    @IBOutlet var productDescriptionLabel : UITextView?
    @IBOutlet var productDescriptionSuperView :  UIView?
    @IBOutlet var contentView : UIView?
    
    var productDetailDict : NSDictionary?
    var productQuantity = 1
    var availabeQuantity : Int?
    var varientID : Int?
    var imageStr : String?
    var tblView :  UITableView? = UITableView()
    var varientsArray : NSArray?
    var currentVarient : NSDictionary? = [:]

    override func viewDidLoad() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        var sdWebImageSource : [InputSource]? = []
        
        let imageArray = productDetailDict?.object(forKey: "images") as? NSArray
        var count = 0
        for item in imageArray ?? []{
            let urlString = (imageArray?.object(at: count) as? NSDictionary)?.object(forKey: "src") as? String
            let url:URL = URL(string: urlString ?? "" )!
           
            
                let data = try? Data(contentsOf: url ) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            
                    sdWebImageSource?.append(ImageSource(image: UIImage.sd_image(with: data)!))
            
            count = count + 1
            
        }
    
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
          self.methodToSetNavigationBarWithoutLogoImage(title: kAppName, badgeNumber: result.count)
        }catch{
            print("failed")
        }
        
        
        self.methodToSetBottamNavigationBar(title: "Product Detail" )
       // self.methodNavigationBarBackGroundColor()
     
        productImageView?.slideshowInterval = 5.0
        productImageView?.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        productImageView?.contentScaleMode = UIView.ContentMode.scaleAspectFill
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        productImageView?.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        productImageView?.currentPageChanged = { page in
            print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        productImageView?.setImageInputs(sdWebImageSource!)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        productImageView?.addGestureRecognizer(recognizer)
        productVendorLabel?.text = productDetailDict?.object(forKey: "vendor") as? String
        scrollViewShipment?.contentSize = CGSize(width: self.view.frame.size.width, height: 900)
        scrollViewShipment?.contentInset=UIEdgeInsets.init(top: 64.0,left: 0.0,bottom: 50.0,right: 0.0);
        scrollViewShipment?.isExclusiveTouch = false
        scrollViewShipment?.delaysContentTouches = false
        varientsArray = (productDetailDict?.object(forKey: "variants") as? NSArray)
        if (varientsArray?.count)! < 2{
//            textFieldColour?.text = "No Colour"
//            textFieldSize?.text = "No Size"
            currentVarient = varientsArray?.object(at: 0) as? NSDictionary
        }else{

            currentVarient = varientsArray?.object(at: 0) as? NSDictionary
//            textFieldColour?.text = (varientsArray?.object(at: 0) as? NSDictionary)?.object(forKey: <#T##Any#>)
//            textFieldSize?.text =
        }
        loadContent()
        
    // GiveShadowToView
        Utility.giveShadowEffectToView(view: productImageSuperView!)
         Utility.giveShadowEffectToView(view: productCounterSuperView!)
        Utility.giveShadowEffectToView(view: addToCartButton!)
        Utility.giveShadowEffectToView(view: buyButton!)
        
    
        
        
    // textField padding
//        let arrow = UIImageView(image: UIImage(named: "bottamArrow"))
//        if let size = arrow.image?.size {
//            arrow.frame = CGRect(x: 0.0, y: 8.0, width: 34.0, height: 34.0)
//        }
//        arrow.contentMode = UIViewContentMode.center
//        textFieldSize?.rightView = arrow
//        textFieldSize?.rightViewMode = UITextFieldViewMode.always
//        textFieldColour?.rightView = arrow
//        textFieldColour?.rightViewMode = UITextFieldViewMode.always
        
    //Give border to view
        Utility.giveBorderToView(view: productPriceSuperView!, colour: UIColor.lightGray)

        

        let attributedString = NSMutableAttributedString(string: "Product Description", attributes: [NSAttributedString.Key.underlineStyle : true])
        
        productDescriptionTitle?.attributedText = attributedString
        
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func didTap() {
        let fullScreenController = productImageView?.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController?.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    func loadContent(){
        availabeQuantity = currentVarient?.object(forKey: "inventory_quantity") as? Int
        varientID = currentVarient?.object(forKey: "id") as? Int
        // Product data loading.
        productName?.text = productDetailDict?.object(forKey: "title") as? String
        imageStr = (productDetailDict?.object(forKey: "image") as? NSDictionary)?.object(forKey: "src") as? String
       
        productPriceLabel?.text = " $ " + (currentVarient?.object(forKey: "price") as? String)!
        productActualPriceLabel?.text = " $ " + (currentVarient?.object(forKey: "compare_at_price") as? String)!
        
        
        productCounterlabel?.text = "\(productQuantity)"
        productDescriptionLabel?.text = productDetailDict?.object(forKey: "title") as? String
        
        if availabeQuantity! > 0 {
            productStatusLabel?.text =  "In Stock"
             productStatusLabel?.textColor = UIColor.init(red: 65.0/255.0, green: 117.0/255.0, blue: 8.0/255.0, alpha: 1)
            addToCartButton?.isUserInteractionEnabled = true
            buyButton?.isUserInteractionEnabled = true
        }else{
            productStatusLabel?.text =  "Out of Stock"
            productStatusLabel?.textColor = UIColor.init(red: 153.0/255.0, green: 0.0/255.0, blue: 51.0/255.0, alpha: 1)
            addToCartButton?.isUserInteractionEnabled = false
            addToCartButton?.alpha = 0.5
            buyButton?.alpha = 0.5
            buyButton?.isUserInteractionEnabled = false
            
        }
        // Cut the actual price label text
        
        let text = productActualPriceLabel?.text
        let textRange = NSMakeRange(0, (text?.count)!)
        let attributedText = NSMutableAttributedString(string: text!)
        attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        productActualPriceLabel?.attributedText = attributedText
        
      // button code
        buyButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        buyButton?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        addToCartButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        addToCartButton?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    @IBAction func addQuantity(sender: UIButton){
        if productQuantity < availabeQuantity!{
            productQuantity = productQuantity + 1
            productCounterlabel?.text = "\(productQuantity)"
            
        }
    }
    @IBAction func reduceQuantity(sender: UIButton){
        if productQuantity > 1{
            productQuantity = productQuantity - 1
            productCounterlabel?.text = "\(productQuantity)"
            
        }
    }


    @IBAction func cartButton(sender: UIButton){
     
      
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let result = try? context.fetch(fetchRequest)
        let resultData = result as! [NSManagedObject]
        var index = 0
        var find = false
        for item in resultData{
            if item.value(forKey: "productName") as? String == productDetailDict?.object(forKey: "title") as? String{
                let previousQuantity = item.value(forKey: "quantity") as? Int
                resultData[index].setValue((previousQuantity ?? 00) + 1, forKey: "quantity")
                find = true
            }
            index = index + 1
        }
        if find == true{
        do {
            
            try context.save()
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Product add to cart sucessfully.", withController: self)

           
        }
            
        catch let error as NSError  {
            print("Not able to update value right now \(error)")
        }
        
        }else{
            let entity = NSEntityDescription.entity(forEntityName: "Cart", in: context)
            let newCartProduct = NSManagedObject(entity: entity!, insertInto: context)
            
            newCartProduct.setValue(productDetailDict?.object(forKey: "title") as? String, forKey: "productName")
            let shippingCharge = (varientsArray?.object(at: 0) as? NSDictionary)?.object(forKey: "requires_shipping") as? Bool
            if shippingCharge == true{
            newCartProduct.setValue("Applicable", forKey: "shippingCharge")
            }else{
                newCartProduct.setValue("Not Applicable", forKey: "shippingCharge")
            }
            newCartProduct.setValue(productPriceLabel?.text, forKey: "productPrice")
            newCartProduct.setValue(productQuantity, forKey: "quantity")
            newCartProduct.setValue(imageStr, forKey: "productImageUrl")
            newCartProduct.setValue(availabeQuantity, forKey: "maxQuantity")
            let varientIDString = "gid://shopify/ProductVariant/\(varientID ?? 0000)"
            newCartProduct.setValue(varientIDString.toBase64(), forKey: "id")
        do {
            try context.save()
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
            request.returnsObjectsAsFaults = false
            do {
                
                let result = try context.fetch(request)
                self.methodToSetNavigationBarWithoutLogoImage(title: "Log In", badgeNumber: 4)
            }catch{
                print("failed")
            }
            
            
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Product add to cart sucessfully.", withController: self)
        } catch {
            print("Failed saving")
        }
        }
    }
    
    @IBAction func shareButtonAction(sender : UIButton){
        let shareText =  productName?.text
        let imageCount =  productImageView?.currentPage
        let shareImage : UIImageView? = UIImageView()
        shareImage?.sd_setImage(with: URL(string: imageStr ?? "" ))
        if let image = shareImage?.image {
            let vc = UIActivityViewController(activityItems: [shareText ?? "", image ], applicationActivities: [])
            present(vc, animated: true)
        }
    }
    @IBAction func BuyButtonAction(sender : UIButton){
        let varientIDString = "gid://shopify/ProductVariant/\(varientID ?? 0000)"
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let price = productPriceLabel?.text
        let floatPrice = price?.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
        let floatPriceOri = (floatPrice as NSString?)?.floatValue
        let totalPrice = Float(productQuantity) * floatPriceOri!
        Client.shared.createCheckout(with: productQuantity, ID: varientIDString.toBase64(), activeViewController: self){ checkout in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            if let checkout1 = checkout.checkout {
                print(checkout)
                
                let isLogIn = UserDefaults.standard.bool(forKey: keyIsLogIN)
                if isLogIn == true{
                    let tokenActiveDate = UserDefaults.standard.object(forKey: keyValidDateToken) as! Date
                    if tokenActiveDate > Date(){
                        
                        let destinationViewController = WebViewViewController(nibName: "WebViewViewController", bundle: nil)
                        
                        destinationViewController.checkoutView = checkout.checkout?.viewModel
                        self.navigationController?.pushViewController(destinationViewController, animated: true)
                        
                        return
                        
                    }else{
                        let destinationViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                        destinationViewController.destViewController = self
                        UserDefaults.standard.set("", forKey: keyToken)
                        UserDefaults.standard.set("", forKey: keyValidDateToken)
                        UserDefaults.standard.set(false, forKey: keyIsLogIN)
                        ModalViewController.showAlert(alertTitle: "Session Expire", andMessage: "Your session is Expire,Please LogIn Again", withController: destinationViewController)
                        
                        Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
                    }
                }
                    
                else{
                    let destinationViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                    destinationViewController.destViewController = self

                    Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
                }
            }else
            {
                ModalViewController.showAlert(alertTitle: kAppName, andMessage: "Please try after some time.", withController: self)
            }
        }
        
    }
    //#MARK:- UITextField Dlegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textFieldColour || textField == textFieldSize{
            maketableView(textField: textField)
            return false
        }else{
            
            return true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        removeTableView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    
    // MARK: - method for remove tableView
    func removeTableView(){
        
        tblView?.removeFromSuperview()
        tblView = UITableView()
        
    }
    // MARK: - make table View
    func maketableView(textField : UITextField){
        
        tblView?.frame = CGRect(x: (textField.frame.origin.x), y: textField.frame.origin.y + textField.frame.size.height + 2, width: (textField.frame.size.width), height: 250)
        tblView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tblView?.backgroundColor = UIColor.init(red: 247.0/255.0, green:166.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        
        if textField == textFieldColour{
            tblView?.tag = 2
        }else{
            tblView?.tag = 1
        }
        tblView?.dataSource = self
        tblView?.delegate = self
        
        self.view.addSubview(tblView!)
        
    }
    
    // MARK: - tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 2{
            return sortingArray.count
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 2{
            let cell = tblView?.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell?.textLabel?.text = sortingArray.object(at: indexPath.row) as? String
            cell?.textLabel?.font = UIFont(name: appFont, size: 15.0)
            cell?.textLabel?.textColor = UIColor.darkGray
            
            Utility.giveBorderToView(view: cell!, colour: .black)
            cell?.backgroundColor = UIColor.white
            return cell!
            
        }else{
            let cell = tblView?.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell?.textLabel?.text = sortingArray.object(at: indexPath.row) as? String
            
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
   
        removeTableView()
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
