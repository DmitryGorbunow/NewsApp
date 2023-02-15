//
//  News+CoreDataProperties.swift
//  intro-lab-DmitryGorbunow
//
//  Created by Dmitry Gorbunow on 2/4/23.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: String? 
    @NSManaged public var views: Int32
    @NSManaged public var sourse: String?

}

extension News : Identifiable {

}
