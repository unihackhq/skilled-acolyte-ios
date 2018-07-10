//
//  InviteToTeamTableViewCell.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 10/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class InviteToTeamTableViewCell: UITableViewCell {

    @IBOutlet weak var studentName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populateWith(student: Student) {
                
        studentName.text = (student.user.firstName ?? "") + " " + (student.user.lastName ?? "")
    }
}
