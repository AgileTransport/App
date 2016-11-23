//
//  MapViewController.swift
//  ProjectTransport
//
//  Created by Mark Mekker on 23/11/2016.
//  Copyright © 2016 Mark Mekker. All rights reserved.
//
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapWidget: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
