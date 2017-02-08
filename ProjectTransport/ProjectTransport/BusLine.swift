//
//  BusLine.swift
//  ProjectTransport
//
//  Created by Mark Mekker on 21/12/2016.
//  Copyright © 2016 Mark Mekker. All rights reserved.
//
import SwiftyJSON
import UIKit

class BusLine: NSObject {
    var id :String
    var endOne : String
    var endTwo : String
    var type : String
    /*
    override init(){
        id = 0
        endOne = ""
        endTwo = ""
        type = ""
    }*/
    required init(json: JSON) {
        id = json["id"].stringValue
        endOne = json["endOne"].stringValue
        endTwo = json["endTwo"].stringValue
        type = json["type"].stringValue
    }
}
