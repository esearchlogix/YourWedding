//
//  ProductsViewController.swift
//  Ribbons
//
//  Created by Alekh Verma on 28/06/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData

var allArray : NSMutableArray? = []
class ProductsViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet var searchView : UIView?
    @IBOutlet var textFieldSearch : UITextField?
    @IBOutlet var noProductLabel : UILabel?
    @IBOutlet var bottamViewSearchView : UIView?
    @IBOutlet var filterButtonView : UIView?
    @IBOutlet var filterButton : UIButton?
    @IBOutlet var tfSorting : UITextField?
    @IBOutlet var productsCollectionView : UICollectionView?
    
    
    
    var colourFilter : [String]? = []
    var shapeFilter : [String]? = []
    var sizeFilter : [String]? = []
    var productsArray : NSMutableArray? = []
    var isSearch : Bool?
    var searchString : String?
    var viewTitle : String? 
    var isFilter : Bool?
    var collectionID : UInt64?
    var isRequest :  Bool?
    var isGrid : Bool? = true
    var tblView :  UITableView? = UITableView()
    var activeTextField : UITextField? = UITextField()
    var productSearchArray : NSArray? = []
    var arraySize :  NSMutableArray? = []
    var arrayColour : NSMutableArray = []
       var arrayShape : NSMutableArray = []
    var dictAllColourFilter : [String : NSMutableArray?] = [String : NSMutableArray?]()
     var dictAllSizeFilter : [String : NSMutableArray?] = [String : NSMutableArray?]()
      var dictAllShapeFilter : [String : NSMutableArray?] = [String : NSMutableArray?]()
  
   
    override func viewDidLoad() {
        
      //Set navigation Bar
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            self.methodToSetNavigationBarWithoutLogoImage(title: viewTitle ?? kAppName, badgeNumber: result.count)
            
        }catch{
            print("failed")
        }
       
        self.methodToSetBottamNavigationBar(title: viewTitle ?? kAppName)

        
 
        
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(clickFilterView(touch:)))
        //   tapRecognizer.delegate = self
        tapRecognizer.cancelsTouchesInView = false
        filterButtonView?.addGestureRecognizer(tapRecognizer)
        
        if isRequest == true{
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            let ObjServer = Server()
            ObjServer.delegate = self
            ObjServer.hitGetRequest(url: ProductsUrl + "\(collectionID ?? 0)", inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:nil, completion: {_,_,_ in })
        }else{
          
            if isSearch == true{
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                let ObjServer = Server()
                ObjServer.delegate = self
                ObjServer.hitGetRequest(url: ProductsSearchUrl + "\(self.searchString ?? "")", inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:nil, completion: {_,_,_ in })
            }else{
          productSearchArray = productsArray
            if isFilter != true{
            var itemCount :  Int = 0
            for item in productsArray! {
                let dict : NSDictionary? = item as? NSDictionary
                var dictTobeChange : [String:Any] = productsArray?.object(at: itemCount)  as! [String : Any]
                dictTobeChange["price"] = ((dict?.object(forKey: "variants") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "price") as? String
                productsArray![itemCount] = dictTobeChange
                let tagString : String = (dict?.object(forKey: "tags") as? String)!
                let tagArr = tagString.components(separatedBy: ", ")
                for value in tagArr{
                    let tagArray = value.components(separatedBy: "_")
                    for colourString in colourFilter ?? []{
                        if tagArray.contains(colourString){
                            arrayColour.add(tagArray[0])
                            if let arrayColor = dictAllColourFilter[tagArray[0]] {
                                
                                arrayColor?.add(dictTobeChange)
                                dictAllColourFilter[tagArray[0]] = arrayColor
                                // println(x)
                                
                            } else {
                                let arrayColor : NSMutableArray? = []
                                arrayColor?.add(dictTobeChange)
                                dictAllColourFilter[tagArray[0]] = arrayColor
                                // println("key is not present in dict")
                            }
                            
                        }
                    }
                    for shapeString in shapeFilter ?? []{
                        if tagArray.contains(shapeString){
                            arrayShape.add(tagArray[0])
                            if let arrayShape = dictAllShapeFilter[tagArray[0]] {
                                
                                arrayShape?.add(dictTobeChange)
                                dictAllShapeFilter[tagArray[0]] = arrayShape
                                // println(x)
                                
                            } else {
                                let arrayShape : NSMutableArray? = []
                                arrayShape?.add(dictTobeChange)
                                dictAllShapeFilter[tagArray[0]] = arrayShape
                                // println("key is not present in dict")
                            }
                            
                        }
                    }
                    for sizeString in sizeFilter ?? []{
                        if tagArray.contains(sizeString){
                            arraySize?.add(tagArray[0])
                            
                            if let sizeArray = dictAllSizeFilter[tagArray[0]] {
                                
                                sizeArray?.add(dictTobeChange)
                                dictAllSizeFilter[tagArray[0]] = sizeArray
                                // println(x)
                                
                            } else {
                                let sizeArray : NSMutableArray? = []
                                sizeArray?.add(dictTobeChange)
                                dictAllSizeFilter[tagArray[0]] = sizeArray
                                // println("key is not present in dict")
                            }
                        }
                    }
                }
                
                
                itemCount = itemCount + 1
            }
            
            let setColour = NSSet(array: arrayColour as! [Any])
            arrayColour =  NSMutableArray(array: setColour.allObjects)
            let setSize = NSSet(array: arraySize as! [Any])
            arraySize = NSMutableArray(array: setSize.allObjects)
                let setShape = NSSet(array: arrayShape as! [Any])
                arrayShape = NSMutableArray(array: setShape.allObjects)
            
            productSearchArray = productsArray
             allArray = productsArray
            }
        }
        
    }
        
       productsCollectionView?.register(UINib(nibName: "ProductsListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "productsCell")
        // textField padding
        let arrow = UIImageView(image: UIImage(named: "bottamArrow"))
        if let size = arrow.image?.size {
            arrow.frame = CGRect(x: 0.0, y: 8.0, width: 34.0, height: 34.0)
        }
        arrow.contentMode = UIView.ContentMode.center
        tfSorting?.rightView = arrow
        tfSorting?.rightViewMode = UITextField.ViewMode.always
        
        
        Utility.giveBorderToView(view: bottamViewSearchView!, colour: .black)
        Utility.giveShadowEffectToView(view: bottamViewSearchView!)
        Utility.giveShadowEffectToView(view: searchView!)
        Utility.giveBorderToView(view: tfSorting!, colour: .gray)
        Utility.giveBorderToView(view: tfSorting!, colour: .black)
        Utility.giveBorderToView(view: filterButtonView!, colour: .gray)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func clickFilterView(touch: UITouch) {
        let destinationViewController = FilterViewController(nibName: "FilterViewController", bundle: nil)
        destinationViewController.colorFilter = arrayColour
        destinationViewController.sizeFilter = arraySize
        destinationViewController.shapeFilter = arrayShape
        destinationViewController.dictAllProductForColour = dictAllColourFilter
        destinationViewController.dictAllProductForSize = dictAllSizeFilter
         destinationViewController.dictAllProductForShape = dictAllShapeFilter
        if isFilter == true{
            
        }else{
            destinationViewController.allProductArray = productsArray
        }
       
        Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
    }
    
    // MARK: - recieve API data
    func didReceiveResponse(dataDic: NSDictionary?, response:URLResponse?) {
        let productArray : [Any] = dataDic?.object(forKey: "products") as! [Any]
        productsArray?.addObjects(from: productArray)
           productSearchArray = productArray as NSArray
        var itemCount :  Int = 0
        if productArray.count > 0{
             DispatchQueue.main.async {
            self.noProductLabel?.isHidden = true
            self.productsCollectionView?.isHidden = false
            self.bottamViewSearchView?.isHidden = false
            }
        for item in productsArray! {
            let dict : NSDictionary? = item as? NSDictionary
            var dictTobeChange : [String:Any] = productsArray?.object(at: itemCount)  as! [String : Any]
            dictTobeChange["price"] = ((dict?.object(forKey: "variants") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "price") as? String
            productsArray![itemCount] = dictTobeChange
            let tagString : String = (dict?.object(forKey: "tags") as? String)!
            let tagArr = tagString.components(separatedBy: ", ")
            for value in tagArr{
             let tagArray = value.components(separatedBy: "_")
                for colourString in colourFilter ?? []{
                if tagArray.contains(colourString){
                    arrayColour.add(tagArray[0])
                    if let arrayColor = dictAllColourFilter[tagArray[0]] {
                      
                        arrayColor?.add(dictTobeChange)
                            dictAllColourFilter[tagArray[0]] = arrayColor
                           // println(x)
                        
                    } else {
                        let arrayColor : NSMutableArray? = []
                        arrayColor?.add(dictTobeChange)
                        dictAllColourFilter[tagArray[0]] = arrayColor
                       // println("key is not present in dict")
                    }
                    
                }
                }
                for shapeString in shapeFilter ?? []{
                    if tagArray.contains(shapeString){
                        arrayShape.add(tagArray[0])
                        if let arrayShape = dictAllShapeFilter[tagArray[0]] {
                            
                            arrayShape?.add(dictTobeChange)
                            dictAllShapeFilter[tagArray[0]] = arrayShape
                            // println(x)
                            
                        } else {
                            let arrayShape : NSMutableArray? = []
                            arrayShape?.add(dictTobeChange)
                            dictAllShapeFilter[tagArray[0]] = arrayShape
                            // println("key is not present in dict")
                        }
                        
                    }
                }
               for sizeString in sizeFilter ?? []{
                if tagArray.contains(sizeString){
                    arraySize?.add(tagArray[0])
                    
                    if let sizeArray = dictAllSizeFilter[tagArray[0]] {
                        
                        sizeArray?.add(dictTobeChange)
                        dictAllSizeFilter[tagArray[0]] = sizeArray
                        // println(x)
                        
                    } else {
                        let sizeArray : NSMutableArray? = []
                        sizeArray?.add(dictTobeChange)
                        dictAllSizeFilter[tagArray[0]] = sizeArray
                        // println("key is not present in dict")
                    }
                }
                }
            }
            
         
            itemCount = itemCount + 1
        }
    
        let setColour = NSSet(array: arrayColour as! [Any])
        arrayColour =  NSMutableArray(array: setColour.allObjects)
        let setSize = NSSet(array: arraySize as! [Any])
        arraySize = NSMutableArray(array: setSize.allObjects)
            let setShape = NSSet(array: arrayShape as! [Any])
            arrayShape = NSMutableArray(array: setShape.allObjects)
       
        productSearchArray = productsArray
        allArray = productsArray
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.productsCollectionView?.reloadData()
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                
            }
        }else{
             DispatchQueue.main.async {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

                self.noProductLabel?.isHidden = false
          self.productsCollectionView?.isHidden = true
          self.bottamViewSearchView?.isHidden = true
            }
        }
        }
    

   func didFailWithError(error: String) {
    
    let alertController = UIAlertController(title:kAppName, message:error , preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler:{ action in
        if self.productSearchArray?.count == 0{
        self.navigationController?.popViewController(animated: true)
        }
        
    })
    
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)

}



    //#MARK:- UITextField Dlegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfSorting{
          maketableView(textField: textField)
            return false
        }else{
//        arraySearch =  arrayAllProducts
//        maketableView(textField: textField)
        return true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
//        textFieldSearch?.text = ""
//        arraySearch = arrayAllProducts
//        tableViewSearch?.removeFromSuperview()
//        tableViewSearch = nil
        removeTableView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        textField.resignFirstResponder()
//        textFieldSearch?.text = ""
//        arraySearch = arrayAllProducts
//        tableViewSearch?.removeFromSuperview()
//        arraySearch = nil
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
//        textFieldSearch?.text = ""
//        arraySearch = arrayAllProducts
//        tableViewSearch?.removeFromSuperview()
//        arraySearch = nil
        return true
    }
    
     // MARK: - method for remove tableView
    func removeTableView(){
//        textFieldSearch?.text = ""
//        arraySearch = arrayAllProducts
        activeTextField?.resignFirstResponder()
        tblView?.removeFromSuperview()
        tblView = UITableView()
       // arraySearch = nil
    }
    
     // MARK: - make table View
    func maketableView(textField : UITextField){
      
        tblView?.frame = CGRect(x: (textField.frame.origin.x), y: textField.frame.origin.y + textField.frame.size.height + 128, width: (textField.frame.size.width), height: 250)
        tblView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tblView?.backgroundColor = UIColor.init(red: 95.0/255.0, green: 34.0/255.0, blue: 98.0/255.0, alpha: 1)

        if textField == tfSorting{
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
            cell?.textLabel?.textColor = UIColor.white
            
            Utility.giveBorderToView(view: cell!, colour: .black)
         cell?.backgroundColor = UIColor.init(red: 95.0/255.0, green: 34.0/255.0, blue: 98.0/255.0, alpha: 1)
            return cell!
            
        }else{
            let cell = tblView?.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell?.textLabel?.text = sortingArray.object(at: indexPath.row) as? String
            
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if tableView.tag == 2{
            tfSorting?.text = cell?.textLabel?.text
            
            if indexPath.row == 0{
                productSearchArray = productsArray
            }
            else if indexPath.row == 1{
                let brandDescriptor : NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
                let  sortDescriptors = [brandDescriptor]
                productSearchArray = productSearchArray!.sortedArray(using: sortDescriptors) as NSArray
                }
            else if indexPath.row == 2{

                let brandDescriptor : NSSortDescriptor = NSSortDescriptor(key: "title", ascending: false)
                let  sortDescriptors = [brandDescriptor]
                productSearchArray = productSearchArray!.sortedArray(using: sortDescriptors) as NSArray
            }else if indexPath.row == 3{
                let brandDescriptor : NSSortDescriptor = NSSortDescriptor(key: "price", ascending: true)
                let  sortDescriptors = [brandDescriptor]
                productSearchArray = productSearchArray!.sortedArray(using: sortDescriptors) as NSArray
            }else{
                let brandDescriptor : NSSortDescriptor = NSSortDescriptor(key: "price", ascending: false )
                let  sortDescriptors = [brandDescriptor]
                productSearchArray = productSearchArray!.sortedArray(using: sortDescriptors) as NSArray
            }
         productsCollectionView?.reloadData()
        }
        
        removeTableView()
}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - Collection View Delegate
extension ProductsViewController {
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        
  
        return productSearchArray!.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 30
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,left: 10,bottom: 100,right: 10)
        
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
      
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productsCell", for: indexPath) as? ProductsListCollectionViewCell
            
            let imageStr = ((productSearchArray?.object(at: indexPath.item) as? NSDictionary)?.object(forKey: "image") as? NSDictionary)?.object(forKey: "src")
            cell?.productimage?.sd_setImage(with: URL(string: imageStr as! String ))
            
            cell?.productName?.text = (productSearchArray?.object(at: indexPath.item) as? NSDictionary)?.object(forKey: "title") as? String
            cell?.productRate?.text = ((((productSearchArray?.object(at: indexPath.item ) as? NSDictionary)?.object(forKey: "variants") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "price") as? String)! + "$"
            let count = (((productSearchArray?.object(at: indexPath.item ) as? NSDictionary)?.object(forKey: "variants") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "inventory_quantity") as? Int
        
           if count! < 1 {
            cell?.productAvailableLabel?.text = "SOLD OUT"
            cell?.productAvailableLabel?.backgroundColor = UIColor.init(red: 197.0/255.0, green: 19.0/255.0, blue: 43.0/255.0, alpha: 1)
           }else{
            cell?.productAvailableLabel?.text = "SALE"
            cell?.productAvailableLabel?.backgroundColor = UIColor.init(red: 65.0/255.0, green: 117.0/255.0, blue: 8.0/255.0, alpha: 1)
        }
            
        cell?.productShadowView?.layer.borderColor = UIColor.lightGray.cgColor
            cell?.productShadowView?.layer.borderWidth = 1.0
        Utility.giveShadowEffectToView(view: (cell?.productShadowView)!)
            return cell!

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
     
            return  CGSize(width: (screenWidth-40)/3, height: 203)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController = ProductDetailViewController(nibName: "ProductDetailViewController", bundle: nil)
        destinationViewController.productDetailDict = productSearchArray?.object(at: indexPath.item) as? NSDictionary
        Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
    }
    
    
}

