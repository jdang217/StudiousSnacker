//
//  Cuisine.swift
//  StudiousSnackers
//
//  Created by Catalina Lemus on 4/24/22.
//  Copyright © 2022 Jason Dang, Catalina Lemus, and Fariha Rafa. All rights reserved.
//

import Foundation
import CoreData

// ❎ Core Data Location entity public class
public class Cuisine: NSManagedObject, Identifiable {

    // Attributes
    @NSManaged public var name: String?
    
    // Relationship
    @NSManaged public var restaurants: NSSet?
}
