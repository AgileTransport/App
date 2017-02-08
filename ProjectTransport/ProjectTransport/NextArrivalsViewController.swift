//
//  NextArrivalsViewController.swift
//  ProjectTransport
//
//  Created by Lajos Pongracz on 29/01/2017.
//  Copyright © 2017 Lajos Pongracz. All rights reserved.
//

import SwiftyJSON
import UIKit
import MapKit

class NextArrivalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var tableViewWidget: UITableView!
    
    @IBAction func refresh(sender: AnyObject) {
    }
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D!

    var arrivals = [ArrivalBus]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewWidget.dataSource = self
        tableViewWidget.delegate = self
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.requestAlwaysAuthorization()
        locManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        print(coord.latitude)
        print(coord.longitude)
        currentLocation = coord
        
        loadArrivals()
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrivals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let myCell: NextArrivalTableCell = tableViewWidget.dequeueReusableCellWithIdentifier("nextArrivalCell", forIndexPath: indexPath) as! NextArrivalTableCell
        let arrival: ArrivalBus = arrivals[indexPath.item]
        
        //myCell.lineLabel?.text = "30"
        //myCell.timeLabel?.text = "2 min."
        
        myCell.lineLabel?.text = arrival.line
        myCell.timeLabel?.text = arrival.time + " min."
        
        configureIconForBusLine(myCell)//, line: line)
        configureCellStyle(myCell)

        return myCell
        
    }
    
    func loadArrivals() {
        RestApiManager.sharedInstance.getArrivals( { (json: JSON) in
            if let results = json.array {
                self.arrivals.removeAll()

                for entry in results {
                    self.arrivals.append(ArrivalBus(json: entry))
                }
                dispatch_async(dispatch_get_main_queue(),{
                    self.tableViewWidget!.reloadData()
                })
            }
        }, latitude: "\(currentLocation.latitude)", longitude: "\(currentLocation.longitude)")
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

