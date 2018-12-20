//
//  CustomTabBarViewController.swift
//  VistarApp
//
//  Created by thinksysuser on 11/28/16.
//  Copyright © 2016 thinksysuser. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    //#MARK: - PROPERTIES
    
    var homeButton:UIButton = UIButton()
    var middleButton:UIButton = UIButton()
    var searchButton:UIButton = UIButton()
    var backgroundView:UIView = UIView()
    var justLoggedIn:Bool = false
   // var blurrView:UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenheight - 50))
    static  var containerView:ContainerViewForMenu!
    static  var viewToBeMoved:UIView!
      var objmenuTable = SideMenuTable()
    
    //    var setOfButtons:NSArray = []
    //    }
    //#MARK: - SIDE MENU METHODS
    
    func menuAction(sender:UIButton?){
        
        let threashold:CGFloat = CustomTabBarViewController.containerView.frame.size.width/2
        
        if CustomTabBarViewController.containerView.center.x > 0  {
            
            UIView.animate(withDuration: TimeInterval(0.3), delay: 0.0, options: .transitionCurlDown, animations: {
                CustomTabBarViewController.containerView.center = CGPoint(x: -threashold, y: CustomTabBarViewController.containerView.center.y)
            }, completion: {
                isDone in
                if isDone{
                  //  self.blurrView.isHidden = true
                    self.objmenuTable.isHidden = true
                }
            })
        }
        else  if CustomTabBarViewController.containerView.center.x < 0  {
            self.objmenuTable.isHidden = false
            
            UIView.animate(withDuration: TimeInterval(0.4), delay: 0.0, options: .curveEaseOut, animations: {
                CustomTabBarViewController.containerView.center = CGPoint(x: threashold, y: CustomTabBarViewController.containerView.center.y)
            }, completion: {
                isDone in
                if isDone{
                  //  self.blurrView.isHidden = false
                    
                }
            })
        }
        
    }
    
    
    //#MARK:- MethodToSetGesture
    @objc func MethodToSetGesture() {
        let panRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(moveSideMenu(sender:)))
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.minimumNumberOfTouches = 1
        CustomTabBarViewController.containerView.addGestureRecognizer(panRecognizer)
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(hideSideMenu(touch:)))
        //   tapRecognizer.delegate = self
        tapRecognizer.cancelsTouchesInView = false
      //  blurrView.addGestureRecognizer(tapRecognizer)
        CustomTabBarViewController.containerView.addGestureRecognizer(tapRecognizer)
    }
    //#MARK:- moveSideMenu
    @objc func moveSideMenu(sender: Any) {
        //    var objmenuTable = SideMenuTable()
        //         optional public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
        //  objmenuTable = SideMenuTable(frame: containerView.bounds)
        //   containerView.addSubview(objmenuTable)
        //   self.view.bringSubview(toFront: ((sender as? UIPanGestureRecognizer)?.view)!)
        
        // CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
        var translatedPoint: CGPoint? = (sender as? UIPanGestureRecognizer)?.translation(in: self.view)
        if  Float((translatedPoint?.x)!)  > 0.0 {
            self.objmenuTable.isHidden = false
        }
        if (sender as? UIPanGestureRecognizer)?.state == .began {
            firstX = Float((sender as AnyObject).view.center.x)
            firstY = Float((sender as AnyObject).view.center.y)
        }
        // translatedPoint = CGPoint(x: Float(firstX + translatedPoint?.x), y: Float(firstY))
        let xpoint = firstX + Float((translatedPoint?.x)!)
        
        translatedPoint = CGPoint(x: CGFloat(xpoint), y: CGFloat(firstY))
        var x: CGFloat = translatedPoint!.x
        let threashold:CGFloat = CustomTabBarViewController.containerView.frame.size.width/2
        if( x < -threashold ){
            x = -threashold
        }
        else if (x > threashold) {
            x = threashold
            self.objmenuTable.isHidden = false
        }
        translatedPoint = CGPoint(x: x, y: CGFloat((translatedPoint?.y)!))
        (sender as AnyObject).view.center = translatedPoint!
        
        if (sender as? UIPanGestureRecognizer)?.state == .ended {
            
            let velocityX: CGFloat? = (0.2 * ((sender as? UIPanGestureRecognizer)?.velocity(in: self.view).x)!)
            var finalX: CGFloat = translatedPoint!.x + velocityX!
            var finalY = CGFloat(firstY)
            // translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
            
            //   if !UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            //            if UIDevice.current.orientation == UIDeviceOrientation.portrait
            //
            //
            //            {
            if finalX < 0 {
                finalX = -threashold+10
                
            }
            else if finalX > 0 {
                finalX = threashold
                self.objmenuTable.isHidden = false
            }
            if finalY < 0{
                
                finalY = 0
            }
            else if finalY > 1024{
                
                finalY = 1024
            }
            //    }
            //            else{
            //
            //                if finalX < 0{
            //                    //finalX = 0
            //                }
            //                else if finalX > 1024{
            //
            //                    //finalX = 768
            //                }
            //
            //                if finalY < 0 {
            //                    finalY = 0
            //                }
            //                else if finalY > 768{
            //
            //                    finalY = 1024
            //                }
            //            }
            let animationDuration: CGFloat = (abs(velocityX!) * 0.0002) + 0.2
            print("the duration is: \(animationDuration)")
            //            UIView.beginAnimations(nil, context: nil)
            //            UIView.setAnimationDuration(TimeInterval(animationDuration))
            //            UIView.setAnimationCurve(.easeOut)
            //            UIView.setAnimationDelegate(self)
            //            // UIView.setAnimationDidStop(#selector(self.animationDidFinish))
            //              CustomTabBarViewController.containerView.center = CGPoint(x: CGFloat(finalX), y: CGFloat(finalY))
            //           // (sender as AnyObject).view.center = CGPoint(x: CGFloat(finalX), y: CGFloat(finalY))
            //            UIView.commitAnimations()
            
            
            UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0.0, options: .curveEaseOut, animations: {
                CustomTabBarViewController.containerView.center = CGPoint(x: CGFloat(finalX), y: CGFloat(finalY))
            }, completion: {
                isDone in
                if isDone{
                    
                    if CustomTabBarViewController.containerView.center.x > 0 {
                        
                        //                     CustomTabBarViewController.containerView.backgroundColor = UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
                      //  self.blurrView.isHidden = false
                        self.objmenuTable.isHidden = false
                    }
                    else{
                        //                        CustomTabBarViewController.containerView.backgroundColor = UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
                      //  self.blurrView.isHidden = true
                        self.objmenuTable.isHidden = true
                        
                    }
                }
            })
            
        }
    }
    //#MARK:- hideMenu
    func hideMenu( completion:(() -> Void)?) {
        
        let originX:CGFloat = CustomTabBarViewController.containerView.center.x
        if originX > 0 {
            
            let threashold:CGFloat = CustomTabBarViewController.containerView.frame.size.width/2
            let animationDuration: CGFloat = 0.4
            print("the duration is: \(animationDuration)")
            UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0.0, options: .curveEaseOut, animations: {
                CustomTabBarViewController.containerView.center = CGPoint(x: CGFloat(-threashold+10), y: CGFloat(Float((CustomTabBarViewController.containerView.center.y))))
                
            }, completion: {
                isDone in
                if isDone{
                    //  CustomTabBarViewController.containerView.backgroundColor = UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
                   // self.blurrView.isHidden = true
                    self.objmenuTable.isHidden = true
                    
                    if (completion != nil){
                        completion!()
                    }
                }
            })
            //            UIView.beginAnimations(nil, context: nil)
            //            UIView.setAnimationDuration(TimeInterval(animationDuration))
            //            UIView.setAnimationCurve(.easeOut)
            //            UIView.setAnimationDelegate(self)
            //            // UIView.setAnimationDidStop(#selector(self.animationDidFinish))
            //
            //            UIView.commitAnimations()
        }
    }
    // #MARK:- hideSideMenu
    @objc func hideSideMenu(touch: UITouch) {
        let location:CGPoint = touch.location(in: touch.view)
        
        if ( !self.objmenuTable.bounds.contains(location) ) {
            
            self.hideMenu(completion: nil)
            // Point lies inside the bounds.
        }
        
        //        if !touch.view!.isDescendant(of: CustomTabBarViewController.objmenuTable){
        //            self.hideMenu()
        //               }
    }
    func animationCompleted(){
        
    }
    //
    //     public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    //
    //    }
    
    func registerObserverForNotificationUpdate(){
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerForNotificationUpdate(notification:)), name: NSNotification.Name(badgeCountUpdateNotification), object: nil)
    
    
    }
    
    @objc func observerForNotificationUpdate(notification:Notification){
    
    objmenuTable.updateBadgeLabel()
    
    }
    
    
    //#MARK: - VIEW LOAD UNLOAD METHODS
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         let firstViewController = UINavigationController(rootViewController: HomeViewController())
        firstViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "homeTab"))
     
        let secondViewController = UINavigationController(rootViewController: SubCategoryViewController())
       
        secondViewController.tabBarItem = UITabBarItem(title: "Collections", image: UIImage(named: "categoryTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "categoryTab"))
        
        let thirdViewController = UINavigationController(rootViewController: CartViewController())
        
        thirdViewController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(named: "cartTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "cartTab"))
        
        let fourthViewController = UINavigationController(rootViewController: NotificationViewController())
        
        fourthViewController.tabBarItem = UITabBarItem(title: "Notification", image: UIImage(named: "NotificatonTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "NotificatonTab"))
        
        let tabBarList = [firstViewController, secondViewController,thirdViewController,fourthViewController]
        
        viewControllers = tabBarList
        tabBarController?.viewControllers = tabBarList.map { UINavigationController(rootViewController: $0)}
       tabBar.backgroundColor = UIColor(red: 3.0/255.0, green:66.0/255.0, blue: 81.0/255.0, alpha: 1.0)
    
        tabBar.barTintColor = UIColor(red: 3.0/255.0, green:66.0/255.0, blue: 81.0/255.0, alpha: 1.0)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
       self.methodToSetSideMenuButtonInNavigationBar(title: arrayMenuItems.object(at: 0) as! String)
        if let items = self.tabBar.items {
            
            //Get the height of the tab bar
            
            let height = self.tabBar.bounds.height
        
            //Calculate the size of the items
            
            let numItems = CGFloat(items.count)
            let itemSize = CGSize(
                width: tabBar.frame.width / numItems,
                height: tabBar.frame.height)
            
            for (index, _) in items.enumerated() {
                
                //We don't want a separator on the left of the first item.
                
                if index > 0 {
                    
                    //Xposition of the item
                    
                    let xPosition = itemSize.width * CGFloat(index)
                    
                    /* Create UI view at the Xposition,
                     with a width of 0.5 and height equal
                     to the tab bar height, and give the
                     view a background color
                     */
                    let separator = UIView(frame: CGRect(
                        x: xPosition, y: 0, width: 2.0, height: height))
                    separator.backgroundColor = UIColor.gray
                    tabBar.insertSubview(separator, at: 1)
                }
            }
        }
    
        

        CustomTabBarViewController.containerView = ContainerViewForMenu.init(frame:CGRect(x:10-screenWidth,y:-UIApplication.shared.statusBarFrame.size.height ,width:screenWidth,height:self.view.frame.size.height) )
        //UIApplication.shared.statusBarFrame.size.height
        CustomTabBarViewController.containerView.backgroundColor =  UIColor.clear
        self.objmenuTable = SideMenuTable (frame: CGRect(x: 0.0, y: 0.0, width: CustomTabBarViewController.containerView.frame.size.width-80,   height:  CustomTabBarViewController.containerView.frame.size.height ));
        self.objmenuTable.controller = self
      
        CustomTabBarViewController.viewToBeMoved = self.objmenuTable;
     
        CustomTabBarViewController.containerView.addSubview(CustomTabBarViewController.viewToBeMoved)
       self.view.addSubview(CustomTabBarViewController.containerView)
        self.MethodToSetGesture()
        firstX = 0
        firstY = 0
//
        
        //  setOfButtons = [homeButton,middleButton,searchButton]
        //self.addViewControllersToTabBar(middleViewController: OrderViewController())
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tabBar.itemSpacing = UIScreen.main.bounds.width / 3
    }
    //    override func viewDidLayoutSubviews() {
    //
    //        let Tbheight:CGFloat=49;
    //        var TbWidth:CGFloat = 80.0;f
    //        let Tempheight = self.view.frame.size.height - Tbheight;
    //        let mainScreenFraction = screenWidth/3;
    //        // let Tbspacing = mainScreenFraction - TbWidth;
    //        TbWidth = mainScreenFraction;
    //
    //
    //        backgroundView.frame =  CGRect(x: 0, y: Tempheight, width: screenWidth, height: Tbheight)
    // zz
    //
    //    }
    override func viewDidAppear(_ animated: Bool) {
        //        if justLoggedIn {
        //           // self.homeButtonAction(sender: nil)
        //            self.searchButtonAction(sender: nil)
        //           // justLoggedIn = false
        //        }
    }
    
    //#MARK: - TAB BAR SETUP
    func addViewControllersToTabBar(middleViewController :UIViewController)  {
        //   selectedvalue =  (arrayMenuItems.object(at: 0) as! String)
        let homeVC = HomeViewController()
        let navHome:UINavigationController = UINavigationController(rootViewController: homeVC)
        navHome.navigationBar.isHidden = true;
        //   selectedvalue   = arrayMenuItems.object(at: 6) as! String
        let searchVC:UIViewController = SubCategoryViewController()
        
        let navSearch:UINavigationController = UINavigationController(rootViewController: searchVC)
        navSearch.navigationBar.isHidden = true;
        
        self.setMiddleButtonImage(controller: middleViewController)
        self.selectedIndex = 1 ;
        let navMiddle = UINavigationController(rootViewController: middleViewController)
        // navMiddle.navigationBar.isHidden = true;
        self.viewControllers = [navHome,navMiddle,navSearch];
    }
    //#MARK:- setMiddleButtonImage
    func setMiddleButtonImage(controller:UIViewController){
        middleButton.setImage(#imageLiteral(resourceName: "DownloadTabImageSelected"), for: UIControl.State.normal)
        middleButton.setImage(#imageLiteral(resourceName: "DownloadTabImageSelected"), for: UIControl.State.selected)
//        if (controller is OrderViewController ){
//            middleButton.setImage(#imageLiteral(resourceName: "ordersTab"), for: UIControl.State.normal)
//            middleButton.setImage(#imageLiteral(resourceName: "ordersTab"), for: UIControl.State.selected)
//        }
//        else if (controller is ResourceGuideController)
//        {
//            middleButton.setImage(#imageLiteral(resourceName: "resourceGuideTab"), for: UIControl.State.normal)
//            middleButton.setImage(#imageLiteral(resourceName: "resourceGuideTab"), for: UIControl.State.selected)
//
//        }
//        else if(controller is PartSearchViewController){
//
//            middleButton.setImage(#imageLiteral(resourceName: "partSearchTab"), for: UIControl.State.normal)
//            middleButton.setImage(#imageLiteral(resourceName: "partSearchTab"), for: UIControl.State.selected)
//        }
//        else if(controller is ChangeAMViewController){
//            middleButton.setImage(#imageLiteral(resourceName: "user"), for: UIControl.State.normal)
//            middleButton.setImage(#imageLiteral(resourceName: "user"), for: UIControl.State.selected)
//        }
        //        else if(controller is )
    }
    // MARK:- addButtonsToTabBar
    func  addButtonsToTabBar(middleViewController :UIViewController)  {
        
        let Tbheight:CGFloat = 49;
        var TbWidth:CGFloat = 80.0;
        let Tempheight = screenheight - Tbheight;
        let mainScreenFraction = screenWidth/3;
        // let Tbspacing = mainScreenFraction - TbWidth;
        TbWidth = mainScreenFraction;
        backgroundView = UIView(frame: CGRect(x: 0, y: Tempheight, width: screenWidth, height: Tbheight))
        
        homeButton = UIButton(type: UIButton.ButtonType.custom)
        middleButton = UIButton(type: UIButton.ButtonType.custom)
        searchButton = UIButton(type: UIButton.ButtonType.custom)
        
        middleButton.setImage(#imageLiteral(resourceName: "DownloadTabImageSelected"), for: UIControl.State.normal)
        middleButton.setImage(#imageLiteral(resourceName: "DownloadTabImageSelected"), for: UIControl.State.selected)
        
        homeButton.setImage(#imageLiteral(resourceName: "HomeTabImageSelected"), for: UIControl.State.normal)
        homeButton.setImage(#imageLiteral(resourceName: "HomeTabImageSelected"), for: UIControl.State.selected)
        
        searchButton.setImage(#imageLiteral(resourceName: "NotificationImageSelected"), for: UIControl.State.normal)
        searchButton.setImage(#imageLiteral(resourceName: "NotificationImageSelected"), for: UIControl.State.selected)
        
        homeButton.addTarget(self, action: #selector(homeButtonAction), for: .touchUpInside)
        
        middleButton.addTarget(self, action: #selector(middleButtonAction), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        
        homeButton.frame =  CGRect(x: 0, y: 0, width: TbWidth, height: Tbheight)
        middleButton.frame = CGRect(x: homeButton.frame.origin.x+homeButton.frame.size.width, y: 0, width: TbWidth, height: Tbheight)
        
        searchButton.frame = CGRect(x: middleButton.frame.origin.x+middleButton.frame.size.width, y: 0, width: TbWidth, height: Tbheight)
        
        backgroundView.addSubview(homeButton)
        backgroundView.addSubview(middleButton)
        backgroundView.addSubview(searchButton)
        homeButton.isHidden = true
        middleButton.isHidden = true
        searchButton.isHidden = true
        self.view.addSubview(backgroundView)
        self.view.bringSubviewToFront(backgroundView)
        self.backgroundView.isHidden = true
        
    }
    //#MARK: - TAB BAR BUTTON ACTIONS
    func redirectToNotificationScreen() -> Bool{
        let   selectedIndex = 8
        Utility.setNotificationReceivedStatus(status: false)
        selectedvalue =  sideMenuDataSection.object(at:selectedIndex
            ) as! String
        //self.addViewControllersToTabBar(middleViewController: notificationViewController())
    return true
    }
    
    
    
    
//    func homeButtonActionWithNotificationCheck()
//    
//    
//        {
//            self.selectedIndex = 0 ;
//
//Utility.showNotificationScreen()
//            
//        }
//    
    
    
    
    
    
    
    
    @objc func homeButtonAction(sender:UIButton? ){
        //    self.unselectAllOtherButtons(button: sender)
        //            homeButton.isSelected = true;
        //            middleButton.isSelected = false
        //            searchButton.isSelected = false
        //        let nav = UINavigationController(rootViewController: HomeViewController())
        //        self.present(nav, animated: false, completion:{} )
        self.selectedIndex = 0 ;
    }
    // MARK:- middleButtonAction
    @objc func middleButtonAction(sender:UIButton){
        //            homeButton.isSelected = false;
        //            middleButton.isSelected = true
        //            searchButton.isSelected = false
        
        self.selectedIndex = 1 ;
        //      self.unselectAllOtherButtons(button: sender)
        
    }
//    // MARK:- searchButtonAction
//    @objc func searchButtonAction(sender:UIButton?){
//        
//        // homeButton.isSelected = false;
//        // middleButton.isSelected = false
//        // searchButton.isSelected = true
//        //self.unselectAllOtherButtons(button: sender)
//        let searchControllerNav:UINavigationController? = self.viewControllers?[2] as? UINavigationController
//     //   let searchController:notificationViewController? = searchControllerNav?.viewControllers[0] as? notificationViewController
//      //  searchController?.refresh()
//        self.selectedIndex = 2 ;
//        
//        
//        //        let nav = UINavigationController(rootViewController: SearchCustomerViewController())
//        //        self.present(nav, animated: false, completion: {})
//    }
    //    func unselectAllOtherButtons(button :UIButton){
    //
    //        for  buttonElement in setOfButtons {
    //            if buttonElement as! UIButton == button {
    //                (buttonElement as! UIButton).isSelected = true;
    //
    //            }
    //
    //            else{
    //
    //                (buttonElement as! UIButton).isSelected = false;
    //
    //
    //            }
    //
    //        }
    
    
    //   }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
