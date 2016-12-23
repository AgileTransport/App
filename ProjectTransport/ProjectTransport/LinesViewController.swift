//
//  SecondViewController.swift
//  ProjectTransport
//
//  Created by Mark Mekker on 23/11/2016.
//  Copyright © 2016 Mark Mekker. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    var busLines = [BusLine]()
    
    @IBOutlet var tableViewWidget: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewWidget.dataSource = self
        tableViewWidget.delegate = self
        loadLines()
        //tableViewWidget.separatorColor = UIColor.redColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return  busLines.count
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0; // space b/w cells
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.whiteColor()
        return headerView
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let myCell:UITableViewCell = tableViewWidget.dequeueReusableCellWithIdentifier("prototype1",
            forIndexPath: indexPath)
        
        let line = busLines[indexPath.row]
                myCell.textLabel?.text = line.id
        
        configureIconForBusLine(myCell, line: line)
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
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
    }
    
}

