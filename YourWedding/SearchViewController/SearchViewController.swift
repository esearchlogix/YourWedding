//
//  SearchViewController.swift
//  YourWedding
//
//  Created by Alekh Verma on 23/11/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import SMFloatingLabelTextField

class SearchViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet var textFieldSearch :  SMFloatingLabelTextField?
    @IBOutlet var superViewTextField : UIView?
    var arraySearch : NSArray?
    var tableViewSearch :  UITableView? = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
   
         arraySearch =  arrayAllProducts
        if arraySearch?.count ?? 0 > 0 {
            maketableView(textField: textFieldSearch!)
        }else{
            tableViewSearch?.removeFromSuperview()
            tableViewSearch = UITableView()
        }
        textFieldSearch?.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
         self.navigationController?.navigationBar.isHidden = false
    }

    // MARK: - textfieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        arraySearch =  arrayAllProducts
      
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        arraySearch = arrayAllProducts
        tableViewSearch?.removeFromSuperview()
        tableViewSearch = UITableView()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textFieldSearch?.clearButtonMode = .whileEditing
        textFieldSearch?.autocorrectionType = .no
        textFieldSearch?.autocapitalizationType = .none
        
        //        doSearching = true
        
        let newString:NSString? =   (textField.text as NSString?)?.replacingCharacters(in:range , with: string) as NSString?
        
        let trimstring = newString?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        let namepredicate:NSPredicate = NSPredicate(format: "(title BEGINSWITH[c] %@) OR (title CONTAINS[c] %@)", trimstring ?? "" , " \(trimstring ?? "")")
        
        let resultArray = arrayAllProducts?.filtered(using: namepredicate)
        
        self.arraySearch = resultArray as NSArray?
        if arraySearch?.count ?? 0 > 0 {
            maketableView(textField: textField)
        }else{
            tableViewSearch?.removeFromSuperview()
            tableViewSearch = UITableView()
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        arraySearch = arrayAllProducts
        tableViewSearch?.removeFromSuperview()
        arraySearch = nil
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        textFieldSearch?.text = ""
        arraySearch = arrayAllProducts
        tableViewSearch?.removeFromSuperview()
        arraySearch = nil
        return true
    }
    
    // MARK: - Make tableView
    
    func maketableView(textField : UITextField){
        
        
        tableViewSearch?.frame = CGRect(x: (textFieldSearch?.frame.origin.x)!, y: 100, width: (textFieldSearch?.frame.size.width)!, height: (tableViewSearch?.contentSize.height)!)
        tableViewSearch?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableViewSearch?.tag = 1
        tableViewSearch?.dataSource = self
        tableViewSearch?.delegate = self
        
        self.view.addSubview(tableViewSearch!)
        
        
    }
    @IBAction  func buttonBackAction(sender : UIButton){
        let navigationController = UINavigationController(rootViewController:  CustomTabBarViewController())
        UIApplication.shared.delegate?.window??.rootViewController  = navigationController    }
    
    // MARK: - tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return (arraySearch?.count) ?? 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewSearch?.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell?.textLabel?.text = (arraySearch?.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "title") as? String
        cell?.textLabel?.lineBreakMode = .byWordWrapping
        cell?.textLabel?.numberOfLines = 0;
        cell?.textLabel?.font = UIFont.init(name: appFont, size: 12.0)
        return cell!
        
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
                let destinationViewController = ProductDetailViewController(nibName: "ProductDetailViewController", bundle: nil)
                    destinationViewController.productDetailDict = arraySearch?.object(at: indexPath.row) as? NSDictionary
                Utility.pushToViewController(callingViewController: self, moveToViewController: destinationViewController)
        
    }
    override func viewDidLayoutSubviews() {
        tableViewSearch?.frame = CGRect(x: 10, y: 100 , width: (textFieldSearch?.frame.size.width) ?? 350, height: (tableViewSearch?.contentSize.height) ?? 550)
        tableViewSearch?.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        textFieldSearch?.text = ""
        textFieldSearch?.resignFirstResponder()
        arraySearch = arrayAllProducts
        tableViewSearch?.removeFromSuperview()
        tableViewSearch = UITableView()
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
