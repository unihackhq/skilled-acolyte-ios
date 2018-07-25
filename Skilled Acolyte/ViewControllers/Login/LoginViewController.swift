//
//  LoginViewController.swift
//  Skilled Acolyte
//
//  Created by Sophia Huynh on 17/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var unihackLogo: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unihackLogo.alpha = 0.0
        containerView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
                    // TODO: better handle error
                    let alert = UIAlertController(title: "Login Error", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
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
}
