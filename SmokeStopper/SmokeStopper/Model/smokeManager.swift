//
//  smokeManager.swift
//  SmokeStopper
//
//  Created by Alexandre barbier on 05/03/16.
//  Copyright © 2016 Alexandre Barbier. All rights reserved.
//

import UIKit

let SmokeManagerSharedInstance = smokeManager()

class smokeCount : NSObject, NSCoding {
    var date : NSDate = NSDate()
    var count : Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        count = aDecoder.decodeIntegerForKey("count")
        date = aDecoder.decodeObjectForKey("date") as! NSDate
    }
    
    override init() {
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeInteger(count, forKey: "count")
    }
}

class smokeManager: NSObject {
    
    struct coderKey {
        static let historyKey = "smokeHistory"
        static let lastSmokeDate = "lastSmokeDate"
        static let maxSmokePerDay = "maxSmokePerDay"
        static let intervalMin = "intervalMin"
        static let intervalHour = "intervalHour"
    }
    
    struct lastSmokeInfo {

        var date = NSDate() {
            didSet {
                NSUserDefaults().setObject(date, forKey: coderKey.lastSmokeDate)
            }
        }
        
        var maxSmokePerDay : Int {
            get {
                return NSUserDefaults().integerForKey(coderKey.maxSmokePerDay)
            }
            set {
                NSUserDefaults().setInteger(newValue, forKey: coderKey.maxSmokePerDay)
            }
        }
        
        var smokeInterval : (hour:Int, min:Int) {
            get {
                let min = NSUserDefaults().integerForKey(coderKey.intervalMin)
                let hour = NSUserDefaults().integerForKey(coderKey.intervalHour)
                return (hour,min)
            }
            set {
                NSUserDefaults().setInteger(newValue.min, forKey: coderKey.intervalMin)
                NSUserDefaults().setInteger(newValue.hour, forKey: coderKey.intervalHour)
            }
        }
    }
    
    var history = [smokeCount]()
    var lastSmoke = lastSmokeInfo()
    
    private override init() {
        super.init()
        let coder = NSUserDefaults()
        
        if let lSdate = coder.objectForKey(coderKey.lastSmokeDate) as? NSDate {
            lastSmoke.date =  lSdate
        }
        
        if let histo = coder.objectForKey(coderKey.historyKey) {
            let k = histo as! NSMutableArray
            for val in k {
                let sCount = NSKeyedUnarchiver.unarchiveObjectWithData(val as! NSData) as? smokeCount
                history.append(sCount!)
            }
        }
    }
    
    func saveDay(todayCount: Int) {
        let sCount = smokeCount()
        sCount.date = NSDate()
        sCount.count = todayCount
        let calendar = NSCalendar.currentCalendar()
        
        if let last = history.last where calendar.compareDate(NSDate(), toDate: last.date, toUnitGranularity: NSCalendarUnit.Day) == NSComparisonResult.OrderedSame {
            history.removeLast()
        }
        
        history.append(sCount)
        let coder = NSUserDefaults()
        let k = NSMutableArray()
        for val in history {
            k.addObject(NSKeyedArchiver.archivedDataWithRootObject(val))
        }
        coder.setObject(k, forKey: coderKey.historyKey)
    }
}
