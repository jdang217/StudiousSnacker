//
//  Hours.swift
//  StudiousSnackers
//
//  Created by Catalina Lemus on 4/24/22.
//  Copyright © 2022 Jason Dang, Catalina Lemus, and Fariha Rafa. All rights reserved.
//

import Foundation
import CoreData

// ❎ Core Data Location entity public class
public class Hours: NSManagedObject, Identifiable {

    // Attributes
    @NSManaged public var monday: String?
    @NSManaged public var tuesday: String?
    @NSManaged public var wednesday: String?
    @NSManaged public var thursday: String?
    @NSManaged public var friday: String?
    @NSManaged public var saturday: String?
    @NSManaged public var sunday: String?
    
    // Relationship
    @NSManaged public var restaurant: Restaurant?
}
