//
//  Song+CoreDataProperties.swift
//  NextPlayer
//
//  Created by 靳洪博 on 16/3/31.
//  Copyright © 2016年 joker. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Song {

    @NSManaged var song_url: String?
    @NSManaged var img_url: String?
    @NSManaged var img: NSData?
    @NSManaged var song: NSData?
    @NSManaged var artist: String?
    @NSManaged var title: String?

}
