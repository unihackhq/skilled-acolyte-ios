//
//  ConfirmImageDetailTableViewCell.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 8/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

protocol ConfirmImageDetailTableViewCellDelegate: class {
    func confirmImageDetailUpdated(value: String, for confirmingDetail: UIImage)
}

class ConfirmImageDetailTableViewCell: UITableViewCell {

    @IBOutlet weak private var detailName: UILabel!
    @IBOutlet weak private var detailImage: UIButton!
    weak private var delegate: ConfirmImageDetailTableViewCellDelegate?
    private var confirmingDetail: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populateWith(confirmingDetail: String, student: Student, delegate: ConfirmImageDetailTableViewCellDelegate!) {
        
        self.confirmingDetail = confirmingDetail
        self.delegate = delegate
        detailName.text = confirmingDetail
        // Reset default values
        detailImage.setImage(nil, for: .normal)
        detailImage.setTitle("", for: .normal)
        
        switch confirmingDetail {
        case ConfirmDetail.ProfilePhoto:
            if let profilePhoto = student.downloadPhoto() {
                detailImage.setImage(profilePhoto, for: .normal)
            } else if let initials = student.initials() {
                detailImage.setTitle(initials, for: .normal)
            }
            break
        default:
            print("Error: Couldn't find image detail to confirm: \(confirmingDetail)")
        }
    }
    
//    @IBAction func btnConfirmImageTapped() {
//
//        let alert = UIAlertController(title: "Set Profile Photo", message: "Enter the URL of a photo", preferredStyle: .alert)
//        alert.addTextField { (textField) in
//            textField.keyboardType = .URL
//        }
//        alert.addAction(UIAlertAction(title: "Set", style: .default, handler: { (action) in
//            let textField = alert.textFields!.first!
//            if let urlText = textField.text {
//
//                // Download the image with 'strict' validation
//                guard let url = URL(string: urlText) else { return }
//                guard let data = try? Data(contentsOf: url) else { return }
//                guard let image = UIImage(data: data) else { return }
//
//                // If successful, set the image, remove the text, and save the url
//                self.detailImage.setImage(image, for: .normal)
//            }
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
}
