//
//  AppDelegate.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 18/12/2017.
//  Copyright © 2017 Martin SCAGLIA. All rights reserved.
//

import UIKit
import UserNotifications
import Fabric
import Answers
import Crashlytics
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        VotesFunctions().refreshVotesData()
        
        UpdateIndicators().refreshIndicatorsData()
        
        MainViewController().setLocaleCurrency()
        MainViewController().updateWalletValue()
       
        for crypto in MainViewController.cryptoDic {
            CryptoDataCall().dataUpdate(crypto, crypto)
        }
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(30)
        
        Fabric.with([Crashlytics.self])
        Fabric.with([Answers.self])
       
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge], completionHandler: {didAllow, error in
            
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        })
        
        return true

    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
  
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //MainViewController().setAnimatedBadgesOpacityToZero()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
       //MainViewController().setAnimatedBadgesOpacityToZero()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("*** REMOTE NOTIFICATION RECEIVED ***")
        
        UpdateIndicators().updateIndicators()

        
        completionHandler(.newData)
        //completionHandler(UIBackgroundFetchResult.noData)
        
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        UpdateIndicators().updateIndicators()
        
        completionHandler(.newData)
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CryptoGODM")
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
        }
    }
}

