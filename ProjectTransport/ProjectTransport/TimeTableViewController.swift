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
        return timeTableList.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        let myCell = timeTable!.dequeueReusableCellWithIdentifier("timetablecell",
            forIndexPath: indexPath) as! TimeTableCustomCell
        myCell.endOneTimeLabel.text = timeTableList[indexPath.row].endOneTime
        myCell.endTwoTimeLabel.text = timeTableList[indexPath.row].endTwoTime
        return myCell

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
