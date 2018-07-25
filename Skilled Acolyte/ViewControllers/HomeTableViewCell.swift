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
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var colouredView: UIView!
    
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
            
            name.text = content.name
            
            if let startDate = content.startDate, let endDate = content.endDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                
                // Only append the end date if it's different from the start
                if startDate != endDate {
                    time.text = formatter.string(from: startDate) + " - " + formatter.string(from: endDate) + "\n"
                } else {
                    time.text = formatter.string(from: startDate)
                }

            } else {
                time.text = ""
            }
            
            if let locationStr = content.location {
                location.text = locationStr
            } else {
                location.text = ""
            }
        }
    }
}
