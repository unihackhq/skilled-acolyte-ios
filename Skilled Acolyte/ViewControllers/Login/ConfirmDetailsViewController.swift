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

class ConfirmDetailsViewController: UIViewController, UITableViewDataSource, ConfirmDetailTableViewCellDelegate {

    @IBOutlet weak var confirmDetailTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var tableViewData: [String]!
    private var confirmingStudent: Student! = Configuration.CurrentStudent
    private var confirmingStep: Int! = 1
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        switch confirmingStep {
        case 1:
            confirmDetailTitle.text = "Confirm Personal Details"
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
            confirmDetailTitle.text = "Confirm Contact Details"
            tableViewData = [
                ConfirmDetail.Email,
                ConfirmDetail.MobileNumber
            ]
            break
        case 3:
            confirmDetailTitle.text = "Confirm Study Details"
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
    
    func confirmDetailUpdated(value: String, for confirmingDetail: String) {
        
        switch confirmingDetail {
        case ConfirmDetail.ProfilePhoto:
            confirmingStudent.photoUrl = value
        case ConfirmDetail.FirstName:
            confirmingStudent.user.firstName = value
            break
        case ConfirmDetail.LastName:
            confirmingStudent.user.lastName = value
            break
        case ConfirmDetail.PreferredName:
            if let firstName = confirmingStudent.user.firstName,
                value == "" {
                confirmingStudent.user.preferredName = firstName
            } else {
                confirmingStudent.user.preferredName = value
            }
            break
        case ConfirmDetail.DateOfBirth:
            // TODO: extract date
            break
        case ConfirmDetail.Gender:
            confirmingStudent.user.gender = value
            break
        case ConfirmDetail.Email:
            confirmingStudent.user.email = value
            break
        case ConfirmDetail.MobileNumber:
            confirmingStudent.user.mobile = value
            break
        case ConfirmDetail.EducationalInstitution:
            // TODO: sort out university id. drop down?
            break
        case ConfirmDetail.Course:
            confirmingStudent.degree = value
            break
        case ConfirmDetail.YearLevel:
            confirmingStudent.studyLevel = value
            break
        default:
            print("Error: Couldn't find detail to confirm: \(confirmingDetail) : \(value)")
        }
    }
}
