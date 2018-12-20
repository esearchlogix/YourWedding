//
//  UIViewController+Sidemenu.swift
//  VistarApp
//
//  Created by thinksysuser on 06/12/16.
//  Copyright © 2016 thinksysuser. All rights reserved.
//

import UIKit

//var containerView:UIView!
//var viewToBeMoved:UIView!
var isPress:Bool = false
var menuButton = UIButton()
var firstX:Float!
var firstY:Float!
var selectedvalue:String = ""
//var objmenuTable = SideMenuTable()


extension UIViewController{
    
    // #MARK: methodToSetButtonInNavigationBar
    
    
    func addInfoButtonAndMenuButton(title:String){
        
        let homeButton = UIButton()
        homeButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        homeButton.frame = CGRect(x:0,y:0,width:47,height:47)
        homeButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        let navigateSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        navigateSpacer.width = -16
        
        
        let leftBarButton = UIBarButtonItem()
        // leftBarButton.style = .plain
        leftBarButton.customView = homeButton
        
   
        let titleLabel = UILabel()
        
        titleLabel.textAlignment = .left
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: appFontBold, size: 19.0)
      //  self.navigationItem.titleView = titleLabel
        let maximumSizeLinkedUnlinked = CGSize(width: CGFloat(0.0), height: CGFloat(9999))
        let linkedUnlinkedText = titleLabel.text ?? ""
        let labelSizeLinkedUnlinked = linkedUnlinkedText.boundingRect(with: maximumSizeLinkedUnlinked, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: titleLabel.font], context: nil).size
         titleLabel.frame =  CGRect(x: homeButton.frame.maxX, y: 40.0, width: labelSizeLinkedUnlinked.width, height: 40)
        let leftBartitle = UIBarButtonItem()
        // leftBarButton.style = .plain
        leftBartitle.customView = titleLabel
        
                let infoButton = UIButton()
                infoButton.setImage(#imageLiteral(resourceName: "InfoIcon"), for: .normal)
                infoButton.frame = CGRect(x:titleLabel.frame.maxX,y:0,width:47,height:47)
                infoButton.addTarget(self, action: #selector(infoButtonAction(sender:)), for: .touchUpInside)
        let infoBarItem = UIBarButtonItem()
        // leftBarButton.style = .plain
        infoBarItem.customView = infoButton
        
        
//                let navigateSpacerInfo = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//                navigateSpacerInfo.width = -116
        
        
        
        
        
        
        
             self.navigationItem.setLeftBarButtonItems([navigateSpacer,leftBarButton,leftBartitle,infoBarItem], animated: false)
        
        
        
        
        
//        let infoButton = UIButton()
//        infoButton.setImage(#imageLiteral(resourceName: "InfoIcon"), for: .normal)
//        infoButton.frame = CGRect(x:0,y:0,width:47,height:47)
//        infoButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
//        let navigateSpacerInfo = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        navigateSpacerInfo.width = -116
//        
//        
//        let rightBarButtonInfo = UIBarButtonItem()
//        // leftBarButton.style = .plain
//        rightBarButtonInfo.customView = infoButton
//        
//        self.navigationItem.setRightBarButtonItems([navigateSpacerInfo,rightBarButtonInfo], animated: false)
//        let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 40.0, width: 320, height: 40))
//        titleLabel.textAlignment = .left
//        titleLabel.text = title
//        titleLabel.textColor = .white
//        titleLabel.font = UIFont(name: appFontBold, size: 19.0)
       // self.navigationItem.titleView = titleLabel
    
    
    }
    
    //#MARK:- methodToSetSideMenuButtonInNavigationBarWithPopBack
    func methodToSetSideMenuButtonInNavigationBarWithPopBack(badgeNumber : Int){
        
        
        let backButton = UIButton()
        //   backButton.backgroundColor = .blue
        
        backButton.setImage(#imageLiteral(resourceName: "BackIcon"), for: .normal)
        backButton.frame = CGRect(x:2.0,y:0,width:40,height:30)
        backButton.addTarget(self, action: #selector(backButtonActionPop(sender:)), for: .touchUpInside)
        
        let containerView = UIView(frame: CGRect(x: 3.0, y: 0.0, width: 85, height: 47))
        containerView.addSubview(backButton)
        backButton.center.y = containerView.center.y
       
        let navigateSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        navigateSpacer.width = -16
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = containerView
        
        self.navigationItem.setLeftBarButtonItems([navigateSpacer,leftBarButton], animated: false)
        
        let titleImage = UIImageView(frame: CGRect(x: 13.0, y: 40.0, width: 200, height: 40))
        titleImage.image = #imageLiteral(resourceName: "logoImage")
        self.navigationItem.titleView = titleImage
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        titleImage.isUserInteractionEnabled = true
//        titleImage.addGestureRecognizer(tapGestureRecognizer)
//        
        
       // self.MethodToSetGesture()
    
        
//        let rightBarButton1 = UIBarButtonItem()
//        rightBarButton1.customView = buttonCart
//        rightBarButton1.addBadge(number: badgeNumber)
//        
//        self.navigationItem.setRightBarButtonItems([rightBarButton1,navigateSpacer,rightBarButton], animated: false)
        
        
    }
    func methodToSetSideMenuButtonInNavigationBar(title :String){
        
        let homeButton = UIButton()
        homeButton.setImage(#imageLiteral(resourceName: "HomeTabImageSelected"), for: .normal)
        homeButton.frame = CGRect(x:0,y:0,width:47,height:47)
        homeButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        let navigateSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        navigateSpacer.width = -16
        
        
        let leftBarButton = UIBarButtonItem()
        // leftBarButton.style = .plain
        leftBarButton.customView = homeButton
        self.navigationItem.leftBarButtonItem = leftBarButton
    //    self.navigationItem.setLeftBarButtonItems([navigateSpacer,leftBarButton], animated: false)
        
        let titleImage = UIImageView(frame: CGRect(x: 0.0, y: 10.0, width: 150, height: 40))
        titleImage.image = #imageLiteral(resourceName: "logoImage")
        
        self.navigationItem.titleView = titleImage
        //self.MethodToSetGesture()
        
        
        let buttonLogout = UIButton()
        buttonLogout.setImage(#imageLiteral(resourceName: "searchIcon"), for: .normal)
        buttonLogout.frame = CGRect(x:0,y:0,width:30,height:30)
        buttonLogout.addTarget(self, action: #selector(searchButtonAction(sender:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = buttonLogout
        self.navigationItem.rightBarButtonItem = rightBarButton
        let navigationBar = self.navigationController?.navigationBar
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
    }
    func methodToSetNavigationBarWithoutLogoImage(title :String , badgeNumber : Int){
        
        
        let homeButton = UIButton()
        homeButton.setImage(#imageLiteral(resourceName: "homeWithoutTab"), for: .normal)
        homeButton.frame = CGRect(x:0,y:0,width:47,height:47)
        homeButton.addTarget(self, action: #selector(homeNavigationButtonAction(sender:)), for: .touchUpInside)
        let navigateSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        navigateSpacer.width = -16
        
        
        let leftBarButton = UIBarButtonItem()
        // leftBarButton.style = .plain
        leftBarButton.customView = homeButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        //    self.navigationItem.setLeftBarButtonItems([navigateSpacer,leftBarButton], animated: false)
        
        let titleImage = UIImageView(frame: CGRect(x: 0.0, y: 10.0, width: 150, height: 40))
        titleImage.image = #imageLiteral(resourceName: "logoImage")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        titleImage.isUserInteractionEnabled = true
        titleImage.addGestureRecognizer(tapGestureRecognizer)
        
        self.navigationItem.titleView = titleImage
        
        
    }
    
    //#MARK:- methodToSetSideMenuButtonInNavigationBarWithPopBack
 
    //#MARK:- methodToSetSideMenuButtonInNavigationBarWithPopBack
    func methodToSetSideMenuButtonInNavigationBarWithPopBack(title :String){
        
        
        let backButton = UIButton()
        //   backButton.backgroundColor = .blue
        
        backButton.setImage(#imageLiteral(resourceName: "BackIcon"), for: .normal)
        backButton.frame = CGRect(x:2.0,y:0,width:40,height:30)
        backButton.addTarget(self, action: #selector(backButtonActionPop(sender:)), for: .touchUpInside)
        
        let containerView = UIView(frame: CGRect(x: 3.0, y: 0.0, width: 85, height: 47))
        containerView.addSubview(backButton)

        let navigateSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        navigateSpacer.width = -16


        let leftBarButton = UIBarButtonItem()
        // leftBarButton.style = .plain
        leftBarButton.customView = containerView
      
        self.navigationItem.setLeftBarButtonItems([navigateSpacer,leftBarButton], animated: false)
        
        let titleImage = UIImageView(frame: CGRect(x: 0.0, y: 10.0, width: 150, height: 40))
        titleImage.image = #imageLiteral(resourceName: "logoImage")
        
        self.navigationItem.titleView = titleImage
        
    }
    //#MARK:- LogoImageAction
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let navigationController = UINavigationController(rootViewController:  CustomTabBarViewController())
        
        UIApplication.shared.delegate?.window??.rootViewController  = navigationController
    }
    
    func methodToSetBottamNavigationBar(title :String){
        
        //        let navigationBottamView = UIView()
        
        
        let labelTitle = UILabel()
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            labelTitle.frame = CGRect(x:0,y:UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0),width:screenWidth,height:60)
        }else{
            labelTitle.frame = CGRect(x:0,y:64,width:screenWidth,height:60)
        }
        labelTitle.backgroundColor = UIColor(red: 3.0/255.0, green:66.0/255.0, blue: 81.0/255.0, alpha: 1.0)
        labelTitle.font = UIFont(name: labelTitle.font.fontName, size: 16)
        labelTitle.font = UIFont.boldSystemFont(ofSize: 16.0)
        labelTitle.textColor = UIColor.white
        labelTitle.text = title
        labelTitle.textAlignment = .center
        
      
        
        self.view.addSubview(labelTitle)
        
        
    }

    
    //#MARK:- methodToSetMenu
    
    func methodToSetMenu(){
        
        menuButton  = UIButton.init(frame: CGRect(x:0,y:64,width:47,height:47))
        menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        menuButton.imageView?.contentMode = .scaleAspectFill
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        
        labelHeading  = UILabel.init(frame: CGRect(x:menuButton.frame.maxX + 13,y:64,width:screenWidth,height:50))
        
        labelHeading?.text = selectedvalue
        labelHeading?.textColor = UIColor.gray
        labelHeading?.font = UIFont.boldSystemFont(ofSize: 16)
        self.view.addSubview(labelHeading!)
        self.view.addSubview(menuButton)
        self.view.bringSubviewToFront(menuButton)
        

        
    }
    
    //#MARK:- infoButtonAction
    @objc public func infoButtonAction(sender:UIButton)
    {
    
    
    
    
    }
    
    //#MARK:- searchButtonAction
    
    @objc func searchButtonAction(sender:UIButton?){
        
        let destinationViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
       
        navigationController?.pushViewController(destinationViewController, animated: true)
        
        //   self.view.endEditing(true)
        
    }
    
    //#MARK:- menuButtonAction
    
    @objc func menuButtonAction(sender:UIButton?){
        
        let tabController:CustomTabBarViewController? = self.navigationController?.viewControllers.first as? CustomTabBarViewController
        tabController?.menuAction(sender: sender)
        
     //   self.view.endEditing(true)
        
    }
    @objc func homeNavigationButtonAction(sender:UIButton?){
        let navigationController = UINavigationController(rootViewController:  CustomTabBarViewController())
        UIApplication.shared.delegate?.window??.rootViewController  = navigationController
    
        
        //   self.view.endEditing(true)
        
    }
    


}

