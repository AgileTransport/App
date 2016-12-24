//
//  TimeTable.swift
//  ProjectTransport
//
//  Created by Mark Mekker on 24/12/2016.
//  Copyright © 2016 Mark Mekker. All rights reserved.
//

import SwiftyJSON
import UIKit
class TimeTable: NSObject {
    var lineName :String
    var endOneTime : String
    var endTwoTime : String
    /*
    override init(){
    id = 0
    endOne = ""
    endTwo = ""
    type = ""
    }*/
    required init(json: JSON) {
        lineName = json["line"].stringValue
        endOneTime = json["endOne"].stringValue
        endTwoTime = json["endTwo"].stringValue
    }
}
