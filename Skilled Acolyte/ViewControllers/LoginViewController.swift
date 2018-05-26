//
//  LoginViewController.swift
//  Skilled Acolyte
//
//  Created by Sophia Huynh on 17/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Check if we're already logged in, then go to the home screen
        if Configuration.CurrentStudent != nil {
            goToHomePage()
        }
        
        emailLabel.text = "john123@blackhole.postmarkapp.com"
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
        
        SVProgressHUD.show()
        Networking.shared.login(email: email) { (error) in
            SVProgressHUD.dismiss()
            
            if let _ = error {
                // TODO: handle error
            } else {
                self.goToVerifyPage()
            }
        }
    }

    func goToVerifyPage() {
        
        let verifyPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyViewController")
        self.present(verifyPage, animated: true, completion: nil)
    }
    
    func goToHomePage() {
        
        let homePage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarController")
        self.present(homePage, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hintLabel.isHidden = false
        loginButton.isHidden = false
    }

}
