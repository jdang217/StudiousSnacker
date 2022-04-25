//
//  Photo.swift
//  StudiousSnackers
//
//  Created by Catalina Lemus on 4/24/22.
//  Copyright © 2022 Jason Dang, Catalina Lemus, and Fariha Rafa. All rights reserved.
//

import Foundation
import CoreData

// ✳️ Core Data Photo Entity public class
public class Photo: NSManagedObject, Identifiable {

    // Attribute
    @NSManaged public var url: String?
    
    // Relationship
    @NSManaged public var restaurant: Restaurant?
}
