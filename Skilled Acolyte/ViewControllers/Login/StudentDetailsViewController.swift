//
//  StudentDetailsViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 26/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class StudentDetailsViewController: UIViewController {

    //@IBOutlet weak var scrollingView: UIScrollView!
    @IBOutlet weak var studentFieldsView: UIView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPreferredName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtStudyLevel: UITextField!
    @IBOutlet weak var txtDegree: UITextField!
    @IBOutlet weak var txtDietaryReq: UITextField!
    @IBOutlet weak var txtMedicalReq: UITextField!
    @IBOutlet weak var txtTShirtSize: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentStudent = Configuration.CurrentStudent else { return print("Student does not exist! Logout?") }
        
        // Get the latest student details
        Networking.shared.getStudent(byId: currentStudent.id) { (error, student) in
            
            if let _ = error {
                // TODO: handle error
            } else if let student = student {
                Configuration.CurrentStudent = student
                
                // Fill out the known fields
                if let firstName = student.user.firstName { self.txtFirstName.text = firstName }
                if let lastName = student.user.lastName { self.txtLastName.text = lastName }
                if let preferredName = student.user.preferredName { self.txtPreferredName.text = preferredName }
                if let email = student.user.email { self.txtEmail.text = email }
//                if let dateOfBirth = student.user.dateOfBirth { self.txtDateOfBirth.text = dateOfBirth }
                if let gender = student.user.gender { self.txtGender.text = gender }
                if let mobile = student.user.mobile { self.txtMobile.text = mobile }
                if let degree = student.degree { self.txtDegree.text = degree }
                if let studyLevel = student.studyLevel { self.txtStudyLevel.text = studyLevel }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissTextField(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func save(_ sender: Any) {
        guard var updatedStudent = Configuration.CurrentStudent else { return }
        
        // Validate required fields
        guard let firstName = txtFirstName.text, firstName.count > 0 else { return }
        guard let lastName = txtLastName.text, lastName.count > 0 else { return }
        guard let preferredName = txtPreferredName.text, preferredName.count > 0 else { return }
        guard let email = txtEmail.text, email.count > 0 else { return }
//        guard let dateOfBirth = txtDateOfBirth.text, dateOfBirth.count > 0 else { return } // TODO: convert to date
        guard let gender = txtGender.text, gender.count > 0 else { return }
        guard let mobile = txtMobile.text, mobile.count > 0 else { return }
        
        // Apply fields to the student object
        updatedStudent.user.firstName = firstName
        updatedStudent.user.lastName = lastName
        updatedStudent.user.preferredName = preferredName
        updatedStudent.user.email = email
        //        updatedStudent.user.dateOfBirth = dateOfBirth // TODO: convert to date
        updatedStudent.user.gender = gender
        updatedStudent.user.mobile = mobile
        updatedStudent.degree = txtDegree.text
        updatedStudent.studyLevel = txtStudyLevel.text
        
        // Update the student on the server
        Networking.shared.updateStudent(student: updatedStudent) { (error, student) in
            if let _ = error {
                // TODO: handle error
            } else if let student = student {
                // Save the updated student
                Configuration.CurrentStudent = student
                self.goToHomePage()
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goToHomePage() {
        let homePage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarController")
        self.view.window?.rootViewController = homePage
    }
}
