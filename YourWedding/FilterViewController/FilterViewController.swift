//
//  FilterViewController.swift
//  Ribbons
//
//  Created by Alekh Verma on 10/07/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import CoreData
 var selectedIndexPaths : NSMutableArray? = []
var productArray : NSMutableArray? = []
var arraySelectedIndexPath : NSMutableArray? = []


class FilterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,FilterTableViewdelegate {
    
    

    @IBOutlet var tableViewFilter : UITableView?
 
    var viewTitle : String?

    var colorFilter : NSMutableArray?
    var sizeFilter : NSMutableArray?
     var shapeFilter : NSMutableArray?
    var dictAllProductForColour : [String : NSMutableArray?]?
     var dictAllProductForSize : [String : NSMutableArray?]?
     var dictAllProductForShape : [String : NSMutableArray?]?
    var allProductArray : NSMutableArray? = []

    var selectIndexPath : IndexPath!
    
    
    var sections : [FilterSection]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            self.methodToSetSideMenuButtonInNavigationBarWithPopBack(title: "Filters")
        }catch{
            print("failed")
        }
        self.methodToSetBottamNavigationBar(title: "FILTERS" ?? kAppName)
        //self.methodNavigationBarBackGroundColor()
        
        sections = [
            FilterSection(category: "SIZE", subCategory: sizeFilter as! [String], expended: true),
            FilterSection(category: "COLOR", subCategory: colorFilter as! [String], expended: true),
            FilterSection(category: "SHAPE", subCategory: shapeFilter as! [String], expended: true)
        ]
        
        selectIndexPath = IndexPath(row: -1, section: -1)
        let nib = UINib(nibName: "FilterSectionHeader", bundle: nil)
        tableViewFilter?.register(nib, forHeaderFooterViewReuseIdentifier: "filterSectionHeader")
        tableViewFilter?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sections![section].subCategory?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections![indexPath.section].expended)!{
            return 44
        }else{
            return 0
            
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableViewFilter?.dequeueReusableHeaderFooterView(withIdentifier: "filterSectionHeader") as? FilterTableView
        
        //        var header : ExpendableTableView?
        
        header?.customInit(title: sections![section].category!, section: section, delegate: self)
        Utility.giveShadowEffectToView(view: header!)
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        view.backgroundColor = UIColor.white
        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewFilter?.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = sections![indexPath.section].subCategory?[indexPath.row]
        if (selectedIndexPaths?.count)! > 0{
            if (selectedIndexPaths?.contains(indexPath))!
            {
                cell?.accessoryType = .checkmark
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableViewFilter?.cellForRow(at: indexPath) {
            if (selectedIndexPaths?.contains(indexPath))!
            {
                cell.accessoryType = .none
                let index = selectedIndexPaths?.index(of: indexPath)
                var startingIndex = 0
                if let indexValue = index {
                for i in 0..<indexValue{
                    startingIndex = startingIndex + (arraySelectedIndexPath?.object(at: i) as? Int)!
                }
                }
                if startingIndex == 0{
                    let endIndex =  (arraySelectedIndexPath?.object(at: index!) as? Int)!
                    let range : NSRange = NSRange(location: startingIndex, length: endIndex)
                    productArray?.removeObjects(in: range)
                }else{
                    startingIndex = startingIndex + 1
                    let endIndex =  (arraySelectedIndexPath?.object(at: index!) as? Int)!
                    let range : NSRange = NSRange(location: startingIndex, length: endIndex)
                    productArray?.removeObjects(in: range)
                }
                arraySelectedIndexPath?.removeObject(at: index!)
                selectedIndexPaths?.remove(indexPath)
                
            }
            else
            {
                cell.accessoryType = .checkmark
                selectedIndexPaths?.add(indexPath)
                if indexPath.section == 1{
                    let arrayProducts = dictAllProductForColour![(sections![indexPath.section].subCategory?[indexPath.row])!]
                    arraySelectedIndexPath?.add(arrayProducts??.count ?? 0)
                    productArray?.addObjects(from: arrayProducts as! [Any])
                }
                else if indexPath.section == 0{
                    let arrayProducts = dictAllProductForSize![(sections![indexPath.section].subCategory?[indexPath.row])!]
                    arraySelectedIndexPath?.add(arrayProducts??.count ?? 0)
                    productArray?.addObjects(from: arrayProducts as! [Any])
                }else{
                    let arrayProducts = dictAllProductForShape![(sections![indexPath.section].subCategory?[indexPath.row])!]
                    arraySelectedIndexPath?.add(arrayProducts??.count ?? 0)
                    productArray?.addObjects(from: arrayProducts as! [Any])
                }
            }
            // anything else you wanna do every time a cell is tapped
        }
        
        
    }
    func toggleSection(header: FilterTableView, section: Int) {
        
        sections![section].expended = !sections![section].expended!
        
        tableViewFilter?.beginUpdates()
        tableViewFilter?.reloadSections([section], with: .automatic)
        tableViewFilter?.endUpdates()
        
    }
    // MARK: - button Action
    
    // button Action for social promotion
    
    @IBAction func applyButtonAction(sender: UIButton){
        let destinationViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
        if (productArray?.count)! > 0{
        destinationViewController.productsArray = productArray
             destinationViewController.isFilter = true
        }else{
         destinationViewController.productsArray = allArray
             destinationViewController.isFilter = false
        }
        destinationViewController.isRequest = false
       destinationViewController.arraySize = sizeFilter
        destinationViewController.dictAllColourFilter = dictAllProductForColour ?? [:]
        destinationViewController.dictAllSizeFilter = dictAllProductForSize ?? [:]
        destinationViewController.dictAllShapeFilter = dictAllProductForShape ?? [:]

        destinationViewController.arrayColour = colorFilter!
        destinationViewController.arrayShape =  shapeFilter!
        destinationViewController.viewTitle = viewTitle

        destinationViewController.isFilter = true
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
