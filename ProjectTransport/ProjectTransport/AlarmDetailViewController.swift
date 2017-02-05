//
//  AlarmDetailViewController.swift
//  ProjectTransport
//
//  Created by Mark Mekker on 05/02/2017.
//  Copyright © 2017 Mark Mekker. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol DetailViewControllerDelegate: class {
    func listDetailViewController(controller: AlarmDetailViewController,
        didFinishAdding alarm: AlarmObject)
    func listDetailViewController(controller: AlarmDetailViewController,
        didFinishEditing alarm: AlarmObject)
}

class AlarmDetailViewController:UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var alarmNameTextFIeld: UITextField!
    @IBOutlet weak var frequencyPickerView: UIPickerView!
    @IBOutlet weak var dateTimeControl: UIDatePicker!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var currentAlarm:AlarmObject!
    var delegate: DetailViewControllerDelegate!
    var busLines = [BusLine]()
    var selectedFrequencyIndex = 0
    var selectedLineIndex = 0
    
    let pickerData = [Frequencies.Everyday, Frequencies.Weekend, Frequencies.Weekday, Frequencies.Sunday, Frequencies.Monday, Frequencies.Tuesday, Frequencies.Wednesday, Frequencies.Thursday, Frequencies.Friday, Frequencies.Saturday]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLines()
        frequencyPickerView.dataSource = self;
        frequencyPickerView.delegate = self;
    }
    
    func getLineIndex(lineId:String)->Int!{
        var i = 0
        while (i < busLines.count){
            if(busLines[i].id == lineId){
                return i;
            }
            i = i+1;
        }
        return nil
    }
    
    override func viewWillAppear(animated: Bool) {
        if let alarm = currentAlarm {
            title = "Edit Alarm"
            alarmNameTextFIeld.text = alarm.name
            doneBarButton.enabled = true
            reloadPickerView()
            //frequencyPickerView.select(alarm.frequency.rawValue)
            dateTimeControl.setDate(alarm.date, animated: true)
            
        }
    }
    
    @IBAction func back(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(){
        if let alarm = currentAlarm {
            alarm.name = alarmNameTextFIeld.text!
            alarm.frequency = pickerData[selectedFrequencyIndex]
            alarm.date = dateTimeControl.date
            alarm.lineId = busLines[self.selectedLineIndex].id
            delegate?.listDetailViewController(self , didFinishEditing: alarm)
        } else {
            let alarm = AlarmObject()
            alarm.name = alarmNameTextFIeld.text!
            alarm.frequency = pickerData[selectedFrequencyIndex]
            alarm.date = dateTimeControl.date
            alarm.lineId = busLines[self.selectedLineIndex].id
            delegate?.listDetailViewController(self,
                didFinishAdding: alarm)
        }
    }
    
    
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 1){
            return pickerData[row].rawValue
        }else{
            return busLines[row].id
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 1){
            selectedFrequencyIndex = row
        }else{
            selectedLineIndex = row
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(component == 1){
            return pickerData.count
        }else{
            return busLines.count
        }
    }

    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            let oldText: NSString = textField.text!
            let newText: NSString = oldText.stringByReplacingCharactersInRange(
                range, withString: string)
            doneBarButton.enabled = (newText.length > 0)
            return true
    }
    func reloadPickerView(){
        if let alarm = currentAlarm {
            let index = pickerData.indexOf(alarm.frequency)
            if (index != nil){
                frequencyPickerView.selectRow(index!, inComponent: 1, animated: true)
                //frequencyPickerView.selectRow(index!, inComponent: 1, animated: true)
            }
            let index2 = getLineIndex(alarm.lineId)
            if (index2 != nil){
                frequencyPickerView.selectRow(index2!, inComponent: 0, animated: true)
                //frequencyPickerView.selectRow(index!, inComponent: 1, animated: true)
            }
        }
    }
    
    func loadLines() {
        RestApiManager.sharedInstance.getLines { (json: JSON) in
            if let results = json.array {
                for entry in results {
                    self.busLines.append(BusLine(json: entry))
                }
                dispatch_async(dispatch_get_main_queue(),{
                    
                    self.frequencyPickerView!.reloadAllComponents()
                    self.reloadPickerView()
                    
                })
            }
        }
    }
    
}