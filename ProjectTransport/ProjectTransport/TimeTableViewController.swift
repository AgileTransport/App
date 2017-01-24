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
    var indexForFirstAvailableTime = 0
    
    @IBOutlet weak var timeTable: UITableView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var endOneName: UILabel!
    
    @IBOutlet weak var endTwoName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeTable.dataSource = self
        timeTable.delegate = self
        loadTimeTableData()
        timeTable.rowHeight = 40
        title = "Line "+line.id
        endOneName.text = line!.endOne
        endTwoName.text = line!.endTwo
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let indexPath = NSIndexPath(forRow: 0, inSection: indexForFirstAvailableTime)
        timeTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        

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
        

        myCell.endOneTimeLabel.textColor = getColor(timeTableList[indexPath.section].endOneValid)
        myCell.endTwoTimeLabel.textColor = getColor(timeTableList[indexPath.section].endTwoValid)
        return myCell

    }
    
    func getColor(valid:Bool)->UIColor{
        if(valid){
            return UIColor.blackColor()
        }else{
            return UIColor.grayColor()
        }
    }
    
    func loadTimeTableData() {

        RestApiManager.sharedInstance.getTimeTableOfLine( { (json: JSON) in
            if let results = json.array {
                for (index, entry) in results.enumerate() {
                    let timeTableEntry = TimeTable(json: entry)
                    self.timeTableList.append(timeTableEntry)
                    if((timeTableEntry.endOneValid || timeTableEntry.endTwoValid) && self.indexForFirstAvailableTime == 0){
                        self.indexForFirstAvailableTime = index
                    }
                }
                dispatch_async(dispatch_get_main_queue(),{
                    self.timeTable!.reloadData()
                })
            }
            }, lineName: self.line!.id)
    }
}
