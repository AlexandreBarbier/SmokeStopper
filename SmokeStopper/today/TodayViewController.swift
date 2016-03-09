//
//  TodayViewController.swift
//  today
//
//  Created by Alexandre barbier on 06/03/16.
//  Copyright © 2016 Alexandre Barbier. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        // Do any additional setup after loading the view from its nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        titleLabel.text = "today count : \(SmokeManagerTodaySharedInstance.lastSmoke.todayCount)"

        completionHandler(NCUpdateResult.NewData)
    }
    
    @IBAction func addTouch(sender: AnyObject) {
        SmokeManagerTodaySharedInstance.lastSmoke.date = NSDate()
        SmokeManagerTodaySharedInstance.lastSmoke.todayCount += 1
    }
}
