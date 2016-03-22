//
//  ViewController.swift
//  NextPlayer
//
//  Created by 靳洪博 on 16/3/11.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit
import KVNProgress
import KGFloatingDrawer
import MediaPlayer

class ViewController: UIViewController, HttpProtocol,ChannelProtocol, ProgressProtocol, UIActionSheetDelegate  {
    @IBOutlet weak var mAlbumView: NextPlayerRadioImageView!

    @IBOutlet weak var mVisualEffectView: UIImageView!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var cuttentTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    var infoGetFromHttp = HttpController()
    
    var tableData = NSArray()
    
    var channelData = NSArray()
    
    var imageCache = Dictionary<String, UIImage>()
    
    var lastSongURL: String?
    
    var needleImageView: UIImageView!
    
    var needleOrignTransfrom: CGAffineTransform!
    
    var player = NextPlayerMediaPlayer.playerInstance
    
    var isPause: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.player.delegate = self
        
        self.infoGetFromHttp.delegate = self
//        self.infoGetFromHttp.onSearch("https://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite")
        self.infoGetFromHttp.onSearch("https://douban.fm/j/app/radio/channels")
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        visualEffect.alpha = 0.88
        visualEffect.frame = UIScreen.mainScreen().bounds
        self.mVisualEffectView.image = UIImage(named: "back")
        self.mVisualEffectView.addSubview(visualEffect)
        
        // MARK: Needle 
        self.needleImageView = UIImageView(frame: CGRectMake(view.bounds.width / 2 - 50, view.bounds.height / 10, 96, 153))
        self.needleImageView.image = UIImage(named: "cm2_play_disc_needle")
        self.setArchorPoint(CGPoint(x: 0.25, y: 0.16), view: self.needleImageView)
        self.needleOrignTransfrom = self.needleImageView.transform
        self.view.addSubview(self.needleImageView)
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {() -> Void in
            self.needleImageView.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI / 5.0))
            
            }, completion: {(finish: Bool) -> Void in
                
        })
        
        // MARK: Gesture -add gesture action in radio image
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("radioTapped:"))
//        self.mAlbumView.userInteractionEnabled = true
//        self.mAlbumView.addGestureRecognizer(tapGestureRecognizer)
        self.mAlbumView.image = UIImage(named: "cm2_play_disc_fm_default")
//        self.mAlbumView.albumView?.image = UIImage(named: "test")
//        self.mAlbumView.startRotating()
//        self.isPause = false
        
        // MARK: progroess bar
        self.progressView.progress = 0.0
        self.progressView.progressTintColor = UIColor.whiteColor()
        self.progressView.trackTintColor = UIColor.blackColor()
        
        
        // MARK: Gesture - slip
        //右划
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        self.view.addGestureRecognizer(swipeGesture)
        //左划
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        // MARK: Golable NSNotification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getNextSong:", name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PlayMusic(sender: AnyObject) {
        if self.player.getState() == PlayState.PAUSING {
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {() -> Void in
                self.needleImageView.transform = self.needleOrignTransfrom
                
                }, completion: {(finish: Bool) -> Void in
                    
            })

            self.isPause = false
            self.mAlbumView.resumeRotating()
            self.player.resumePlaying()
        }
    }
    
    
    @IBAction func PauseMusic(sender: AnyObject) {
        if self.player.getState() == PlayState.PLAYING {
            
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {() -> Void in
                self.needleImageView.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI / 5.0))
                
                }, completion: {(finish: Bool) -> Void in
                    
            })

            self.isPause = true
            self.mAlbumView.pauseRotating()
            self.player.pausePlaying()
        }
    }
    
    func radioTapped(img: AnyObject){
        if self.isPause {
            self.isPause = false
            self.mAlbumView.resumeRotating()
        } else {
            self.isPause = true
            self.mAlbumView.pauseRotating()
        }
    }
    
    func handleSwipeGesture(sender: UISwipeGestureRecognizer){
        //划动的方向
        let direction = sender.direction
        //判断是上下左右
        switch (direction){
            case UISwipeGestureRecognizerDirection.Left:
                print("Left")
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.drawerViewController.toggleDrawer(KGDrawerSide.Right, animated: true) { (finished) -> Void in
                    
                    let typesView = appDelegate.drawerViewController.rightViewController as! TypesTableViewController
                    
                    if typesView.channelData.count == 0 {
                        typesView.channelData = self.channelData
                        typesView.tableView.reloadData()
                    }
                    
                    typesView.delegate = self
                    
                }
                
                break
            case UISwipeGestureRecognizerDirection.Right:
                print("Right")
            
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.drawerViewController.toggleDrawer(KGDrawerSide.Left, animated: true) { (finished) -> Void in
                    
                    let songsView = appDelegate.drawerViewController.leftViewController as! SongsTableViewController
                    
                    songsView.tableData = self.tableData as NSArray
                    songsView.imageCache = self.imageCache
                    songsView.tableView.reloadData()
            }
            default:
                break;
        }
    }
    
    func setArchorPoint(anchorPoint: CGPoint, view: UIView) {
        let tmpLayer = view.layer
        
        view.layer.anchorPoint = anchorPoint
        view.layer.position = tmpLayer.position
    }
    
    func onSetImage(img: UIImage) {
        self.mVisualEffectView.image = img
        self.mAlbumView.image = UIImage(named: "cm2_play_disc")
        self.mAlbumView.albumView?.image = img
    }

    func didReceiveResults(results: NSDictionary?) {
        if let _results = results {
            if let _channelData = _results["channels"] as? NSArray {
                self.channelData = _channelData
            }
            if let _songData = _results["song"] as? NSArray {
                self.tableData = _songData

                let songData = self.tableData[0] as! NSDictionary
                let url_pic = songData["picture"] as! String
                let imgUrl = NSURL(string: url_pic)
                let request = NSURLRequest(URL: imgUrl!)
                let url_song = songData["url"] as! String
                
                if let image = self.imageCache[url_pic] {
                    self.onSetImage(image)
                } else {
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                        
                        if let _data = data {
                            let img = UIImage(data: _data)
                            
                            self.imageCache[url_pic] = img
                            self.onSetImage(img!)
                            
                        } else {
                            self.mVisualEffectView.image = UIImage(named: "back")
                        }
                    })
                }
                
                self.player.startPlaying(WorkMode.FM, url: url_song)
                self.mAlbumView.startRotating()
                self.mAlbumView.pauseRotating()
                self.mAlbumView.resumeRotating()
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {() -> Void in
                    self.needleImageView.transform = self.needleOrignTransfrom
                    
                    }, completion: {(finish: Bool) -> Void in
                        
                })
            }
        }
    }
    
    func onChnageChannel(channel_id: String) {
        let url = "https://douban.fm/j/mine/playlist?type=n&\(channel_id)&from=mainsite"
//        print("channel id is \(channel_id)")
        self.lastSongURL = url
        self.infoGetFromHttp.onSearch(url)
        self.lastSongURL = url
    }
    
    func getNextSong(notification: NSNotification) {
        self.mAlbumView.pauseRotating()
        self.endTimeLabel.text = "--:--"
        self.cuttentTimeLabel.text = "--:--"
        if let _lastSongURL = self.lastSongURL {
            print("next song on search")
            self.infoGetFromHttp.onSearch(_lastSongURL)
        }
    }
    
    func updateProcess(currentTime: String, endTime: String, process: Float) {
        print("update process \(currentTime)    \(endTime)   \(process)")
        self.progressView.setProgress(process, animated: true)
        self.endTimeLabel.text = endTime
        self.cuttentTimeLabel.text = currentTime
    }
}

