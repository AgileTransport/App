//
//  AlarmTableViewController.swift
//  ProjectTransport
//
//  Created by Lajos Pongracz on 1/29/17.
//  Copyright © 2017 Lajos Pongracz. All rights reserved.
//

import SwiftyJSON
import UIKit

class AlarmTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewWidget: UITableView!

    var busLines = [BusLine]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let myCell: AlarmTableCell = tableViewWidget.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as! AlarmTableCell
        //var line:BusLine
        //line = busLines[indexPath.section]
        
        //myCell.textLabel?.text = line.id
        
        //configureIconForBusLine(myCell, line: line)
        configureCellStyle(myCell)
        
        return myCell
        
    }
    
    func loadLines() {
        RestApiManager.sharedInstance.getLines { (json: JSON) in
            if let results = json.array {
                for entry in results {
                    self.busLines.append(BusLine(json: entry))
                }
                dispatch_async(dispatch_get_main_queue(),{
                    self.tableViewWidget!.reloadData()
                })
            }
        }
    }
    
    func configureIconForBusLine(cell: UITableViewCell, line: BusLine) {
        var image : UIImage!
        if(line.type == "bus"){
            image = UIImage(named:"ic_directions_bus_48pt")
        }else{
            image = UIImage(named:"ic_tram_48pt")
        }
        cell.imageView?.image = image
    }
    
    
    func configureCellStyle(cell: UITableViewCell) {
        /*cell.separatorInset = UIEdgeInsetsZero
         cell.layoutMargins = UIEdgeInsetsZero
         cell.separatorInset.left = 0*/
        cell.backgroundColor = UIColor.clearColor()
        cell.layer.borderColor = UIColor.clearColor().CGColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
    }
}
