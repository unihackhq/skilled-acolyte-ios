//
//  SwitchEventTableViewCell.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 1/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class SwitchEventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populateWithEvent(event: Event) {
        eventTitle.text = event.name
        
        if let location = event.location {
            eventSubtitle.text = location
        } else {
            eventSubtitle.text = ""
        }
        
        if let image = event.downloadPhoto() {
            eventImage.image = image
        } else {
            eventImage.image = nil
        }
    }
}
