//
//  ScheduleItemTableViewCell.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 19/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class ScheduleItemTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var contentPreview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populate(with scheduleItem: ScheduleItem) {
        
        var startTimeStr = ""
        
        if let startDate = scheduleItem.startDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "HHa"
            startTimeStr = formatter.string(from: startDate) + " "
        }
        
        title.text = scheduleItem.name
        subtitle.text = startTimeStr + (scheduleItem.location ?? "")
        contentPreview.text = scheduleItem.scheduleDescription
    }
}
