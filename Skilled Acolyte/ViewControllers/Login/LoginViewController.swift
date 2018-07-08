//
//  LoginViewController.swift
//  Skilled Acolyte
//
//  Created by Sophia Huynh on 17/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.logoView.isHidden = false
        self.titleView.isHidden = false
        self.hintLabel.isHidden = false
        self.emailLabel.isHidden = false
        self.loginButton.isHidden = false
        UIView.animate(withDuration: 1.5, animations: {
            self.logoView.alpha = 1.0
            self.titleView.alpha = 1.0
            self.hintLabel.alpha = 1.0
            self.emailLabel.alpha = 1.0
            self.loginButton.alpha = 1.0
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        emailLabel.text = "test_student@blackhole.postmarkapp.com"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login() {
        
        guard let email = emailLabel.text else {
            print("No email supplied!")
            return
        }
        
        Networking.shared.login(email: email) { (error) in
            
            if let _ = error {
                // TODO: handle error
            } else {
                self.goToVerifyPage()
            }
        }
    }

    func goToVerifyPage() {
        
        let verifyVC = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "ConfirmDetailsViewController") as! ConfirmDetailsViewController
        let navController = UINavigationController(rootViewController: verifyVC)
        navController.navigationBar.isHidden = true
        view.window?.rootViewController = navController
    }
    

}
