//
//  NetWork.swift
//  NextPlayer
//
//  Created by 靳洪博 on 16/3/20.
//  Copyright © 2016年 joker. All rights reserved.
//

import Foundation
import UIKit

protocol HttpProtocol {
    func didReceiveResults(results: NSDictionary?)
}

class HttpController: NSObject {
    var delegate: HttpProtocol?
    
    func onSearch(url: String) {
        let nsUrl = NSURL(string: url)
        let request = NSURLRequest(URL: nsUrl!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            do {
                if var _data = data {
                    let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(_data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    print(jsonResult)
                    self.delegate?.didReceiveResults(jsonResult)
                } else {
                    self.delegate?.didReceiveResults(nil)
                }
                
                } catch {
                    print(error)
            }
        })
    }
}