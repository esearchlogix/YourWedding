//
//  AppDelegate.swift
//  YourWedding
//
//  Created by Alekh Verma on 16/11/18.
//  Copyright © 2018 Alekh Verma. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging



var arrayAllProducts : NSMutableArray? = []
var shopArray : NSDictionary? = [:]
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,ServerCallback,UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var allProductCount : Int? = 0
    var productCount : Int? = 0
    var requestHitCount : Int? = 1

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //  Code for firebase
        UIApplication.shared.applicationIconBadgeNumber = 0

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in})
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                           categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        let mainViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)

        let ObjServer = Server()
        ObjServer.delegate = self
        ObjServer.hitGetRequest(url: fetchShopDetail, inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:mainViewController, completion: {_,_,_ in })
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController:  CustomTabBarViewController())

        UIApplication.shared.delegate?.window??.rootViewController  = navigationController
        
       
        // Override point for customization after application launch.
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print("ios9 recieve.......\(userInfo)")
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging()
            .setAPNSToken(deviceToken, type: MessagingAPNSTokenType.unknown)
    }
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print("app data....\(remoteMessage.appData)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        let aps = userInfo[AnyHashable("aps")] as? NSDictionary
        
        let alert = aps?["alert"] as? NSDictionary
        let date = userInfo[AnyHashable("date")] as? String
        let id = userInfo[AnyHashable("gcm.message_id")] as? String
        
        let body = alert?["body"] as? String
        let title = alert?["title"] as? String
        
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let defaultDate = formatter.string(from: todayDate)
        print( "aps.....\(userInfo[AnyHashable("aps")] as? NSDictionary ?? [:])")
        print("date....\(date ?? "")")
        
        print("Title: \(title ?? "") \nBody:\(body ?? "")")
        print("alert: \(alert ?? [:])")
        // Print full message.
        print( "userinfo1.....\(userInfo)")
        
        let entity = NSEntityDescription.entity(forEntityName: "NotificationData", in: context)
        let newNotification = NSManagedObject(entity: entity!, insertInto: context)
        
        newNotification.setValue(date ?? defaultDate, forKey: "date")
        newNotification.setValue(body ?? "", forKey: "body")
        newNotification.setValue(title ?? "No Subject", forKey: "title")
        newNotification.setValue(id ?? "No Subject", forKey: "id")
        
        do {
            try context.save()
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationData")
            request.returnsObjectsAsFaults = false
            do {
                
                let result = try context.fetch(request)
            }catch{
                print("failed")
            }
        } catch {
            print("Failed saving")
        }
        
        
        completionHandler([.alert, .badge, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        let aps = userInfo[AnyHashable("aps")] as? NSDictionary
        
        let alert = aps?["alert"] as? NSDictionary
        let date = userInfo[AnyHashable("date")] as? String
        let id = userInfo[AnyHashable("gcm.message_id")] as? String
        let body = alert?["body"] as? String
        let title = alert?["title"] as? String
        
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let defaultDate = formatter.string(from: todayDate)
        print( "aps.....\(userInfo[AnyHashable("aps")] as? NSDictionary ?? [:])")
        print("date....\(date ?? "")")
        
        print("Title: \(title ?? "") \nBody:\(body ?? "")")
        print("alert: \(alert ?? [:])")
        // Print full message.
        print( "userinfo1.....\(userInfo)")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationData")
        let result = try? context.fetch(fetchRequest)
        let resultData = result as! [NSManagedObject]
        var index = 0
        var find = false
        for item in resultData{
            if item.value(forKey: "id") as? String == id{
                
                find = true
            }
            index = index + 1
        }
        if find == true{
            
            
        }else{
            let entity = NSEntityDescription.entity(forEntityName: "NotificationData", in: context)
            let newNotification = NSManagedObject(entity: entity!, insertInto: context)
            
            newNotification.setValue(date ?? defaultDate, forKey: "date")
            newNotification.setValue(body ?? "", forKey: "body")
            newNotification.setValue(title ?? "No Subject", forKey: "title")
            newNotification.setValue(id ?? "No Subject", forKey: "id")
            do {
                try context.save()
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationData")
                request.returnsObjectsAsFaults = false
                do {
                    
                    let result = try context.fetch(request)
                }catch{
                    print("failed")
                }
            } catch {
                print("Failed saving")
            }
        }
        // Print full message.
        print( "userinfo.....\(userInfo)")
        
        completionHandler()
    }

    func didReceiveResponse(dataDic: NSDictionary?, response:URLResponse?) {
        if let val = dataDic!["shop"]{
            shopArray = dataDic?.object(forKey: "shop") as? NSDictionary
            
            let ObjServer = Server()
            ObjServer.delegate = self
            ObjServer.hitGetRequest(url: allproductCountUrl, inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:nil, completion: {_,_,_ in })
        }else{
            if let val = dataDic!["count"] {
                allProductCount = val as? Int
                productCount = allProductCount
                arrayAllProducts = []
                requestHitCount = 0
                let ObjServer = Server()
                ObjServer.delegate = self
                ObjServer.hitGetRequest(url: allproductUrl + "\(requestHitCount ?? 0)", inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:nil, completion: {_,_,_ in })
            } else {
                
                if productCount! > 0{
                    productCount = productCount! - 250
                    requestHitCount = requestHitCount! + 1
                    let ObjServer = Server()
                    ObjServer.delegate = self
                    ObjServer.hitGetRequest(url: allproductUrl + "\(requestHitCount ?? 0)", inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:nil, completion: {_,_,_ in })
                }else{
                    requestHitCount = 1
                }
                let productArray : [Any] = dataDic?.object(forKey: "products") as! [Any]
                arrayAllProducts?.addObjects(from: productArray)
                if arrayAllProducts?.count ==  allProductCount{
                    print(arrayAllProducts)
                }
            }
        }
    }
    
    func didFailWithError(error: String) {
        let mainViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        ModalViewController.showAlert(alertTitle: kAppName, andMessage: error, withController:mainViewController )
        //            let ObjServer = Server()
        //            ObjServer.delegate = self
        //            ObjServer.hitGetRequest(url: allproductUrl + "\(self.requestHitCount ?? 0)", inputIsJson: false, parametresJsonDic:nil, parametresJsonArray: nil,callingViewController:nil, completion: {_,_,_ in })
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DataModal")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }} else {
            // Fallback on earlier versions
        }
    }
    func cleardata(){
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        if #available(iOS 10.0, *) {
            
            do {
                
                if let result = try? context.fetch(deleteFetch) {
                    for object in result {
                        context.delete(object as! NSManagedObject)
                    }
                }
                
                try context.save()
            }
            catch {
                print ("There was an error")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate
@available(iOS 10.0, *)
let context = appDelegate.persistentContainer.viewContext

