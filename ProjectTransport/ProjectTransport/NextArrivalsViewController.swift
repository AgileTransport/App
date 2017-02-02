//
//  NextArrivalsViewController.swift
//  ProjectTransport
//
//  Created by Lajos Pongracz on 29/01/2017.
//  Copyright © 2017 Lajos Pongracz. All rights reserved.
//

import SwiftyJSON
import UIKit

class NextArrivalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewWidget: UITableView!
    
    var busLines = [BusLine]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewWidget.dataSource = self
        tableViewWidget.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let myCell: NextArrivalTableCell = tableViewWidget.dequeueReusableCellWithIdentifier("nextArrivalCell", forIndexPath: indexPath) as! NextArrivalTableCell
        //var line:BusLine
        //line = busLines[indexPath.section]
        
        myCell.lineLabel?.text = "30"
        myCell.timeLabel?.text = "2 min."
        
        configureIconForBusLine(myCell)//, line: line)
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
    
    func configureIconForBusLine(cell: UITableViewCell){//, line: BusLine) {
        var image : UIImage!
        //if(line.type == "bus"){
            image = UIImage(named:"ic_directions_bus_48pt")
        //}else{
        //    image = UIImage(named:"ic_tram_48pt")
        //}
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

