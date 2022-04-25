//
//  RestaurantsData.swift
//  StudiousSnackers
//
//  Created by Catalina Lemus on 4/24/22.
//  Copyright © 2022 Jason Dang, Catalina Lemus, and Fariha Rafa. All rights reserved.
//

import SwiftUI
import CoreData

// Array of RestaurantStruct structs obtained from the JSON file
// for use only in this file to create the database
fileprivate var arrayOfRestaurantStructs = [RestaurantAPIStruct]()

public func createRestaurantsDatabase() {

    // ❎ Get object reference of Core Data managedObjectContext from the persistent container
    let managedObjectContext = PersistenceController.shared.persistentContainer.viewContext
    
    //----------------------------
    // ❎ Define the Fetch Request
    //----------------------------
    let fetchRequest = NSFetchRequest<Restaurant>(entityName: "Restaurant")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    var listOfAllRestaurantEntitiesInDatabase = [Restaurant]()
    
    do {
        //-----------------------------
        // ❎ Execute the Fetch Request
        //-----------------------------
        listOfAllRestaurantEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Database Creation Failed!")
        return
    }
    
    if listOfAllRestaurantEntitiesInDatabase.count > 0 {
        print("Database has already been created!")
        return
    }
    
    print("Database will be created!")
    
    arrayOfRestaurantStructs = decodeJsonFileIntoArrayOfStructs(fullFilename: "RestaurantsData.json", fileLocation: "Main Bundle")

    for aRestaurant in arrayOfRestaurantStructs {
        /*
         ===============================
         *   Restaurant Entity Creation   *
         ===============================
         */
        
        // 1️⃣ Create an instance of the Restaurant entity in managedObjectContext
        let restaurantEntity = Restaurant(context: managedObjectContext)
        
        // 2️⃣ Dress it up by specifying its attributes
        restaurantEntity.name = aRestaurant.name
        restaurantEntity.address = aRestaurant.address
        restaurantEntity.des_cription = aRestaurant.description
        restaurantEntity.phone = aRestaurant.phone
        restaurantEntity.price_level = aRestaurant.price
        restaurantEntity.rating = aRestaurant.rating as NSNumber
        restaurantEntity.websiteUrl = aRestaurant.websiteUrl
        
        // 3️⃣ Its relationship with another Entity is defined below
        
        /*
         ============================
         *   Photo Entity Creation   *
         ============================
         */
        
        // 1️⃣ Create an instance of the Logo Entity in managedObjectContext
        let photoEntity = Photo(context: managedObjectContext)
        
        // 2️⃣ Dress it up by specifying its attribute
        photoEntity.url = aRestaurant.photo.url
        
        // 3️⃣ Establish one-to-one relationship between Recipe and Photo
        restaurantEntity.photo = photoEntity      // A recipe can have only one photo
        photoEntity.restaurant = restaurantEntity     // A photo can belong to only one recipe
        /*
         ================================
         *   Hours Entity Creation   *
         ================================
         */
        
        // 1️⃣ Create an instance of the Location Entity in managedObjectContext
        let hoursEntity = Hours(context: managedObjectContext)
        
        // 2️⃣ Dress it up by specifying its attributes
        hoursEntity.monday = aRestaurant.hours.mon
        hoursEntity.tuesday = aRestaurant.hours.tue
        hoursEntity.wednesday = aRestaurant.hours.wed
        hoursEntity.thursday = aRestaurant.hours.thu
        hoursEntity.friday = aRestaurant.hours.fri
        hoursEntity.saturday = aRestaurant.hours.sat
        hoursEntity.sunday = aRestaurant.hours.sun
        
        // 3️⃣ Establish one-to-one relationship between Restaurant and Location
        restaurantEntity.hours = hoursEntity     // A restaurant can have only one location
        hoursEntity.restaurant = restaurantEntity      // A location can belong to only one restaurant
        
        /*
         ===============================
         *   Cuisine Entity Creation   *
         ===============================
         */
        
        for aCuisine in aRestaurant.cuisine {
            
            // 1️⃣ Create an instance of the Ingredient Entity in managedObjectContext
            let cuisineEntity = Cuisine(context: managedObjectContext)
            
            // 2️⃣ Dress it up by specifying its attributes
            cuisineEntity.name = aCuisine.name
            
            // 3️⃣ Establish one-to-many relationship between Recipe and Ingredient
            cuisineEntity.restaurants!.adding(restaurantEntity)
            restaurantEntity.cuisines!.adding(cuisineEntity)                // A restaurant can have many cuisines
        }
        /*
         ===============================
         *   Cuisine Entity Creation   *
         ===============================
         */
        
        for aDietaryRestriction in aRestaurant.dietary_restrictions {
            
            // 1️⃣ Create an instance of the Ingredient Entity in managedObjectContext
            let dietaryRestrictionEntity = DietaryRestrictions(context: managedObjectContext)
            
            // 2️⃣ Dress it up by specifying its attributes
            dietaryRestrictionEntity.name = aDietaryRestriction.name
            
            // 3️⃣ Establish one-to-many relationship between Recipe and Ingredient
            dietaryRestrictionEntity.restaurants!.adding(restaurantEntity)
            restaurantEntity.dietaryRestrictions!.adding(dietaryRestrictionEntity)                // A restaurant can have many cuisines
        }
        
        /*
         *************************************
         ❎ Save Changes to Core Data Database
         *************************************
         */
        
        // The saveContext() method is given in Persistence.
        PersistenceController.shared.saveContext()
        
    }   // End of for loop

}
