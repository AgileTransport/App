//
//  AlarmTableCell.swift
//  ProjectTransport
//
//  Created by Lajos Pongracz on 1/29/17.
//  Copyright © 2017 Lajos Pongracz. All rights reserved.
//

import UIKit

class AlarmTableCell: UITableViewCell {

    @IBOutlet weak var timePicker: UIView!

    @IBOutlet weak var frequencyPicker: UIPickerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
