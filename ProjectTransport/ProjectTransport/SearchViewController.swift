//
//  SecondViewController.swift
//  ProjectTransport
//
//  Created by Mark Mekker on 23/11/2016.
//  Copyright © 2016 Mark Mekker. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource {

    let busNames = ["Line 1","Line 2","Line 3","Line 4","Line 5","Line 6","Line 7","Line 8","Line 9","Line 10"]
    
    @IBOutlet var tableViewWidget: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewWidget.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return  busNames.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let myCell:UITableViewCell = tableViewWidget.dequeueReusableCellWithIdentifier("prototype1",
            forIndexPath: indexPath)
        
        myCell.textLabel?.text = busNames[indexPath.row]
        myCell.imageView?.image = UIImage(named:"bus1")
        
        return myCell
        
    }


}

