//
//  AlarmTableCell.swift
//  ProjectTransport
//
//  Created by Lajos Pongracz on 1/29/17.
//  Copyright © 2017 Lajos Pongracz. All rights reserved.
//

import UIKit

class AlarmTableCell: UITableViewCell {

    @IBOutlet weak var lineNameLabel: UILabel!
    
    @IBOutlet weak var alarmFrequencyLabel: UILabel!

    @IBOutlet weak var alarmTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
