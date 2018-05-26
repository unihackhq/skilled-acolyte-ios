//
//  VerifyViewController.swift
//  Skilled Acolyte
//
//  Created by Sophia Huynh on 17/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
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
            self.goToHomePage()
        }
    }
    
    func verifyStudentToken(token: String, completion: ((Student?) -> Void)?) {
     
        SVProgressHUD.show()
        Networking.shared.verifyLoginToken(token: token) { (error, jwt) in
            SVProgressHUD.dismiss()
            
            if let _ = error {
                // TODO: handle error
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
                SVProgressHUD.show()
                Networking.shared.getStudent(byId: studentId, completion: { (error, student) in
                    SVProgressHUD.dismiss()
                    
                    if let _ = error {
                        // TODO: handle error
                    } else if let student = student {
                        Constants.CurrentStudent = student
                    }
                    
                    if let completion = completion {
                        completion(student)
                    }
                })
            }
        }
    }
    
    func goToHomePage() {
        
        let homePage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomepageViewController")
        self.present(homePage, animated: true, completion: nil)
    }

}
