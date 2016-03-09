//
//  smokeManager.swift
//  SmokeStopper
//
//  Created by Alexandre barbier on 05/03/16.
//  Copyright © 2016 Alexandre Barbier. All rights reserved.
//

import UIKit

let SmokeManagerSharedInstance = smokeManager()
let SmokeManagerTodaySharedInstance = smokeManager(today:true)
let userDefault = NSUserDefaults(suiteName: "group.SmokeStopper")

class smokeCount : NSObject, NSCoding {
    var date : NSDate = NSDate()
    var count : Int = 0
    private struct coderKey {
        static let count = "count"
        static let date = "date"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        count = aDecoder.decodeIntegerForKey(coderKey.count)
        date = aDecoder.decodeObjectForKey(coderKey.date) as! NSDate
    }
    
    init(count:Int,date:NSDate) {
        super.init()
        self.count = count
        self.date = date
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: coderKey.date)
        aCoder.encodeInteger(count, forKey: coderKey.count)
    }
}

class smokeManager: NSObject {
    
    struct userDefaultKey {
        static let historyKey = "smokeHistory"
        static let lastSmokeDate = "lastSmokeDate"
        static let maxSmokePerDay = "maxSmokePerDay"
        static let intervalMin = "intervalMin"
        static let intervalHour = "intervalHour"
        static let todayCount = "todayCount"
    }
    
    struct lastSmokeInfo {
        var date = NSDate() {
            didSet {
                smokeManager.save(date, key: userDefaultKey.lastSmokeDate)
            }
        }
        
        var todayCount: Int {
            get {
                return userDefault!.integerForKey(userDefaultKey.todayCount)
            }
            set {
                smokeManager.saveInteger(newValue, key: userDefaultKey.todayCount)
            }
        }
        
        var maxSmokePerDay : Int {
            get {
                return userDefault!.integerForKey(userDefaultKey.maxSmokePerDay)
            }
            set {
                smokeManager.saveInteger(newValue, key: userDefaultKey.maxSmokePerDay)
            }
        }
        
        var smokeInterval : (hour:Int, min:Int) {
            get {
                let min = userDefault!.integerForKey(userDefaultKey.intervalMin)
                let hour = userDefault!.integerForKey(userDefaultKey.intervalHour)
                return (hour,min)
            }
            set {
                smokeManager.saveInteger(newValue.min, key: userDefaultKey.intervalMin)
                smokeManager.saveInteger(newValue.hour, key: userDefaultKey.intervalHour)
            }
        }
    }
    
    var history = [smokeCount]()
    var lastSmoke = lastSmokeInfo()
    
    private init(today:Bool) {
        let coder = userDefault!
        if let lSdate = coder.objectForKey(userDefaultKey.lastSmokeDate) as? NSDate {
            lastSmoke.date =  lSdate
        }
    }
    
    private override init() {
        super.init()
        let coder = userDefault!
        
        if let lSdate = coder.objectForKey(userDefaultKey.lastSmokeDate) as? NSDate {
            lastSmoke.date =  lSdate
        }
        
        if let histo = coder.objectForKey(userDefaultKey.historyKey) {
            let k = histo as! NSMutableArray
            for val in k {
                let sCount = NSKeyedUnarchiver.unarchiveObjectWithData(val as! NSData) as? smokeCount
                history.append(sCount!)
            }
        }
        if let _ = history.last {
            history.last!.count = lastSmoke.todayCount
        }
    }
    
    func saveDay(todayCount: Int) {
        let sCount = smokeCount(count: todayCount, date: NSDate())
        let calendar = NSCalendar.currentCalendar()
        lastSmoke.todayCount = todayCount
    
        if let last = history.last where calendar.compareDate(NSDate(), toDate: last.date, toUnitGranularity: NSCalendarUnit.Day) == NSComparisonResult.OrderedSame {
            history.removeLast()
        }

        history.append(sCount)
        let k = NSMutableArray()
        for val in history {
            k.addObject(NSKeyedArchiver.archivedDataWithRootObject(val))
        }
        smokeManager.save(k, key: userDefaultKey.historyKey)
    }
    
    private class func save(object:AnyObject, key:String) {
        userDefault!.setObject(object, forKey: key)
        userDefault!.synchronize()
    }
    
    private class func saveInteger(object:Int, key:String) {
        userDefault!.setInteger(object, forKey: key)
        userDefault!.synchronize()
    }
}
