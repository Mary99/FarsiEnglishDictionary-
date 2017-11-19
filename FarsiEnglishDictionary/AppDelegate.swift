//
//  AppDelegate.swift
//  FarsiEnglishDictionary
//
//  Created by Maryam Rajaei on 2017-10-31.
//  Copyright © 2017 veddes. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //where my files are saved
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        
        let defaults = UserDefaults.standard
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        if !isPreloaded {
            preLoadData()
            defaults.set(true, forKey: "isPreloaded")
        }

        //navigation bar settings
        navBarDesign()
        
        return true
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
        // Saves changes in the application's managed object context before the application terminates.
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
        let container = NSPersistentContainer(name: "FarsiEnglishDictionary")
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
  
//************************************************************************************************
    //MARK: - PreloadData()
    //add data to ListMO entity
    func  preLoadData() {
    
    
       let myContext = persistentContainer.viewContext
        
       //Greeting list and 2 words
       let myListing1 = ListMO (context:myContext)
       myListing1.listingName = "greeting"

       let myWordRef1 = MyWordRefMO (context:myContext)
       myWordRef1.english = "Hello"
       myWordRef1.farsi  = "Hi"
       myWordRef1.itemNumber = 1
       myWordRef1.toListFromDic = myListing1

        
        let myWordRef2 = MyWordRefMO (context:myContext)
        myWordRef2.english = "how are you?"
        myWordRef2.farsi  = "fine thanks"
        myWordRef2.itemNumber = 2
        myWordRef2.toListFromDic =  myListing1

        //Romance list and 2 words
        let myListing2 = ListMO (context:myContext)
        myListing2.listingName = "romance"

        let myWordRef4 = MyWordRefMO (context:myContext)
        myWordRef4.english = "Do you marry me?"
        myWordRef4.farsi  = "No!"
        myWordRef4.itemNumber = 2
        myWordRef4.toListFromDic =  myListing2
        
        let myWordRef3 = MyWordRefMO (context:myContext)
        myWordRef3.english = "I love you!"
        myWordRef3.farsi  = "I do too!"
        myWordRef3.itemNumber = 1
        myWordRef3.toListFromDic =  myListing2

       saveContext()

  }
    
    //MARK: - Nav Bar Design
    func navBarDesign(){
        //change background color of navigation bar to orange
        UINavigationBar.appearance().barTintColor = UIColor(red: 216.0/255.0, green: 74.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        
        //change color of nav text (all but not the first one)
        UINavigationBar.appearance().tintColor = UIColor.white

        //title style and color and font of nav bar (first one but not next nav bar)
        if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:barFont]
        }
    }
}

