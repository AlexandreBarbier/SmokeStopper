//
//  ViewController.swift
//  SmokeStopper
//
//  Created by Alexandre barbier on 05/03/16.
//  Copyright © 2016 Alexandre Barbier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var hourCountLabel: UILabel!
    
    private var timer : NSTimer!
    
    var counter = 0 {
        didSet {
            counterLabel.text = "\(counter)"
            if counter >= SmokeManagerSharedInstance.lastSmoke.maxSmokePerDay {
                counterLabel.textColor = .redColor()
            }
            else {
                counterLabel.textColor = .greenColor()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.rootController = self
        let r = SmokeManagerSharedInstance.history
        self.startTimer()
        for value in r  {
            let calendar = NSCalendar.currentCalendar()
            if calendar.compareDate(NSDate(), toDate: value.date, toUnitGranularity: NSCalendarUnit.Day) == NSComparisonResult.OrderedSame {
                counter = value.count
            }
        }
        counterLabel.text = "\(counter)"
    }
    
    func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }

    func updateTime() {
        let componentFormatter = NSDateComponentsFormatter()
        componentFormatter.unitsStyle = .Abbreviated
        componentFormatter.zeroFormattingBehavior = .DropAll
        let calendar = NSCalendar.currentCalendar()
        let last = SmokeManagerSharedInstance.lastSmoke
        if  calendar.compareDate(NSDate(), toDate: last.date, toUnitGranularity: NSCalendarUnit.Day) == NSComparisonResult.OrderedAscending {
            counter = 0
        }
        
        let interval = NSDate().timeIntervalSinceDate(SmokeManagerSharedInstance.lastSmoke.date)
        
        if let timeSince = componentFormatter.stringFromTimeInterval(interval) {
          
            let userInterval = SmokeManagerSharedInstance.lastSmoke.smokeInterval
            let date = NSDate(timeIntervalSince1970: interval)
           let components = NSCalendar.currentCalendar().components([.Day,.Hour,.Minute] , fromDate: date)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.hourCountLabel.text = "\(timeSince)"
                if components.hour - 1 < userInterval.hour  {
                    self.hourCountLabel.textColor = .redColor()
                }
                else if userInterval.hour == components.hour && components.minute < userInterval.min  {
                    self.hourCountLabel.textColor = .redColor()
                }
                else {
                    self.hourCountLabel.textColor = .greenColor()
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addButtontouch(sender: AnyObject) {
        counter++
        SmokeManagerSharedInstance.saveDay(counter)
        SmokeManagerSharedInstance.lastSmoke.date = NSDate()
        self.updateTime()
    }
}

