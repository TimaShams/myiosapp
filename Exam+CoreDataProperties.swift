//
//  Exam+CoreDataProperties.swift
//  
//
//  Created by MacBook Pro on 21/10/20.
//
//

import Foundation
import CoreData


extension Exam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exam> {
        return NSFetchRequest<Exam>(entityName: "Exam")
    }

    @NSManaged public var date: Date?
    @NSManaged public var location: String?
    @NSManaged public var unit: String?
    @NSManaged public var id: Int32
    @NSManaged public var examee: Student?

}
