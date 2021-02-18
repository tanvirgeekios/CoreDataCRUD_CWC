//
//  Person+CoreDataProperties.swift
//  CoredataCWC
//
//  Created by MD Tanvir Alam on 17/2/21.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var nationality: String?

}

extension Person : Identifiable {

}
