//
//  TimeTableViewController.swift
//  ProjectTransport
//
//  Created by Mark Mekker on 24/12/2016.
//  Copyright © 2016 Mark Mekker. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ShowDetailDelegate: class {
}

class TimeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate : ShowDetailDelegate!
    var line:BusLine!
    var timeTableList = [TimeTable]()
    
    @IBOutlet weak var timeTable: UITableView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var endOneName: UILabel!
    
    @IBOutlet weak var endTwoName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Do any additional setup after loading the view, typically from a nib.
        timeTable.dataSource = self
        timeTable.delegate = self
        loadTimeTableData()
        timeTable.rowHeight = 40
        title = "Line "+line.id
        endOneName.text = line!.endOne
        endTwoName.text = line!.endTwo

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0; // space b/w cells
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return timeTableList.count    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        let myCell = timeTable!.dequeueReusableCellWithIdentifier("timetablecell",
            forIndexPath: indexPath) as! TimeTableCustomCell
        myCell.endOneTimeLabel.text = timeTableList[indexPath.section].endOneTime
        myCell.endTwoTimeLabel.text = timeTableList[indexPath.section].endTwoTime
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components( [NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: date)
        let nowHour = components.hour
        let nowMin = components.minute
        
        var time1IsGood = true
        var time2IsGood = true
        //print("")
        
        if( timeTableList[indexPath.section].endOneTime != ""){
            let time1 = timeTableList[indexPath.section].endOneTime.componentsSeparatedByString(":")
            let time1Hour = Int(time1[0])
            let time1Min = Int(time1[1])
            
            time1IsGood = isTheTimeValid(time1Hour!, min: time1Min!, actualHour: nowHour, actualMin: nowMin)
            
        }
        
        if( timeTableList[indexPath.section].endTwoTime != ""){
            let time1 = timeTableList[indexPath.section].endTwoTime.componentsSeparatedByString(":")
            let time1Hour = Int(time1[0])
            let time1Min = Int(time1[1])
            
            time2IsGood = isTheTimeValid(time1Hour!, min: time1Min!, actualHour: nowHour, actualMin: nowMin)
        }
        
        if(time1IsGood){
            myCell.endOneTimeLabel.textColor = UIColor.blackColor()
        }else{
            myCell.endOneTimeLabel.textColor = UIColor.grayColor()
        }
        
        if(time2IsGood){
            myCell.endTwoTimeLabel.textColor  = UIColor.blackColor()
        }else{
            myCell.endTwoTimeLabel.textColor  = UIColor.grayColor()
        }
        
        return myCell

    }
    
    
    func isTheTimeValid(hour:Int, min:Int, actualHour:Int, actualMin:Int)->Bool{
        
        //print("actual: \(actualHour):\(actualMin)")
        //print("actual: \(min):\(hour)")
        
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
    
    func loadTimeTableData() {

        RestApiManager.sharedInstance.getTimeTableOfLine( { (json: JSON) in
            if let results = json.array {
                for entry in results {
                    self.timeTableList.append(TimeTable(json: entry))
                }
                dispatch_async(dispatch_get_main_queue(),{
                    self.timeTable!.reloadData()
                })
            }
            }, lineName: self.line!.id)
    }
    
    
    /*
    if let results = json.array {
    for entry in results {
    self.busLines.append(TimeTable(json: entry))
    }
    dispatch_async(dispatch_get_main_queue(),{
    self.tableViewWidget!.reloadData()
    })
    }
    */
}
