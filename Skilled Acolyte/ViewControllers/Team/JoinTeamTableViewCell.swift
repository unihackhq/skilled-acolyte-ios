//
//  JoinTeamTableViewCell.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 14/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

protocol JoinTeamTableViewCellDelegate: class {
    func joinTeamRequestDidAcceptInvite(team: Team)
    func joinTeamRequestDidRejectInvite(team: Team)
}

class JoinTeamTableViewCell: UITableViewCell {

    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var firstThreeMembers: UILabel!
    @IBOutlet weak var secondThreeMembers: UILabel!
    weak private var delegate: JoinTeamTableViewCellDelegate?
    var team: Team!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populate(withTeam team: Team, delegate: JoinTeamTableViewCellDelegate) {
        self.delegate = delegate
        self.team = team
        
        teamName.text = team.name
        var first3 = ""
        var second3 = ""
        
        for i in 0 ..< team.members.count {
            let member = team.members[i]
            if i < 3 {
                first3 += (member.fullName() + "\n")
            } else {
                second3 += (member.fullName() + "\n")
            }
        }
        
        firstThreeMembers.text = first3
        secondThreeMembers.text = second3
    }
    
    @IBAction func acceptInviteTapped() {
        
        if let delegate = delegate {
            delegate.joinTeamRequestDidAcceptInvite(team: team)
        }
    }
    
    @IBAction func rejectInviteTapped() {
        
        if let delegate = delegate {
            delegate.joinTeamRequestDidRejectInvite(team: team)
        }
    }
}
