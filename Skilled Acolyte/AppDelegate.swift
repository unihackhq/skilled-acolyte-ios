//
//  AppDelegate.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 30/4/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit
import PushNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let pushNotifications = PushNotifications.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Currently running this app for local development
        Configuration.Environment = "dev"
        
        
        // If we're already logged in start on the home screen, otherwise login
        var startingVC:UIViewController? = nil
        if Configuration.CurrentStudent != nil {
             startingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController")
        } else {
            startingVC = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        }
        window?.rootViewController = startingVC
        
        
        // Register for notifications
        self.pushNotifications.start(instanceId: "57148181-1dd1-4b6d-9779-aec284a39473")
        
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
    }

    // MARK: - Push Notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pushNotifications.registerDeviceToken(deviceToken) {
            
            guard let event = Configuration.CurrentEvent else { return }
            try? self.pushNotifications.subscribe(interest: event.id+"-session")
            try? self.pushNotifications.subscribe(interest: event.id+"-techTalk")
            try? self.pushNotifications.subscribe(interest: event.id+"-mealsRafflesEtc")
            try? self.pushNotifications.subscribe(interest: event.id+"-importantMessages")
            UserDefaults.standard.set(true, forKey: event.id+"-session")
            UserDefaults.standard.set(true, forKey: event.id+"-techTalk")
            UserDefaults.standard.set(true, forKey: event.id+"-mealsRafflesEtc")
            UserDefaults.standard.set(true, forKey: event.id+"-importantMessages")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for push \(error)")
    }
}

