//
//  AlarmObject.swift
//  ProjectTransport
//
//  Created by Mark Mekker on 05/02/2017.
//  Copyright © 2017 Mark Mekker. All rights reserved.
//

import SwiftyJSON
import UIKit
class AlarmObject {
    var name:String
    var frequency: Frequencies
    var date: NSDate
    var lineId : String
    required init(name: String, frequency: Frequencies, date:NSDate, lineId:String) {
        self.name = name
        self.frequency = frequency
        self.date = date
        self.lineId = lineId
    }
    
    required init() {
        self.name = ""
        self.frequency = Frequencies.Everyday
        self.date = NSDate()
        self.lineId = ""
    }
    
    
}

enum Frequencies:String{
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
    case Weekend
    case Weekday
    case Everyday
    
    static func getByString(name: String)->Frequencies{
        switch(name){
            case "Monday":
            return Frequencies.Monday
        default: return Frequencies.Everyday
        }
    }
}
