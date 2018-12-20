 //
//  HomeViewController.swift
//  Ribbons
//
//  Created by Alekh Verma on 18/06/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import AACarousel
import MBProgressHUD
import SDWebImage
import CoreData
import ImageSlideshow


var featuredProductArray : NSArray? = []
 var newProductArray : NSArray? = []
 var popularProductArray : NSArray? = []
 
class HomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate{

    

    var  localSource = [ImageSource(imageString: "SlideImage1")]

    @IBOutlet var slideshow: ImageSlideshow?
    @IBOutlet var scrollViewHome : UIScrollView?
    @IBOutlet var collectionViewCategory : UICollectionView?
    @IBOutlet var collectionViewFeatured : UICollectionView?
    @IBOutlet var collectionViewNewProduct : UICollectionView?
    @IBOutlet var collectionViewPopular : UICollectionView?
    @IBOutlet var featuredSuperView : UIView?
    @IBOutlet var newProductSuperView : UIView?
    @IBOutlet var popularProductSuperView : UIView?

    @IBOutlet var buttonShowAllPopularProduct : UIButton?
   @IBOutlet var buttonShowAllNewProduct : UIButton?
     @IBOutlet var buttonShowAll : UIButton?
    @IBOutlet var imageContact : UIImageView?
    @IBOutlet var categoryTitle : UILabel?
    @IBOutlet var featuredProductTitle : UILabel?
    @IBOutlet var newProductTitle : UILabel?
   
    override func viewDidLoad() {
     
        let ObjServer = Server()
        ObjServer.delegate = self
        ObjServer.hitGetRequest(url: featuredProductUrl, inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:self, completion: {_,_,_ in })
    
      
self.navigationController?.navigationBar.isHidden = true
    slideShow()
  // code for scroll view
        scrollViewHome?.contentSize = CGSize(width: self.view.frame.size.width, height: 1200)
        scrollViewHome?.contentInset=UIEdgeInsets(top: 0,left: 0.0,bottom: 0.0,right: 0.0);
        scrollViewHome?.isExclusiveTouch = false
        scrollViewHome?.delaysContentTouches = false
        
  // code for collection view
   
        collectionViewCategory?.delegate = self
        collectionViewCategory?.showsVerticalScrollIndicator = true
        collectionViewCategory?.dataSource = self
        collectionViewCategory?.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCollectionCell")
      
            collectionViewCategory?.reloadData()
    
          buttonShowAllNewProduct?.addTarget(self, action: #selector(self.viewAllNewProductAction), for: .touchUpInside)
        buttonShowAllPopularProduct?.addTarget(self, action: #selector(self.viewAllPopularProductAction), for: .touchUpInside)
        buttonShowAll?.addTarget(self, action: #selector(self.viewAllfeaturedProductAction), for: .touchUpInside)
        collectionViewFeatured?.delegate = self
        collectionViewFeatured?.dataSource = self
        collectionViewNewProduct?.delegate = self
        collectionViewNewProduct?.dataSource  = self
        collectionViewPopular?.delegate = self
        collectionViewPopular?.dataSource  = self
        collectionViewFeatured?.register(UINib(nibName: "FeaturedProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "featuredImageCell")
        collectionViewNewProduct?.register(UINib(nibName: "NewProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newProduct")
         collectionViewPopular?.register(UINib(nibName: "PopularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "popularProduct")

        super.viewDidLoad()

    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        if (featuredProductArray?.count) ?? 0 > 0{
            collectionViewFeatured?.reloadData()
        }
        if (newProductArray?.count) ?? 0 > 0{
            collectionViewNewProduct?.reloadData()
        }
    }

    
 // MARK: - Slider show
    func slideShow() {
        // code for slider
        slideshow?.slideshowInterval = 5.0
        slideshow?.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow?.contentScaleMode = UIView.ContentMode.scaleAspectFill
   
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideshow?.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow?.currentPageChanged = { page in
            print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow?.setImageInputs(localSource as! [InputSource])
    }
    
// MARK: - recieve API data
    func didReceiveResponse(dataDic: NSDictionary?, response:URLResponse?) {
        if response?.url == URL(string:  "https://5db043a132bc463ff146cd4dafe4c686:4d46228d1e98c7bd1df570363a0427f5@yourweddinglinen.myshopify.com/admin/products.json?collection_id=60122857537")
           {
        featuredProductArray = dataDic?.object(forKey: "products") as? NSArray
            let ObjServer = Server()
            ObjServer.delegate = self
            ObjServer.hitGetRequest(url: ProductsUrl + "60122955841", inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:nil, completion: {_,_,_ in })
        DispatchQueue.main.async {
        MBProgressHUD.showAdded(to: self.view, animated: true)
      
        self.collectionViewFeatured?.reloadData()
         MBProgressHUD.hide(for: self.view, animated: true)
        }
        
        }else if response?.url == URL(string:  "https://5db043a132bc463ff146cd4dafe4c686:4d46228d1e98c7bd1df570363a0427f5@yourweddinglinen.myshopify.com/admin/products.json?collection_id=60122955841")
        {
            popularProductArray = dataDic?.object(forKey: "products") as? NSArray
            let ObjServer = Server()
            ObjServer.delegate = self
            ObjServer.hitGetRequest(url: ProductsUrl + "60122988609", inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:nil, completion: {_,_,_ in })
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                self.collectionViewPopular?.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        }
        else{
            newProductArray = dataDic?.object(forKey: "products") as? NSArray
            print(newProductArray)
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                self.collectionViewNewProduct?.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
            }

        }
    }
    func didFailWithError(error: String) {
         
        let alertController = UIAlertController(title:kAppName, message:error , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler:{ action in
               })
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }




    
// MARK: - Button Action
    @objc func viewAllPopularProductAction(sender : UIButton){
        var sections : [Section]? = tableclothSections

        let destinationViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
        destinationViewController.productsArray = []
        destinationViewController.productsArray?.addObjects(from: (popularProductArray as? [Any]) ?? [])
        destinationViewController.viewTitle = "Popular Products"
        destinationViewController.colourFilter = sections![1].colorFilter
        destinationViewController.sizeFilter = sections![1].sizeFilter
        destinationViewController.shapeFilter = sections![1].shapeFilter
        
        destinationViewController.isRequest = false
        selectedIndexPaths = []
        arraySelectedIndexPath = []
        productArray = []
        let navigationController = UINavigationController(rootViewController:  destinationViewController)
        UIApplication.shared.delegate?.window??.rootViewController  = navigationController
      //  Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
    }
    
    @objc func viewAllNewProductAction(sender : UIButton){
        
        let destinationViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
        destinationViewController.productsArray = []
        destinationViewController.productsArray?.addObjects(from: (newProductArray as? [Any]) ?? [])
        destinationViewController.viewTitle = "New Products"
        destinationViewController.colourFilter = ["Black","Polyester"]
        destinationViewController.sizeFilter = ["108 Inch Round"]
        destinationViewController.shapeFilter = ["Round"]
        destinationViewController.isRequest = false
        selectedIndexPaths = []
        arraySelectedIndexPath = []
        productArray = []
        let navigationController = UINavigationController(rootViewController:  destinationViewController)
        UIApplication.shared.delegate?.window??.rootViewController  = navigationController
        //Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
    }
    
    @objc func viewAllfeaturedProductAction(sender : UIButton){
   
        let destinationViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
        destinationViewController.productsArray = []
        destinationViewController.productsArray?.addObjects(from: (featuredProductArray as? [Any]) ?? [])
        destinationViewController.viewTitle = "Featured products"
        destinationViewController.colourFilter = ["Apple Green","Black","Burgundy","Gold","Light Blue","Light Pink","Polyester"]
        destinationViewController.sizeFilter = ["108 Inch Round"]
        destinationViewController.shapeFilter = ["Round"]
        destinationViewController.isRequest = false
        selectedIndexPaths = []
        arraySelectedIndexPath = []
        productArray = []
        let navigationController = UINavigationController(rootViewController:  destinationViewController)
        UIApplication.shared.delegate?.window??.rootViewController  = navigationController
//        Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - Collection View Delegate
extension HomeViewController {
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
     
        
        if collectionView.tag == 103{
            return 4
        }else if collectionView.tag == 102{
            if  (featuredProductArray?.count) ?? 0 > 0{
                if (featuredProductArray?.count) ?? 0 > 4{
                  return 4
                }else{
                    return (featuredProductArray?.count) ?? 0
                }
            
            }else{
                return 0
            }
        }else if collectionView.tag == 104{
            if  (newProductArray?.count) ?? 0 > 0{
                if (newProductArray?.count) ?? 0 > 8{
                    return 8
                }else{
                    return (newProductArray?.count) ?? 0
                }
                
            }else{
                return 0
            }
        }else if collectionView.tag == 105 {
            if  (popularProductArray?.count) ?? 0 > 0{
                if (popularProductArray?.count) ?? 0 > 8{
                    return 8
                }else{
                    return (popularProductArray?.count) ?? 0
                }
                
            }else{
                return 0
            }
        }
        return arraySlideOfferImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       
           
        
        if collectionView.tag == 103 || collectionView.tag == 102{
            return UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
        return UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        
    }

    //3
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collCell : UICollectionViewCell? = UICollectionViewCell()
        if collectionView.tag == 102{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredImageCell", for: indexPath) as? FeaturedProductCollectionViewCell
            
            let imageStr = ((featuredProductArray?.object(at: indexPath.item) as? NSDictionary)?.object(forKey: "image") as? NSDictionary)?.object(forKey: "src")
            cell?.productImage?.sd_setImage(with: URL(string: (imageStr as? String) ?? "" ))

            //cell?.productImage?.image = UIImage(named: imageStr as! String)
            cell?.productName?.text = (featuredProductArray?.object(at: indexPath.item ) as? NSDictionary)?.object(forKey: "title") as? String
            //Utility.giveShadowEffectToView(view: (cell?)!)

          
            return cell!
            
            
        }else if collectionView.tag == 103 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionCell", for: indexPath) as? CategoriesCollectionViewCell
            let imageStr = arrayCategoryImages[indexPath.item]
            
        
            cell?.categoryImage?.image = UIImage(named: (imageStr as? String) ?? "rectTblClothImage")
            Utility.giveShadowEffectToView(view: (cell?.categoryImageSuperView)!)
            
            
            
            return cell!
            
        }else if collectionView.tag == 104 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newProduct", for: indexPath) as? NewProductCollectionViewCell
            let imageStr = ((newProductArray?.object(at: indexPath.item) as? NSDictionary)?.object(forKey: "image") as? NSDictionary)?.object(forKey: "src")
            cell?.newProductImage?.sd_setImage(with: URL(string: (imageStr as? String) ?? "" ))
            
            //cell?.productImage?.image = UIImage(named: imageStr as! String)
            cell?.newProductName?.text = (newProductArray?.object(at: indexPath.item ) as? NSDictionary)?.object(forKey: "title") as? String
          //  Utility.giveShadowEffectToView(view: (cell?.newProductImage)!)
            
            return cell!
            
        }else if collectionView.tag == 105 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularProduct", for: indexPath) as? PopularCollectionViewCell
            let imageStr = ((popularProductArray?.object(at: indexPath.item) as? NSDictionary)?.object(forKey: "image") as? NSDictionary)?.object(forKey: "src")
            cell?.popularProductImage?.sd_setImage(with: URL(string: (imageStr as? String) ?? "" ))
            
            //cell?.productImage?.image = UIImage(named: imageStr as! String)
            cell?.popularProductName?.text = (popularProductArray?.object(at: indexPath.item ) as? NSDictionary)?.object(forKey: "title") as? String
            //  Utility.giveShadowEffectToView(view: (cell?.newProductImage)!)
            
            return cell!
            
        }
        return collCell!
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 102{
           return CGSize(width: (screenWidth-30)/2, height: 200)
        }
        else if collectionView.tag == 104{
            return  CGSize(width: 100, height: 130)
        } else if collectionView.tag == 105{
            return  CGSize(width: 100, height: 130)
        }
        else{
            if indexPath.item == 4 || indexPath.item == 5 {
                return  CGSize(width: (screenWidth-20), height: 200)

            }
            return  CGSize(width: (screenWidth-30)/2, height: 200)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if collectionView.tag == 102
        {
        let destinationViewController = ProductDetailViewController(nibName: "ProductDetailViewController", bundle: nil)
        destinationViewController.productDetailDict = featuredProductArray?.object(at: indexPath.item ) as? NSDictionary
            let navigationController = UINavigationController(rootViewController:  destinationViewController)
            UIApplication.shared.delegate?.window??.rootViewController  = navigationController
      //  Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
           
         }
        else if collectionView.tag == 103
        {
             var sections : [Section]? = tableclothSections
            switch indexPath.row {
                
                case 0:
                    let destinationViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
                    destinationViewController.productsArray = []
                    destinationViewController.viewTitle = "Polyester Rectangular Tablecloths"
                    destinationViewController.collectionID = 60117745729
                    destinationViewController.isRequest = true
                    selectedIndexPaths = []
                    arraySelectedIndexPath = []
                    productArray = []
                    let navigationController = UINavigationController(rootViewController:  destinationViewController)
                    UIApplication.shared.delegate?.window??.rootViewController  = navigationController
                   // self.navigationController?.pushViewController(destinationViewController, animated: true)
                
                case 1:
                    let destinationViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
                    destinationViewController.productsArray = []
                    destinationViewController.colourFilter = sections![1].colorFilter
                    destinationViewController.sizeFilter = sections![1].sizeFilter
                    destinationViewController.shapeFilter = sections![1].shapeFilter
                    destinationViewController.viewTitle = "Polyester Round Tablecloths"
                    destinationViewController.collectionID = 60117680193
                    destinationViewController.isRequest = true
                    selectedIndexPaths = []
                    arraySelectedIndexPath = []
                    productArray = []
                 
                    let navigationController = UINavigationController(rootViewController:  destinationViewController)
                    UIApplication.shared.delegate?.window??.rootViewController  = navigationController
                   // self.navigationController?.pushViewController(destinationViewController, animated: true)
                
                case 2:
                    let destinationViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
                    destinationViewController.productsArray = []
                    destinationViewController.colourFilter = sections![4].colorFilter
                    destinationViewController.sizeFilter = sections![4].sizeFilter
                    destinationViewController.shapeFilter = sections![4].shapeFilter
                    destinationViewController.viewTitle = "Chair Sash"
                    destinationViewController.collectionID = 60119089217 
                    destinationViewController.isRequest = true
                    selectedIndexPaths = []
                    arraySelectedIndexPath = []
                    productArray = []
                    let navigationController = UINavigationController(rootViewController:  destinationViewController)
                    UIApplication.shared.delegate?.window??.rootViewController  = navigationController
                   // self.navigationController?.pushViewController(destinationViewController, animated: true)
                
                case 3:
                    let destinationViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
                    destinationViewController.productsArray = []
                    destinationViewController.viewTitle = "Jute Burlap Tablecloths"
                    destinationViewController.colourFilter = sections![1].colorFilter
                    destinationViewController.sizeFilter = sections![1].sizeFilter
                    destinationViewController.shapeFilter = sections![1].shapeFilter
                    destinationViewController.collectionID = 60117909569
                    destinationViewController.isRequest = true
                    selectedIndexPaths = []
                    arraySelectedIndexPath = []
                    productArray = []
                    let navigationController = UINavigationController(rootViewController:  destinationViewController)
                    UIApplication.shared.delegate?.window??.rootViewController  = navigationController
                   // self.navigationController?.pushViewController(destinationViewController, animated: true)
                
                default:
                print("")
            }
         }else if collectionView.tag == 104{
            
            let destinationViewController = ProductDetailViewController(nibName: "ProductDetailViewController", bundle: nil)
            destinationViewController.productDetailDict = newProductArray?.object(at: indexPath.item ) as? NSDictionary
            let navigationController = UINavigationController(rootViewController:  destinationViewController)
            UIApplication.shared.delegate?.window??.rootViewController  = navigationController
           // Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
            
         }else if collectionView.tag == 105{
            
            let destinationViewController = ProductDetailViewController(nibName: "ProductDetailViewController", bundle: nil)
            destinationViewController.productDetailDict = popularProductArray?.object(at: indexPath.item ) as? NSDictionary
            let navigationController = UINavigationController(rootViewController:  destinationViewController)
            UIApplication.shared.delegate?.window??.rootViewController  = navigationController
           // Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
            
        }
        
    }
    
    
}
