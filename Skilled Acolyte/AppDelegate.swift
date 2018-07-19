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
        if Configuration.CurrentStudent != nil {
            showHomeVC()
        } else {
            showLoginVC()
        }
        
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

    // MARK: - Deep Linking
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let host = components.host else {
            return false
        }
        
        var pathComponents = components.path.components(separatedBy: "/")
        pathComponents.removeFirst()
        
        if host == "token", let token = pathComponents.first, token != "" {
            
            // We've got the token, attempt to verify
            Networking.shared.verifyLoginToken(token: token) { (error, jwt, studentId) in
                
                if let error = error {
                    self.showLoginVC()
                    self.showErrorAlert(message: String(describing: error))
                } else if let studentId = studentId {
                    Networking.shared.getStudent(byId: studentId, completion: { (error, student) in
                        
                        if let error = error {
                            self.showLoginVC()
                            self.showErrorAlert(message: String(describing: error))
                        } else if let student = Configuration.CurrentStudent {
                            if student.firstLaunch != nil && student.firstLaunch == true {
                                self.showVerifyVC()
                            } else {
                                self.showHomeVC()
                            }
                        } else {
                            self.showLoginVC()
                            self.showErrorAlert(message: "You opened a UNIHACK link, but there was no user associated with it.")
                        }
                    })
                }
            }
        } else {
            self.showLoginVC()
            showErrorAlert(message: "You opened a UNIHACK link, but there was no user information in it.")
        }
        
        return true
    }
    
    // MARK: - Navigation Methods
    
    func showHomeVC() {
        
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController")
    }
    
    func showOnboardingVC() {
        
        let verifyVC = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "ConfirmDetailsViewController")
        let navController = UINavigationController(rootViewController: verifyVC)
        navController.navigationBar.isHidden = true
        window?.rootViewController = navController
    }
    
    func showLoginVC() {
        
        window?.rootViewController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
    }
    
    func showVerifyVC() {
        
        window?.rootViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "VerifyViewController")
    }
    
    // MARK: - Other
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

