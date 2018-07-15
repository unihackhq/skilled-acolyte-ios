//
//  VerifyViewController.swift
//  Skilled Acolyte
//
//  Created by Sophia Huynh on 17/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit
import JWTDecode

class VerifyViewController: UIViewController {

    @IBOutlet weak var verifyIconView: UIImageView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var dobLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func verify() {
        
        let token = nameLabel.text!
        
        verifyStudentToken(token: token) { (student) in
            guard let student = student else { return }
            
            if let firstLaunch = student.firstLaunch, firstLaunch == true {
                // Enter the onboarding process since this is the first time the student has logged in
                self.goToOnboardingPage()
            } else {
                self.goToHomePage()
            }
        }
    }
    
    @IBAction func dismissTextField(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    func verifyStudentToken(token: String, completion: ((Student?) -> Void)?) {
     
        Networking.shared.verifyLoginToken(token: token) { (error, jwt) in
            
            if let error = error {
                // TODO: better handle error
                let alert = UIAlertController(title: "Verify Login Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                if let completion = completion {
                    completion(nil)
                }
            } else if let jwt = jwt {
                
                // Decode the jwt using this nice library :)
                var jwtObject:JWT? = nil
                do {
                    jwtObject = try decode(jwt: jwt)
                } catch {
                    print("Failed to decode jwt token: \(jwt)")
                    if let completion = completion {
                        completion(nil)
                    }
                    return
                }
                
                // Extract student id from jwt
                guard let studentId = jwtObject!.body["userId"] as? String else {
                    print("Decoded jwt token but could not find userId inside: \(jwtObject!.body)")
                    if let completion = completion {
                        completion(nil)
                    }
                    return
                }
                
                // Get and store the current student
                Networking.shared.getStudent(byId: studentId, completion: { (error, student) in
                    
                    if let error = error {
                        // TODO: betterhandle error
                        let alert = UIAlertController(title: "Student Error", message: "\(error)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else if let student = student {
                        Configuration.CurrentStudent = student
                    }
                    
                    if let completion = completion {
                        completion(student)
                    }
                })
            } else {
                let alert = UIAlertController(title: "Unknown Error", message: "Your token couldn't be verified. Unfortunately we also had an unknown error. Please hassle tech team", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
                
                if let completion = completion {
                    completion(nil)
                }
            }
        }
    }
    
    func goToHomePage() {
        
        let homePage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarController")
        self.view.window?.rootViewController = homePage
    }
    
    func goToOnboardingPage() {
        
        let verifyVC = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "ConfirmDetailsViewController") as! ConfirmDetailsViewController
        let navController = UINavigationController(rootViewController: verifyVC)
        navController.navigationBar.isHidden = true
        view.window?.rootViewController = navController
    }

}
