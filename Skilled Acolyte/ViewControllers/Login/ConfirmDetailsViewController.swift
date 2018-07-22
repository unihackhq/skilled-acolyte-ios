//
//  ConfirmDetailsViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 8/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

struct ConfirmDetail {
    static var ProfilePhoto = "Profile Photo"
    static var FirstName = "First Name"
    static var LastName = "Last Name"
    static var PreferredName = "Preferred Name"
    static var DateOfBirth = "Date of Birth"
    static var Gender = "Gender"
    
    static var Email = "Email"
    static var MobileNumber = "Mobile Number"
    
    static var EducationalInstitution = "Educational Institution"
    static var Course = "Course"
    static var YearLevel = "Year Level"
}

class ConfirmDetailsViewController: UIViewController, UITableViewDataSource, UIGestureRecognizerDelegate, ConfirmDetailTableViewCellDelegate {

    @IBOutlet weak var confirmDetailTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var tableViewData: [String]!
    private var confirmingStudent: Student! = Configuration.CurrentStudent
    private var confirmingStep: Int! = 1
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable swipe back navigation option
        if view.window?.rootViewController == self {
            navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
        
        switch confirmingStep {
        case 1:
            confirmDetailTitle.text = "Personal Details"
            tableViewData = [
                ConfirmDetail.ProfilePhoto,
                ConfirmDetail.FirstName,
                ConfirmDetail.LastName,
                ConfirmDetail.PreferredName,
                ConfirmDetail.DateOfBirth,
                ConfirmDetail.Gender
            ]
            break
        case 2:
            confirmDetailTitle.text = "Contact Information"
            tableViewData = [
                ConfirmDetail.Email,
                ConfirmDetail.MobileNumber
            ]
            break
        case 3:
            confirmDetailTitle.text = "Study Information"
            tableViewData = [
                ConfirmDetail.EducationalInstitution,
                ConfirmDetail.Course,
                ConfirmDetail.YearLevel
            ]
            btnNext.setTitle("Finish", for: .normal)
            break
        default:
            print("Error: Went too far confirming student details. Step: \(confirmingStep!)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateWithConfirmingStudent(_ confirmingStudent: Student, confirmingStep: Int) {
        self.confirmingStudent = confirmingStudent
        self.confirmingStep = confirmingStep
    }
    
    @IBAction func btnNextTapped() {
        
        if confirmingStep == 3 {
            // Finish
            Networking.shared.updateStudent(student: confirmingStudent) { (error, student) in
                if let error = error {
                    let alert = UIAlertController(title: "Error Updating Details", message: "Sorry but your details couldn't be updated.\n\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController")
                        self.view.window?.rootViewController = homeVC
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController")
                    self.view.window?.rootViewController = homeVC
                }
            }
        } else {
            let nextStepVc = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "ConfirmDetailsViewController") as! ConfirmDetailsViewController
            nextStepVc.populateWithConfirmingStudent(confirmingStudent, confirmingStep: confirmingStep+1)
            navigationController?.pushViewController(nextStepVc, animated: true)
        }
    }
    
    @IBAction func btnBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmDetailCell") as! ConfirmDetailTableViewCell
        let studentDetail = tableViewData[indexPath.row]
        cell.populateWith(confirmingDetail: studentDetail, student: confirmingStudent, delegate: self)
        
        return cell
    }
    
    // MARK: - ConfirmDetailTableViewCellDelegate
    
    func confirmDetailNextTapped() {
        btnNextTapped()
    }
    
    func confirmDetailBackTapped() {
        btnBackTapped()
    }
    
    func confirmDetailUpdated(value: Any, for confirmingDetail: String) {
        
        let textValue = value as? String ?? ""
        let dateValue = value as? Date ?? Date()
        let universityValue = value as? University ?? Configuration.CurrentStudent!.university
        
        switch confirmingDetail {
        case ConfirmDetail.ProfilePhoto:
            confirmingStudent.photoUrl = textValue
        case ConfirmDetail.FirstName:
            confirmingStudent.user.firstName = textValue
            break
        case ConfirmDetail.LastName:
            confirmingStudent.user.lastName = textValue
            break
        case ConfirmDetail.PreferredName:
            if let firstName = confirmingStudent.user.firstName,
                textValue == "" {
                confirmingStudent.user.preferredName = firstName
            } else {
                confirmingStudent.user.preferredName = textValue
            }
            break
        case ConfirmDetail.DateOfBirth:
            confirmingStudent.user.dateOfBirth = dateValue
            break
        case ConfirmDetail.Gender:
            confirmingStudent.user.gender = textValue
            break
        case ConfirmDetail.Email:
            confirmingStudent.user.email = textValue
            break
        case ConfirmDetail.MobileNumber:
            confirmingStudent.user.mobile = textValue
            break
        case ConfirmDetail.EducationalInstitution:
            confirmingStudent.university = universityValue
            break
        case ConfirmDetail.Course:
            confirmingStudent.degree = textValue
            break
        case ConfirmDetail.YearLevel:
            confirmingStudent.studyLevel = textValue
            break
        default:
            print("Error: Couldn't find detail to confirm: \(confirmingDetail) : \(value)")
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Enables the navigation swipe back feature
        return true
    }
}
