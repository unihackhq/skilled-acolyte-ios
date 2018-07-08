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
    func confirmDetailBackTapped()
    func confirmDetailUpdated(value: String, for confirmingDetail: String)
}

class ConfirmDetailTableViewCell: UITableViewCell {

    @IBOutlet weak private var detailName: UILabel!
    @IBOutlet weak private var detailValue: UITextField!
    weak private var delegate: ConfirmDetailTableViewCellDelegate?
    private var confirmingDetail: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Add next and previous buttons to the text field input accessory view
        let customView = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 48))
        customView.backgroundColor = UIColor.clear
        detailValue.inputAccessoryView = customView
        
        let buttonWidth:CGFloat = 125
        
        let btnNext = UIButton(frame: CGRect.init(x: frame.size.width-buttonWidth-16, y: 0, width: buttonWidth, height: 40))
        btnNext.backgroundColor = UIColor.init(red: 1, green: 203/255, blue: 81/255, alpha: 1) // TODO: add in correct yellow colour
        btnNext.setTitle("Next", for: .normal)
        btnNext.layer.cornerRadius = btnNext.frame.size.height/2
        btnNext.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        customView.addSubview(btnNext)
        
        let btnBack = UIButton(frame: CGRect.init(x: 16, y: 0, width: buttonWidth, height: 40))
        btnBack.backgroundColor = UIColor.lightGray
        btnBack.setTitle("Back", for: .normal)
        btnBack.layer.cornerRadius = btnNext.frame.size.height/2
        btnBack.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        customView.addSubview(btnBack)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populateWith(confirmingDetail: String, student: Student, delegate: ConfirmDetailTableViewCellDelegate!) {
        
        self.confirmingDetail = confirmingDetail
        self.delegate = delegate
        detailName.text = confirmingDetail
        detailValue.text = ""
        
        switch confirmingDetail {
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
// TODO: extract date
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
// TODO: extract from uni id
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
    
    @IBAction func hideKeyboardForTextField(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @objc func nextTapped() {
        detailValue.resignFirstResponder()
        if let delegate = delegate {
            delegate.confirmDetailNextTapped()
        }
    }
    
    @objc func backTapped() {
        detailValue.resignFirstResponder()
        if let delegate = delegate {
            delegate.confirmDetailBackTapped()
        }
    }
    
    @IBAction func textFieldDidType() {
        
        let text = detailValue.text ?? ""
        
        if let delegate = delegate {
            delegate.confirmDetailUpdated(value: text, for: confirmingDetail)
        }
    }
}
