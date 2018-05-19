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
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!

    
    @IBAction func login() {
        // call API and send confirmation email
        // TODO How does it know that you've logged in?
        
        goToVerifyPage()
    }
    
    func goToVerifyPage() {
        // prepare segue to go to verification page
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        hintLabel.isHidden = false
        loginButton.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
