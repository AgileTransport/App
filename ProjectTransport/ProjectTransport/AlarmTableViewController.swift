//
//  AlarmTableViewController.swift
//  ProjectTransport
//
//  Created by Lajos Pongracz on 1/29/17.
//  Copyright © 2017 Lajos Pongracz. All rights reserved.
//

import SwiftyJSON
import UIKit
import EventKit

class AlarmTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DetailViewControllerDelegate {
    
    @IBOutlet weak var tableViewWidget: UITableView!

    var alarms = [AlarmObject]()
    
    var eventStore: EKEventStore!
    var reminders: [EKReminder]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewWidget.dataSource = self
        tableViewWidget.delegate = self

        // Do any additional setup after loading the view.
        eventStore = EKEventStore()
        reminders = [EKReminder]()
        loadReminders()
    }
    
    func loadReminders(){
        reminders = [EKReminder]()
        alarms = []
        self.eventStore.requestAccessToEntityType(EKEntityType.Reminder) { (granted: Bool, error: NSError?) -> Void in
            if granted{
                // 2
                let predicate = self.eventStore.predicateForRemindersInCalendars(nil)
                self.eventStore.fetchRemindersMatchingPredicate(predicate, completion: { (reminders: [EKReminder]?) -> Void in
                    
                    self.reminders = reminders
                    
                    for rem in self.reminders{
                        if let poz = rem.title.rangeOfString(" "){
                            var freq : Frequencies
                            freq = Frequencies.Monday
                            if let fr = rem.recurrenceRules?.first?.daysOfTheWeek {
                                if fr.count == 1 {
                                    switch(fr[0]){
                                    case EKRecurrenceDayOfWeek(.Monday):
                                        freq = Frequencies.Monday
                                        break
                                    case EKRecurrenceDayOfWeek(.Tuesday):
                                        freq = Frequencies.Tuesday
                                        break
                                    case EKRecurrenceDayOfWeek(.Wednesday):
                                        freq = Frequencies.Wednesday
                                        break
                                    case EKRecurrenceDayOfWeek(.Thursday):
                                        freq = Frequencies.Thursday
                                        break
                                    case EKRecurrenceDayOfWeek(.Friday):
                                        freq = Frequencies.Friday
                                        break
                                    case EKRecurrenceDayOfWeek(.Saturday):
                                        freq = Frequencies.Saturday
                                        break
                                    case EKRecurrenceDayOfWeek(.Sunday):
                                        freq = Frequencies.Sunday
                                        break
                                    default:
                                        break
                                    }
                                } else if fr.count == 2 {
                                    freq = Frequencies.Weekend
                                } else if fr.count == 5{
                                    freq = Frequencies.Weekday
                                } else if fr.count == 7{
                                    freq = Frequencies.Everyday
                                }
                            }
                            let alarmObj = AlarmObject(name: rem.title.substringFromIndex(poz.endIndex), frequency: freq, date: rem.dueDateComponents!.date!, lineId: rem.title.substringToIndex(poz.startIndex))
                            self.alarms.append(alarmObj)
                        }
                    }
                    self.tableViewWidget.reloadData()
                })
            }else{
                print("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
            }
        }
    }
    
    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        formatter.dateFormat = "hh:mm"
        return formatter
    }()
    
    func formatDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
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
        return alarms.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let myCell: AlarmTableCell = tableViewWidget.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as! AlarmTableCell
        
        myCell.lineNameLabel.text = alarms[indexPath.row].name
        myCell.alarmFrequencyLabel.text = alarms[indexPath.row].frequency.rawValue
        myCell.alarmTimeLabel.text = formatDate(alarms[indexPath.row].date)
        //var line:BusLine
        //line = busLines[indexPath.section]
        
        //myCell.textLabel?.text = line.id
        
        //configureIconForBusLine(myCell, line: line)
        configureCellStyle(myCell)
        
        return myCell
        
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
            
            if segue.identifier == "editAlarm" {
                // 2
                let navigationController = segue.destinationViewController
                    as! UINavigationController
                // 3
                let controller = navigationController.topViewController
                    as! AlarmDetailViewController
                // 4
                
                
                if let indexPath = tableViewWidget.indexPathForCell(
                    sender as! UITableViewCell) {
                    controller.currentAlarm = alarms[indexPath.row]
                }
                
                controller.delegate = self
            }
            if segue.identifier == "addAlarm"{
                // 2
                let navigationController = segue.destinationViewController
                    as! UINavigationController
                // 3
                let controller = navigationController.topViewController
                    as! AlarmDetailViewController
                // 4
                
                controller.delegate = self
            }
    }
    
    func listDetailViewController(controller: AlarmDetailViewController,
        didFinishAdding alarm: AlarmObject){
            alarms.append(alarm)
            tableViewWidget.reloadData()
            dismissViewControllerAnimated(true, completion: nil)

    }
    
    func listDetailViewController(controller: AlarmDetailViewController,
        didFinishEditing alarm: AlarmObject){
            tableViewWidget.reloadData()
            dismissViewControllerAnimated(true, completion: nil)

    }

}
