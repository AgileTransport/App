//
//  SecondViewController.swift
//  ProjectTransport
//
//  Created by Mark Mekker on 23/11/2016.
//  Copyright © 2016 Mark Mekker. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , UISearchResultsUpdating, ShowDetailDelegate  {

    var busLines = [BusLine]()
    var filteredBusLines = [BusLine]()
    
    @IBOutlet var tableViewWidget: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewWidget.dataSource = self
        tableViewWidget.delegate = self
        loadLines()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableViewWidget.tableHeaderView = searchController.searchBar
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredBusLines = busLines.filter { line in
            return line.id.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableViewWidget.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredBusLines.count
        }
        return  busLines.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0; // space b/w cells
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.whiteColor()
        return headerView
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let myCell:UITableViewCell = tableViewWidget.dequeueReusableCellWithIdentifier("prototype1",
            forIndexPath: indexPath)
        var line:BusLine
        if searchController.active && searchController.searchBar.text != "" {
            line = filteredBusLines[indexPath.section]
        } else {
            line = busLines[indexPath.section]
        }
        
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
        cell.backgroundColor = UIColor.clearColor()
        cell.layer.borderColor = UIColor.clearColor().CGColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            
            if segue.identifier == "ShowTimeTable" {
                // 2
                let navigationController = segue.destinationViewController
                    as! UINavigationController
                // 3
                let controller = navigationController.topViewController
                    as! TimeTableViewController
                // 4
                controller.delegate = self
                
                
                if let indexPath = tableViewWidget.indexPathForCell(
                    sender as! UITableViewCell) {
                        
                        var line:BusLine
                        if searchController.active && searchController.searchBar.text != "" {
                            line = filteredBusLines[indexPath.section]
                        } else {
                            line = busLines[indexPath.section]
                        }
                        controller.line = line                }
            }
    }
    
}

