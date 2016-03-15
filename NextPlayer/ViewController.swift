//
//  ViewController.swift
//  NextPlayer
//
//  Created by 靳洪博 on 16/3/11.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit
import KVNProgress

class ViewController: UIViewController {
    @IBOutlet weak var mAlbumView: NextPlayerRadioImageView!

    @IBOutlet weak var mVisualEffectView: UIImageView!
    
    var isPause: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
}

