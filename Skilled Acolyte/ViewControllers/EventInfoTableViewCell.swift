//
//  EventInfoTableViewCell.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 21/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class EventInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var summary: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populate(withInfo item: EventInfoItem) {
        
        title.text = item.name
        summary.text = item.summary
    }
}
