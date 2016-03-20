//
//  ViewController.swift
//  NextPlayer
//
//  Created by 靳洪博 on 16/3/11.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit
import KVNProgress

class ViewController: UIViewController, HttpProtocol, UIActionSheetDelegate  {
    @IBOutlet weak var mAlbumView: NextPlayerRadioImageView!

    @IBOutlet weak var mVisualEffectView: UIImageView!
    
    var infoGetFromHttp = HttpController()
    
    var isPause: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.infoGetFromHttp.delegate = self
        self.infoGetFromHttp.onSearch("https://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite")
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        visualEffect.alpha = 0.88
        visualEffect.frame = UIScreen.mainScreen().bounds
        
        self.mVisualEffectView.addSubview(visualEffect)
        
        // MARK: Gesture -add gesture action in radio image
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("radioTapped:"))
        self.mAlbumView.userInteractionEnabled = true
        self.mAlbumView.addGestureRecognizer(tapGestureRecognizer)
        
        self.mAlbumView.albumView?.image = UIImage(named: "test")
        self.mAlbumView.startRotating()
        self.isPause = false
        
        // MARK: Gesture - slip
        //右划
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        self.view.addGestureRecognizer(swipeGesture)
        //左划
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
        self.view.addGestureRecognizer(swipeLeftGesture)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            break
        case UISwipeGestureRecognizerDirection.Right:
            print("Right")
        default:
            break;
        }
    }

    func didReceiveResults(results: NSDictionary?) {
        
    }
}

