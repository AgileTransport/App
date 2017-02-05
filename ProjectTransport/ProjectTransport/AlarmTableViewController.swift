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
    
    var editReminder: EKReminder?
    
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
                    editReminder = self.reminders[indexPath.row]
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
            print("add")
            
            let newReminder = EKReminder(eventStore: self.eventStore)
            newReminder.title = alarm.lineId+" "+alarm.name
            newReminder.calendar = self.eventStore.defaultCalendarForNewReminders()
            newReminder.completed = false
            let dueDateComponents = self.dateComponentFromNSDate(alarm.date)
            newReminder.dueDateComponents = dueDateComponents
            
            let rule = EKRecurrenceRule(recurrenceWithFrequency: .Weekly, interval: 1, daysOfTheWeek: getDayList(alarm), daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
            newReminder.recurrenceRules = [rule]
            
            do {
                try self.eventStore.saveReminder(newReminder, commit: true)
            }catch{
                print("Error creating and saving new reminder : \(error)")
            }

            loadReminders()
            tableViewWidget.reloadData()
            dismissViewControllerAnimated(true, completion: nil)

    }
    
    func dateComponentFromNSDate(date: NSDate)-> NSDateComponents{
        
        let calendarUnit: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        let dateComponents = NSCalendar.currentCalendar().components(calendarUnit, fromDate: date)
        return dateComponents
    }
    
    func getDayList(alarm: AlarmObject) -> [EKRecurrenceDayOfWeek] {
        
        var dayList: [EKRecurrenceDayOfWeek]
        dayList = []
        switch(alarm.frequency){
        case Frequencies.Monday:
            dayList.append( EKRecurrenceDayOfWeek(.Monday))
            break
        case Frequencies.Tuesday:
            dayList.append( EKRecurrenceDayOfWeek(.Tuesday))
            break
        case Frequencies.Wednesday:
            dayList.append( EKRecurrenceDayOfWeek(.Wednesday))
            break
        case Frequencies.Thursday:
            dayList.append( EKRecurrenceDayOfWeek(.Thursday))
            break
        case Frequencies.Friday:
            dayList.append( EKRecurrenceDayOfWeek(.Friday))
            break
        case Frequencies.Saturday:
            dayList.append( EKRecurrenceDayOfWeek(.Saturday))
            break
        case Frequencies.Sunday:
            dayList.append( EKRecurrenceDayOfWeek(.Sunday))
            break
        case Frequencies.Everyday:
            dayList.append( EKRecurrenceDayOfWeek(.Monday))
            dayList.append( EKRecurrenceDayOfWeek(.Tuesday))
            dayList.append( EKRecurrenceDayOfWeek(.Wednesday))
            dayList.append( EKRecurrenceDayOfWeek(.Thursday))
            dayList.append( EKRecurrenceDayOfWeek(.Friday))
            dayList.append( EKRecurrenceDayOfWeek(.Saturday))
            dayList.append( EKRecurrenceDayOfWeek(.Sunday))
            break
        case Frequencies.Weekend:
            dayList.append( EKRecurrenceDayOfWeek(.Saturday))
            dayList.append( EKRecurrenceDayOfWeek(.Sunday))
            break
        case Frequencies.Weekday:
            dayList.append( EKRecurrenceDayOfWeek(.Monday))
            dayList.append( EKRecurrenceDayOfWeek(.Tuesday))
            dayList.append( EKRecurrenceDayOfWeek(.Wednesday))
            dayList.append( EKRecurrenceDayOfWeek(.Thursday))
            dayList.append( EKRecurrenceDayOfWeek(.Friday))
            break
        }

        return dayList
    }
    
    
    func listDetailViewController(controller: AlarmDetailViewController,
        didFinishEditing alarm: AlarmObject){
            print("edit")
            if let remUp = self.editReminder{
                remUp.title = alarm.lineId+" "+alarm.name
                let dueDateComponents = self.dateComponentFromNSDate(alarm.date)
                remUp.dueDateComponents = dueDateComponents
                
                
                let rule = EKRecurrenceRule(recurrenceWithFrequency: .Weekly, interval: 1, daysOfTheWeek: getDayList(alarm), daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
                remUp.recurrenceRules = [rule]
                
                do {
                    try self.eventStore.saveReminder(remUp, commit: true)
                }catch{
                    print("Error creating and saving new reminder : \(error)")
                }
            }

            
            tableViewWidget.reloadData()
            dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            let reminder: EKReminder = reminders[indexPath.row]
            do{
                try eventStore.removeReminder(reminder, commit: true)
                self.reminders.removeAtIndex(indexPath.row)
                self.alarms.removeAtIndex(indexPath.row)
            }catch{
                print("An error occurred while removing the reminder from the Calendar database: \(error)")
            }
            tableView.reloadData()
        }
    }

}
