//
//  AppDelegate.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/6/2.
//  Copyright © 2018年 t19960804. All rights reserved.
//
//id - ca-app-pub-5941469490008558~1993597310
import UIKit
import Firebase
import RealmSwift
import FBSDKCoreKit
import GoogleSignIn
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if error != nil
//        {
//            print("Log In Fail:",error)
//            return
//        }
//        else
//        {
//            print("Log In Success:",user.profile.email!)
//        }
//        //建立user在FireBase
//        guard let idToken = user.authentication.idToken else {fatalError("idToken is nil")}
//        guard let accessTokens  = user.authentication.accessToken else {fatalError("accessTokens is nil")}
//        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessTokens)
//        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
//            if error != nil
//            {
//                print("Sign In Fail:\(error)")
//            }
//            print("GoogleUser:\(user)")
//        }
//    }
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        // Override point for customization after application launch.
        //加入FireBase的設定檔
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        //廣告
        GADMobileAds.configure(withApplicationID: "ca-app-pub-5941469490008558~1993597310")
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplication.OpenURLOptionsKey.sourceApplication])

        return handled
    }
    
    ///////////////////////////////////////////////
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


}

