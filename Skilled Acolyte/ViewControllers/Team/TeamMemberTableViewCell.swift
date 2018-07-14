//
//  TeamMemberTableViewCell.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 14/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class TeamMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var studentPhoto: UIImageView!
    @IBOutlet weak var studentInitials: UILabel!
    @IBOutlet weak var studentName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populate(withStudent student: Student) {
        
        studentName.text = student.fullName()
        
        if let image = student.downloadPhoto() {
            studentPhoto.image = image
            studentInitials.text = ""
        } else if let initials = student.initials() {
            studentInitials.text = initials
        }
    }
}
