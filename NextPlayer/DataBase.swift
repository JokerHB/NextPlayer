//
//  DataBase.swift
//  NextPlayer
//
//  Created by 靳洪博 on 16/3/31.
//  Copyright © 2016年 joker. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataBase: NSObject {
    internal static let dataBaseInstence = DataBase()
    
    private override init() {
        super.init()
        print("data base init...")
    }
    
    func insertData(img_url: String!, song_url: String!, title: String, artist: String, img: NSData?, song_data: NSData?) {
        // get manager
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        
        // create song object
        let song = NSEntityDescription.insertNewObjectForEntityForName("Song",
                                                                       inManagedObjectContext: context) as! Song
        // modify the song object
        song.song_url = song_url
        song.img_url = img_url
        song.img = img
        song.song = song_data
        song.artist = artist
        song.title = title
        
        if self.searchSong("title") == nil {
            // save to the data base
            do {
                try context.save()
                print("save success")
            } catch {
                fatalError("cant not save: \(error)")
            }      
        }
        
    }
    
    func searchSong(song_title: String!) -> Song? {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        // search request
        fetchRequest.fetchLimit = 1
        fetchRequest.fetchOffset = 0
        
        let entity = NSEntityDescription.entityForName("Song", inManagedObjectContext: context)
        fetchRequest.entity = entity
        
        // search condition
        let predicate = NSPredicate(format: "title = '\(song_title)'")
        fetchRequest.predicate = predicate
        
        do {
            let fetchedRequest = try context.executeFetchRequest(fetchRequest)
            
            if fetchedRequest.count != 0 {
                return fetchedRequest[0] as? Song
            }
        } catch {
            fatalError("can not get ele in Song database")
        }
        
        return nil
    }
    
    func deleteSong(title: String!) {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        
        if let reslut = self.searchSong(title) {
            context.deleteObject(reslut)
        }
        
        // save to the data base
        do {
            try context.save()
            print("save success")
        } catch {
            fatalError("cant not save: \(error)")
        }
    }
    
    func getCount() -> Int {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let entity = NSEntityDescription.entityForName("Song", inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = entity
        fetchRequest.predicate = nil
        
        do {
            let fetchedRequest = try context.executeFetchRequest(fetchRequest)
                return fetchedRequest.count
            } catch {
            fatalError("can not get ele in Song database")
        }
        
        return 0
    }
    
    func getAllObjects() -> [Song]? {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let entity = NSEntityDescription.entityForName("Song", inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = entity
        fetchRequest.predicate = nil
        
        do {
            let fetchedRequest = try context.executeFetchRequest(fetchRequest)
            return fetchedRequest as? [Song]
        } catch {
            fatalError("can not get ele in Song database")
        }
        
        return nil
    }
}