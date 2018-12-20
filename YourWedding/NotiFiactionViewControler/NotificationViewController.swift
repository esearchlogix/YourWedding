//
//  NotificationViewController.swift
//  Ribbons
//
//  Created by Alekh Verma on 03/07/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

class NotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var imageview : UIImageView?
    @IBOutlet var tableviewNotification : UITableView?
    @IBOutlet var notificationView : UIView?
    var notificationArray : [Any]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationData")
       
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
        }catch{
            print("failed")
        }
        self.navigationController?.navigationBar.isHidden = true

        tableviewNotification?.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        
        fetchCartItems()
        // Do any additional setup after loading the view.
    }
    func fetchCartItems(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationData")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            if result.count == 0{
                notificationView?.isHidden = false
                tableviewNotification?.isHidden = true
                
                
            }else{
                notificationView?.isHidden = true
                tableviewNotification?.isHidden = false
                notificationArray = result
                
               
                tableviewNotification?.reloadData()
               
            }
            
        } catch {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            print("Failed")
        }
        
    }
    // MARK: - tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return (notificationArray?.count) ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableviewNotification?.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        let data = notificationArray![(notificationArray?.count ?? 0) - indexPath.section - 1] as? NSManagedObject
        
        cell.lablelBody?.text = data?.value(forKey: "body") as? String //
        cell.lablelDate?.text = "\(data?.value(forKey: "date") as? String ?? "12/10/2018")"
        cell.lablelTitle?.text = "\(data?.value(forKey: "title") as? String ?? "")"
       
        
        
       
       // Utility.giveShadowEffectToView(view: cell.contentView)
        cell.contentView.layer.cornerRadius = 10
        cell.selectionStyle = .none
        return cell
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = UIColor.clear
        }
    }
    
//        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//            var headerView : UIView?
//            headerView?.backgroundColor = UIColor.black
//            return headerView
//        }
//
//        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//            return 10
//        }


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
