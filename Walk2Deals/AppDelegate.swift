//
//  AppDelegate.swift
//  Walk2Deals
//
//  Created by apple on 18/09/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,SWRevealViewControllerDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //        CXDataService.sharedInstance.getTheAppDataFromServer(["":"" as AnyObject]) { (dict) in
        //
        //        }
        IQKeyboardManager.sharedManager().enable = true

        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor(colorLiteralRed: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        
        let myAttributeTxtColor = [NSForegroundColorAttributeName: UIColor.white]
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Roboto-Regular", size: 18.0)!]
        navigationBarAppearace.titleTextAttributes = myAttribute
        navigationBarAppearace.titleTextAttributes = myAttributeTxtColor
        
        //CXDataService.sharedInstance.imageData()
        if CXAppConfig.sharedInstance.getUserID().isEmpty {
            
        }else{
           self.setUpSidePanl()
        }
        CXLog.print("Realm DB path \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        return true
    }
    
    func logOutFromTheApp(){
        self.loadLoginView()
        return
    /*    for view in (self.window?.subviews)!{
            view.removeFromSuperview()
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let  loginViewController: LaunchViewController = (storyBoard.instantiateViewController(withIdentifier: "LaunchViewController") as? LaunchViewController)!
        
        let lognNavCntl : UINavigationController = UINavigationController(rootViewController: loginViewController)
        lognNavCntl.isNavigationBarHidden = true
        self.window?.rootViewController = lognNavCntl*/
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
    
    func setUpSidePanl(){
        
        let wFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.window = UIWindow.init(frame: wFrame)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeView = storyBoard.instantiateViewController(withIdentifier: "W2DHomeViewController") as! W2DHomeViewController
        let menuVC = storyBoard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        
        let menuVCNav = UINavigationController(rootViewController: menuVC)
        //menuVCNav.isNavigationBarHidden = true
        
        let navHome = UINavigationController(rootViewController: homeView)
        // navHome.isNavigationBarHidden = true
        
        let revealVC = SWRevealViewController(rearViewController: menuVCNav, frontViewController: navHome)
        revealVC?.delegate = self
        self.window?.rootViewController = revealVC
        self.window?.makeKeyAndVisible()
        
        
        //        let drawer : ICSDrawerController = ICSDrawerController(leftViewController: menuVC, centerViewController: homeView)
        //        self.window?.rootViewController = drawer
        //        self.window?.makeKeyAndVisible()
        
    }
    
    func loadLoginView(){
        let wFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.window = UIWindow.init(frame: wFrame)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let enternumber : EnterMobileNumberViewController = (storyboard.instantiateViewController(withIdentifier: "EnterMN") as? EnterMobileNumberViewController)!
        let navHome = UINavigationController(rootViewController: enternumber)
        navHome.navigationBar.isHidden = true
        self.window?.rootViewController = navHome
        self.window?.makeKeyAndVisible()
    }
    
    
    
}
extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
