//
//  SettingViewController.swift
//  SmokeStopper
//
//  Created by Alexandre barbier on 05/03/16.
//  Copyright © 2016 Alexandre Barbier. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var intervalPicker: UIPickerView!
    
    @IBOutlet weak var maxTextField: UITextField!
    
    private var min = 0 {
        didSet {
            intervalPicker.selectRow(min, inComponent: 1, animated: true)
        }
    }
    private var hour = 0 {
        didSet {
            intervalPicker.selectRow(hour, inComponent: 0, animated: true)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        maxTextField.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let interval = SmokeManagerSharedInstance.lastSmoke.smokeInterval
        min = interval.min
        hour = interval.hour
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTouch(sender: AnyObject) {
        SmokeManagerSharedInstance.lastSmoke.smokeInterval = (hour,min)
        SmokeManagerSharedInstance.lastSmoke.maxSmokePerDay = Int(maxTextField.text!) != nil ? Int(maxTextField.text!)! : 0
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0 :
            return  24
        case 1 :
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0 :
            hour = row
            break
        case 1 :
            min = row
            break
        default:
            break
        }
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
}
