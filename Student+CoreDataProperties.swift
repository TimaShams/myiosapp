//
//  Student+CoreDataProperties.swift
//  
//
//  Created by MacBook Pro on 21/10/20.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var age: Int32
    @NSManaged public var course: String?
    @NSManaged public var fname: String?
    @NSManaged public var gender: String?
    @NSManaged public var id: Int32
    @NSManaged public var lat: Double
    @NSManaged public var lname: String?
    @NSManaged public var long: Double
    @NSManaged public var examItems: NSSet?

}

// MARK: Generated accessors for examItems
extension Student {

    @objc(addExamItemsObject:)
    @NSManaged public func addToExamItems(_ value: Exam)

    @objc(removeExamItemsObject:)
    @NSManaged public func removeFromExamItems(_ value: Exam)

    @objc(addExamItems:)
    @NSManaged public func addToExamItems(_ values: NSSet)

    @objc(removeExamItems:)
    @NSManaged public func removeFromExamItems(_ values: NSSet)

}
