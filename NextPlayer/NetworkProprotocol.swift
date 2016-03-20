//
//  NetworkProprotocol.swift
//  NextPlayer
//
//  Created by 靳洪博 on 16/3/20.
//  Copyright © 2016年 joker. All rights reserved.
//

import Foundation

protocol HttpProtocol {
    func didReceiveResults(results: NSDictionary?)
}

protocol ChannelProtocol {
    func onChnageChannel(channel_id: String)
}