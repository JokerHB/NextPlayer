//
//  TypesTableViewController.swift
//  NextPlayer
//
//  Created by 靳洪博 on 16/3/20.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit
import KGFloatingDrawer

class TypesTableViewController: UITableViewController {
    
    var channelData = NSArray()
    
    var delegate: ChannelProtocol?
    
    var player = NextPlayerMediaPlayer.playerInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.channelData.count
//        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TypesCell")
        let rowData = self.channelData[indexPath.row] as! NSDictionary
        
        cell.textLabel?.text = rowData["name"] as? String
        
        print("row data \(rowData)")
        
        return cell
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        
        UIView.animateWithDuration(0.25, animations: {() -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("select \(indexPath.row)")
        let rowData = self.channelData[indexPath.row] as! NSDictionary
        let channel_id = rowData["channel_id"]! as AnyObject
        let channel = "channel=\(channel_id)"
        
        self.delegate?.onChnageChannel(channel)
        
        self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.drawerViewController.closeDrawer(KGDrawerSide.Right, animated: true, complete: {(finished: Bool) -> Void in
            // do sth
        })

    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
