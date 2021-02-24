//
//  Labtest+CoreDataProperties.swift
//  mapview
//
//  Created by Karanveer singh on 2021-01-31.
//
//

import Foundation
import CoreData


extension Labtest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Labtest> {
        return NSFetchRequest<Labtest>(entityName: "Labtest")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?

}

extension Labtest : Identifiable {

}
