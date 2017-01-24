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
    var endOneValid : Bool
    var endTwoValid: Bool
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
        endOneValid = TimeTable.isTheTimeValid(endOneTime)
        endTwoValid = TimeTable.isTheTimeValid(endTwoTime)
    }
    
    
    static func isTheTimeValid(time:String)->Bool{
        var hour = Int(0)
        var min = Int(0)
        if(time != ""){
            let time1 = time.componentsSeparatedByString(":")
            hour = Int(time1[0])!
            min = Int(time1[1])!
            
        }else{
            return true
        }
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components( [NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: date)
        let actualHour = components.hour
        let actualMin = components.minute
        
        if( hour > actualHour){
            return true;
        }
        if(hour == actualHour){
            if(min >= actualMin){
                return true
            }
            return false
        }
        if(hour < actualHour){
            return false;
        }
        return true
    }
    
    
}
