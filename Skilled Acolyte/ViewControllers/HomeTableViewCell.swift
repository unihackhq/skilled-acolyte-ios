//
//  HomeTableViewCell.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 22/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populate(withTitle title: String, content: Any?) {
        itemTitle.text = title
        
        if let content = content as? ScheduleItem {
            
            var durationStr = ""
            
            if let startDate = content.startDate, let endDate = content.endDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                durationStr = formatter.string(from: startDate) + " - " + formatter.string(from: endDate) + "\n"
            }
            
            itemBody.text = content.name + "\n" + durationStr + (content.location ?? "")
            
        }
    }
}
