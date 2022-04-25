//
//  Restaurant.swift
//  StudiousSnackers
//
//  Created by Catalina Lemus on 4/24/22.
//  Copyright © 2022 Jason Dang, Catalina Lemus, and Fariha Rafa. All rights reserved.
//

import Foundation
import CoreData

// ❎ Core Data Company entity public class
public class Restaurant: NSManagedObject, Identifiable {

    // Attributes
    @NSManaged public var name: String?
    @NSManaged public var address: String?
    @NSManaged public var des_cription: String?
    @NSManaged public var phone: String?
    @NSManaged public var price_level: String?
    @NSManaged public var rating: NSNumber?
    @NSManaged public var websiteUrl: String?
    
    // Relationships
    @NSManaged public var cuisines: NSSet?
    @NSManaged public var dietaryRestrictions: NSSet?
    @NSManaged public var hours: Hours?
    @NSManaged public var photo: Photo?
}

extension Restaurant {
    /*
     ❎ CoreData @FetchRequest in FavoritesList.swift invokes this class method
        to fetch all of the Company entities from the database.
        The 'static' keyword designates the func as a class method invoked by using the
        class name as Company.allCompaniesFetchRequest() in any .swift file in your project.
     */
    static func allRestaurantsFetchRequest() -> NSFetchRequest<Restaurant> {
        /*
         Create a fetchRequest to fetch Company entities from the database.
         Since the fetchRequest's 'predicate' property is not set to filter,
         all of the Company entities will be fetched.
         */
        let fetchRequest = NSFetchRequest<Restaurant>(entityName: "Restaurant")
        /*
         List the fetched companies in alphabetical order with respect to company name.
         */
        fetchRequest.sortDescriptors = [
            // Sort key: company name
            NSSortDescriptor(key: "name", ascending: true),
        ]
        
        return fetchRequest
    }

}

