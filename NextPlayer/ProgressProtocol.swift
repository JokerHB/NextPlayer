//
//  ProgressProtocol.swift
//  NextPlayer
//
//  Created by 靳洪博 on 16/3/22.
//  Copyright © 2016年 joker. All rights reserved.
//

import Foundation

protocol ProgressProtocol {
    func updateProcess(currentTime: String, endTime: String, process: Float)
}