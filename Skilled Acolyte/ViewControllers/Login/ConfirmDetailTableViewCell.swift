//
//  ConfirmDetailTableViewCell.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 8/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

protocol ConfirmDetailTableViewCellDelegate: class {
    func confirmDetailNextTapped()
    func confirmDetailUpdated(value: Any, for confirmingDetail: String)
}

class ConfirmDetailTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak private var detailName: UILabel!
    @IBOutlet weak private var detailValue: UITextField!
    private var pickerView: UIPickerView! = UIPickerView()
    private var pickerViewData: [Any]! = [Any]()
    private var datePicker: UIDatePicker! = UIDatePicker()
    weak private var delegate: ConfirmDetailTableViewCellDelegate?
    private var confirmingDetail: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        datePicker.datePickerMode = .date
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Add next and previous buttons to the text field input accessory view
        let customView = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 48))
        customView.backgroundColor = UIColor.clear
        detailValue.inputAccessoryView = customView
        
        let buttonWidth:CGFloat = frame.size.width-32
        
        // Add the "next" button to the keyboard
        let btnNext = UIButton(frame: CGRect.init(x: (frame.size.width-buttonWidth)/2, y: 0, width: buttonWidth, height: 40))
        btnNext.backgroundColor = UIColor.init(red: 1, green: 203/255, blue: 81/255, alpha: 1) // TODO: add in correct yellow colour
        btnNext.setTitle("Next", for: .normal)
        btnNext.layer.cornerRadius = btnNext.frame.size.height/2
        btnNext.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        customView.addSubview(btnNext)
    }

    func populateWith(confirmingDetail: String, student: Student, delegate: ConfirmDetailTableViewCellDelegate!) {
        
        self.confirmingDetail = confirmingDetail
        self.delegate = delegate
        detailName.text = confirmingDetail
        // Reset default values
        detailValue.text = ""
        detailValue.isEnabled = true
        detailValue.alpha = 1
        
        switch confirmingDetail {
        case ConfirmDetail.ProfilePhoto:
            detailValue.text = student.photoUrl ?? ""
            detailValue.placeholder = "Photo URL"
            break
        case ConfirmDetail.FirstName:
            detailValue.text = student.user.firstName ?? ""
            break
        case ConfirmDetail.LastName:
            detailValue.text = student.user.lastName ?? ""
            break
        case ConfirmDetail.PreferredName:
            detailValue.text = student.user.preferredName ?? ""
            detailValue.placeholder = student.user.firstName ?? ""
            break
        case ConfirmDetail.DateOfBirth:
            if let dob = student.user.dateOfBirth {
                let formatter = DateFormatter()
                formatter.dateFormat = "d MMMM yyyy"
                detailValue.text = formatter.string(from: dob)
                datePicker.date = dob
            }
            detailValue.inputView = datePicker
            break
        case ConfirmDetail.Gender:
            detailValue.text = student.user.gender ?? ""
            break
        case ConfirmDetail.Email:
            detailValue.text = student.user.email ?? ""
            detailValue.keyboardType = .emailAddress
            detailValue.autocapitalizationType = .none
            break
        case ConfirmDetail.MobileNumber:
            detailValue.text = student.user.mobile ?? ""
            detailValue.keyboardType = .phonePad
            break
        case ConfirmDetail.EducationalInstitution:
            if let uni = student.university {
                detailValue.text = uni.name
            }
            detailValue.placeholder = "Select One"
            detailValue.inputView = pickerView
            loadUniversities(currentUniversity: student.university)
            break
        case ConfirmDetail.Course:
            detailValue.text = student.degree ?? ""
            break
        case ConfirmDetail.YearLevel:
            detailValue.text = student.studyLevel ?? ""
            break
        default:
            print("Error: Couldn't find detail to confirm: \(confirmingDetail)")
        }
    }
    
    func loadUniversities(currentUniversity: University?) {
        Networking.shared.getUniversities { (error, universities) in
            if let error = error {
                let alert = UIAlertController(title: "Universities Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            self.pickerViewData = universities
            self.pickerView.reloadAllComponents()
            
            // Select the current row
            if let currentUniversity = currentUniversity {
                let row = self.pickerViewData.index { (compareItem) -> Bool in
                    if let compareItem = compareItem as? University {
                        return compareItem == currentUniversity
                    }
                    return false
                }
                self.pickerView.selectRow(row!, inComponent: 0, animated: false)
            }
        }
    }
    
    @IBAction func hideKeyboardForTextField(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @objc func nextTapped() {
        detailValue.resignFirstResponder()
        if let delegate = delegate {
            delegate.confirmDetailNextTapped()
        }
    }
    
    @IBAction func textFieldDidType() {
        
        let text = detailValue.text ?? ""
        
        if let delegate = delegate {
            delegate.confirmDetailUpdated(value: text, for: confirmingDetail)
        }
    }
    
    @objc func datePickerChanged() {
        
        let newDate = datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        detailValue.text = formatter.string(from: newDate)
        
        if let delegate = delegate {
            delegate.confirmDetailUpdated(value: newDate, for: confirmingDetail)
        }
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let university = pickerViewData[row] as? University {
            detailValue.text = university.name
            
            if let delegate = delegate {
                delegate.confirmDetailUpdated(value: university, for: confirmingDetail)
            }
        }
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let university = pickerViewData[row] as? University {
            return university.name
        }
        return ""
    }
}
