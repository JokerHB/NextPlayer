//
//  NextPlayerMediaPlayer.swift
//  NextPlayer
//
//  Created by 靳洪博 on 16/3/15.
//  Copyright © 2016年 joker. All rights reserved.
//

import Foundation
import MediaPlayer
import AVKit

enum PlayState {
    case PLAYING
    case PAUSING
    case STOPING
}

enum WorkMode {
    case FM
    case LOCAL
}

class NextPlayerMediaPlayer: NSObject {
    // single patten
    internal static let playerInstance = NextPlayerMediaPlayer()
    
    private var audioPlayer = MPMoviePlayerController()
    private var playstate: PlayState?
    private var workmode: WorkMode?
    private var timer: NSTimer?
    private var currentTimeText = "--:--"
    private var endTimeText = "--:--"
    
    var delegate: ProgressProtocol?
    
    private override init() {
        super.init()
        
        print("NextPlayerMediaPlayer Object Created")
    }
    
    func getState() -> PlayState? {
        return self.playstate
    }
    
    func getMode() -> WorkMode? {
        return self.workmode
    }
    
    func getCurrentTimeText() -> String {
        return self.currentTimeText
    }
    
    func getEndTimeText() -> String {
        return self.endTimeText
    }
    
    func startPlaying(mode: WorkMode, url: String?) {
        if mode == WorkMode.FM {
            self.workmode = WorkMode.FM
            
            self.audioPlayer.stop()
            self.audioPlayer.contentURL = NSURL(string: url!)
            self.audioPlayer.play()
            
            self.playstate = PlayState.PLAYING
            
            self.timer?.invalidate()
            self.currentTimeText = "00:00"
            self.endTimeText = self.timerFormater(self.audioPlayer.duration)
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(NextPlayerMediaPlayer.updateTime), userInfo: nil, repeats: true)
            self.timer?.fire()
        } else {
            self.workmode = WorkMode.LOCAL
        }
    }
    
    func pausePlaying() {
        self.audioPlayer.pause()
        self.playstate = PlayState.PAUSING
        self.timer?.invalidate()
    }
    
    func resumePlaying() {
        self.audioPlayer.play()
        self.playstate = PlayState.PLAYING
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(NextPlayerMediaPlayer.updateTime), userInfo: nil, repeats: true)
        self.timer?.fire()
    }
    
    func stopPlaying() {
        self.audioPlayer.stop()
        self.playstate = PlayState.STOPING
    }
    
    func updateTime() {
        let c = self.audioPlayer.currentPlaybackTime
        let a = self.audioPlayer.duration
        
        if c > 0 {
            self.currentTimeText = self.timerFormater(c)
            self.endTimeText = self.timerFormater(a)
//            print(self.currentTimeText)
            self.delegate?.updateProcess(self.currentTimeText, endTime: self.endTimeText, process: Float(c) / Float(a))
        }
    }
    
    func timerFormater(time: Double) -> String {
        var format = "--:--"
        
        if time >= 3600.0 {
            format = "59:59"
        } else {
            let s = Int(time) % 60
            let m = Int(time) / 60
            
            if m < 10 {
                format = "0\(m):"
            } else {
                format = "\(m):"
            }
            
            if s < 10 {
                format += "0\(s)"
            } else {
                format += "\(s)"
            }
        }
//        print(format)
        return format
    }
}