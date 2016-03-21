//
//  NextPlayerRadioImageView.swift
//  NextPlayer
//
//  Created by 靳洪博 on 16/3/11.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit

class NextPlayerRadioImageView: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    let WIDTH: CGFloat = 160
    let HETGHT: CGFloat = 160
    
    var albumView: UIImageView?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.albumView = UIImageView(frame: CGRectMake(self.frame.width / 2 - (self.WIDTH / 2), self.frame.height / 2 - (self.HETGHT / 2), self.WIDTH, self.HETGHT))
        self.albumView?.clipsToBounds = true
        self.albumView?.layer.cornerRadius = self.WIDTH / 2
        
        // MARK: albumView -debug test
        //self.albumView?.image = UIImage(named: "test")

        self.addSubview(self.albumView!)
    }
    
    func startRotating() {
        let rotateAni = CABasicAnimation(keyPath: "transform.rotation")
        
        rotateAni.fromValue = 0.0
        rotateAni.toValue = M_PI * 2.0
        rotateAni.duration = 20.0
        rotateAni.repeatCount = MAXFLOAT
        
        self.layer.addAnimation(rotateAni, forKey: nil)
    }
    
    func pauseRotating() {
        let pausedTime = self.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        
        self.layer.speed = 0.0
        self.layer.timeOffset = pausedTime
    }
    
    func resumeRotating() {
        // MARK resume time: the current should get when you need, can not get before you use
        let pausedTIme = self.layer.timeOffset
        
        self.layer.speed = 1.0
        self.layer.timeOffset = 0.0
        self.layer.beginTime = 0.0
        
        let timeSincePause = self.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTIme
        
        layer.beginTime = timeSincePause
    }
 }
