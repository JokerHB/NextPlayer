//
//  SongsTableViewController.swift
//  
//
//  Created by 靳洪博 on 16/3/20.
//
//

import UIKit
import KGFloatingDrawer
import KVNProgress

class SongsTableViewController: UITableViewController, HttpProtocol {
    var infoGetFromHttp = HttpController()
    
    var imageCache = Dictionary<String, UIImage>()
    
    var tableData = NSMutableArray()
    
    var palyer = NextPlayerMediaPlayer.playerInstance
    
    var count_data = 1
    
    var count_image = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoGetFromHttp.delegate = self
        
        // MARK: Gesture - slip
        //右划
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipeGesture(_:)))
        self.view.addGestureRecognizer(swipeGesture)
        //左划
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipeGesture(_:)))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
        self.view.addGestureRecognizer(swipeLeftGesture)


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
        return self.tableData.count + 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
             let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "SongCell")
            
             cell.textLabel?.text = "随机歌曲列表"
             cell.textLabel?.textColor = UIColor.blueColor()
            
             return cell
        } else {
            let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "SongCell")
            let arrayData = self.tableData[indexPath.row - 1] as! NSArray
            let rowData = arrayData[0] as! NSDictionary
            let url = rowData["picture"] as! String
            let imgUrl = NSURL(string: url)
            let request = NSURLRequest(URL: imgUrl!)
            
            //        cell.imageView?.image = UIImage(named: "test")
            
            //        if let image = self.imageCache[url] {
            //            cell.imageView?.image = image
            //        } else {
            //            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            //
            //                if let _data = data {
            //                    let img = UIImage(data: _data)
            //
            //                    self.imageCache[url] = img
            //                    cell.imageView?.image = img
            //                } else {
            //                    cell.imageView?.image = UIImage(named: "test")
            //                }
            //            })
            //        }
            
            cell.textLabel?.text = rowData["title"] as? String
            cell.detailTextLabel?.text = rowData["artist"] as? String
            
            return cell

        }
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("select \(indexPath.row)")
        self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
        
        if indexPath.row != 0 {
            let rowData = (self.tableData[indexPath.row - 1] as! NSArray)[0] as! NSDictionary
            let url = rowData["url"] as! String
            
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.drawerViewController.closeDrawer(KGDrawerSide.Left, animated: true, complete: {(finished: Bool) -> Void in
                let centerView = appDelegate.drawerViewController.centerViewController as! ViewController
                let songData = rowData
                let url_pic = songData["picture"] as! String
                let imgUrl = NSURL(string: url_pic)
                let request = NSURLRequest(URL: imgUrl!)
                
                if let image = self.imageCache[url_pic] {
                    centerView.onSetImage(image)
                } else {
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                        
                        if let _data = data {
                            let img = UIImage(data: _data)
                            
                            self.imageCache[url_pic] = img
                            centerView.onSetImage(img!)
                            
                        } else {
                            centerView.mVisualEffectView.image = UIImage(named: "back")
                        }
                    })
                }
                centerView.mAlbumView.startRotating()
                centerView.mAlbumView.pauseRotating()
                centerView.mAlbumView.resumeRotating()
                centerView.onSetPlay()
            })
            
            self.palyer.startPlaying(WorkMode.FM, url: url)
        }
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        
        UIView.animateWithDuration(0.25, animations: {() -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    
    func didReceiveResults(results: NSDictionary?) {
        if let _results = results {
            if let _songData = _results["song"] as? NSArray {
                self.tableData.addObject(_songData)
                
                let songData = _songData[0] as! NSDictionary
                let url_pic = songData["picture"] as! String
                let imgUrl = NSURL(string: url_pic)
                let request = NSURLRequest(URL: imgUrl!)
                
//                if nil == self.imageCache[url_pic] {
//                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
//                        
//                        if let _data = data {
//                            let img = UIImage(data: _data)
//                            
//                            self.count_image += 1
//                            self.imageCache[url_pic] = img
//                            
//                            self.tableView.reloadData()
//                        }
//                    })
//                }
                self.count_data += 1
                
                if self.count_data == 20 {
                    self.count_data = 1
                    KVNProgress.dismiss()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func handleSwipeGesture(sender: UISwipeGestureRecognizer){
        //划动的方向
        let direction = sender.direction
        //判断是上下左右
        switch (direction){
        case UISwipeGestureRecognizerDirection.Left:
//            print("Left")
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.drawerViewController.closeDrawer(KGDrawerSide.Left, animated: true, complete: {(finished: Bool) -> Void in
                
            })
            
            break
        case UISwipeGestureRecognizerDirection.Right:
//            print("Right")
            break
        default:
            break;
        }
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
