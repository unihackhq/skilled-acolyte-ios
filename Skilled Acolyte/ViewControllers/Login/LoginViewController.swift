//
//  LoginViewController.swift
//  Skilled Acolyte
//
//  Created by Sophia Huynh on 17/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var unihackLogo: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable swipe back navigation option
        if view.window?.rootViewController == self {
            navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
        
        unihackLogo.alpha = 0.0
        containerView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        versionLabel.text = "v\(version) \(build)"
        
        UIView.animate(withDuration: 0.3, animations: {
            self.unihackLogo.alpha = 1.0
            self.containerView.alpha = 1.0
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextTapped() {
        
        if emailLabel.alpha == 0 {
            // Return to login view
            showLogin()
        } else {
            // Login then show verify view
            guard var email = emailLabel.text else {
                print("No email supplied!")
                return
            }
            
            email = (email as NSString).replacingOccurrences(of: " ", with: "")
            
            Networking.shared.login(email: email) { (error) in
                
                if let error = error {
                    if let error = error as NSError?, let statusCode = error.userInfo["statusCode"] as? Int, statusCode == 400 {
                        // Custom error message for probably the most common error. Unknown email address
                        Tools().showErrorMessage(title: "Login Error", message: "We couldn't find your email address", view: self.view)
                    } else {
                        Tools().showError(title: "Login Error", error: error, view: self.view)
                    }
                } else {
                    self.showVerify(email: email)
                }
            }
        }
    }
    
    func showLogin() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.text = "Welcome to the Imagination Hackathon."
            self.emailLabel.alpha = 1
            self.emailLabel.text = ""
            self.nextButton.setTitle("Login", for: .normal)
            self.detailLabel.text = "Make sure to enter the same email you bought your ticket with."
        })
    }

    func showVerify(email: String) {
        
        self.emailLabel.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.text = "We just sent you a login email at \(email)"
            self.emailLabel.alpha = 0
            self.nextButton.setTitle("Use a different email", for: .normal)
            self.detailLabel.text = "You will automatically be brought to the app once logged in."
        })
    }
    
    @IBAction func aboutUnihackTapped() {
        
        let aboutUnihackVC = UIStoryboard(name: "Public", bundle: nil).instantiateViewController(withIdentifier: "AboutUnihackViewController")
        navigationController?.pushViewController(aboutUnihackVC, animated: true)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Enables the navigation swipe back feature
        return true
    }
}
