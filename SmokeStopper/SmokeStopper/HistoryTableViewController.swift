//
//  HistoryTableViewController.swift
//  SmokeStopper
//
//  Created by Alexandre barbier on 06/03/16.
//  Copyright © 2016 Alexandre Barbier. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    private var displayDataSource : [smokeCount] = SmokeManagerSharedInstance.history.reverse()
    private let cellIdentifier = "Cell"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayDataSource.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let sCount = displayDataSource[indexPath.row]
        cell.textLabel!.text = "\(sCount.date)"
        cell.detailTextLabel!.text = "\(sCount.count)"
        if sCount.count < SmokeManagerSharedInstance.lastSmoke.maxSmokePerDay {
            cell.detailTextLabel?.textColor = .greenColor()
        }
        else {
            cell.detailTextLabel?.textColor = .redColor()
        }
        return cell
    }
    
    @IBAction func closeTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
