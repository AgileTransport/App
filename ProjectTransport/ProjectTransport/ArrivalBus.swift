//
//  ArrivalBus.swift
//  ProjectTransport
//
//  Created by Lajos Pongracz on 2/8/17.
//  Copyright © 2017 Lajos Pongracz. All rights reserved.
//
import SwiftyJSON
import UIKit

class ArrivalBus: NSObject {
    var line :String
    var time : String
    
    required init(json: JSON) {
        line = json["line"].stringValue
        time = json["time"].stringValue
    }
}

