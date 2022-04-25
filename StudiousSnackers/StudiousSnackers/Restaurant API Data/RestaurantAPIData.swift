//
//  RestaurantAPIData.swift
//  StudiousSnackers
//
//  Created by Jason Dang on 4/20/22.
//

import Foundation
import SwiftUI


// Global array of API Restaurant structs
var foundRestaurantsList = [RestaurantAPIStruct]()

fileprivate var previousQuery = ""


/*
***********************************************
MARK: Decode JSON response into restaurant info
***********************************************
*/
public func obtainRestaurantListFromApi() {
    
    //let API_KEY = "39ef792f12mshb0c36329109d63ap107173jsna4dd94bb6381"
    let API_KEY = "26af79df11msh44662954478a127p1d8159jsna95936d408a5"
    
    let BLACKSBURG_ID = 57513
    
    let apiQueryUrl = "https://worldwide-restaurants.p.rapidapi.com/search"
    /*
    **************************************
    *   Obtaining API Query URL Struct   *
    **************************************
    */
    
    var apiQueryUrlStruct: URL?
    
    if let urlStruct = URL(string: apiQueryUrl) {
        apiQueryUrlStruct = urlStruct
    } else {
        return
    }
    
    /*
     *******************************
     *   HTTP POST Request Set Up   *
     *******************************
     */
    
    let headers = [
        "accept": "application/json",
        "cache-control": "no-cache",
        "content-type": "application/x-www-form-urlencoded",
        "X-RapidAPI-Host": "worldwide-restaurants.p.rapidapi.com",
        "X-RapidAPI-Key": API_KEY
    ]
    
    let postData = NSMutableData(data: "language=en_US".data(using: String.Encoding.utf8)!)
    postData.append("&limit=30".data(using: String.Encoding.utf8)!)
    postData.append("&location_id=\(BLACKSBURG_ID)".data(using: String.Encoding.utf8)!)
    postData.append("&currency=USD".data(using: String.Encoding.utf8)!)
    
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData as Data
    
    /*
     *********************************************************************
     *  Setting Up a URL Session to Fetch the JSON File from the API     *
     *  in an Asynchronous Manner and Processing the Received JSON File  *
     *********************************************************************
     */
    
    /*
     Create a semaphore to control getting and processing API data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
    
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
         URLSession is established and the JSON file from the API is set to be fetched
         in an asynchronous manner. After the file is fetched, data, response, error
         are returned as the input parameter values of this Completion Handler Closure.
         */
        
        // Process input parameter 'error'
        guard error == nil else {
            semaphore.signal()
            return
        }
        
        /*
         ---------------------------------------------------------
         🔴 Any 'return' used within the completionHandler Closure
         exits the Closure; not the public function it is in.
         ---------------------------------------------------------
         */
        
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            //IF RESPONSE = 429, swap to another api key
            print(response)
            semaphore.signal()
            return
        }
        
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
            semaphore.signal()
            return
        }
        
        //------------------------------------------------
        // JSON data is obtained from the API. Process it.
        //------------------------------------------------
        do {
            /*
             Foundation framework’s JSONSerialization class is used to convert JSON data
             into Swift data types such as Dictionary, Array, String, Number, or Bool.
             */
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                   options: JSONSerialization.ReadingOptions.mutableContainers)
            
            //----------------------------
            // Obtain Top Level Dictionary
            //----------------------------
            var topLevelDictionary = Dictionary<String, Any>()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                topLevelDictionary = jsonObject
            } else {
                return
            }
            
            //------------------------------------
            // Obtain dictionary of "results" JSON Objects
            //------------------------------------
            var resultsDictionary = Dictionary<String, Any>()
            
            if let jsonObject = topLevelDictionary["results"] as? [String: Any] {
                resultsDictionary = jsonObject
            } else {
                return
            }
            
            //------------------------------------
            // Obtain Array of "data" JSON Objects
            //------------------------------------
            var arrayOfDataJsonObjects = Array<Any>()
            
            if let jsonArray = resultsDictionary["data"] as? [Any] {
                arrayOfDataJsonObjects = jsonArray
            } else {
                return
            }
            
            for index in 0..<arrayOfDataJsonObjects.count {
                //-------------------------
                // Obtain restaurant Dictionary
                //-------------------------
                var restaurantDictionary = Dictionary<String, Any>()
                
                if let jsonDictionary = arrayOfDataJsonObjects[index] as? [String: Any] {
                    restaurantDictionary = jsonDictionary
                } else {
                    return
                }
                
                                
                let location_id = (restaurantDictionary["location_id"] as! NSString).intValue
                let name = restaurantDictionary["name"] ?? ""
                let latitude = (restaurantDictionary["latitude"] as! NSString).doubleValue
                let longitude = (restaurantDictionary["longitude"]as! NSString).doubleValue
                let rating = (restaurantDictionary["rating"] as! NSString).doubleValue
                let price = restaurantDictionary["price_level"] ?? ""
                let description = restaurantDictionary["description"] ?? ""
                let phone = restaurantDictionary["phone"] ?? ""
                let websiteUrl = restaurantDictionary["website"] ?? ""
                let address = restaurantDictionary["address"] ?? ""
                
                
                
                var hours = HoursStruct(mon: "", tue: "", wed: "", thu: "", fri: "", sat: "", sun: "")
                //------------------------------------
                // Obtain dictionary of "hours" JSON Objects
                //------------------------------------
                var hoursDictionary = Dictionary<String, Any>()
                
                if let jsonObject = restaurantDictionary["hours"] as? [String: Any] {
                    hoursDictionary = jsonObject
                } else {
                    return
                }
                //------------------------------------
                // Obtain Array of "week_ranges" JSON Objects
                //------------------------------------
                var arrayOfWeekRangesJsonObjects = Array<Any>()
                
                if let jsonArray = hoursDictionary["week_ranges"] as? [Any] {
                    arrayOfWeekRangesJsonObjects = jsonArray
                } else {
                    return
                }
                for index in 0..<arrayOfWeekRangesJsonObjects.count {
                    //------------------------------------
                    // Obtain Array of "currentday" JSON Objects
                    //------------------------------------
                    var currentDay = Array<Any>()
                    
                    if let jsonArray = arrayOfWeekRangesJsonObjects[index] as? [Any] {
                        currentDay = jsonArray
                    } else {
                        return
                    }
                    //-------------------------
                    // Obtain Open and Close Dictionary
                    //-------------------------
                    var openAndCloseDictionary = Dictionary<String, Any>()
                    let isIndexValid = currentDay.indices.contains(0)
                    if(!isIndexValid) {continue}
                    
                    if let jsonDictionary = currentDay[0] as? [String: Any] {
                        openAndCloseDictionary = jsonDictionary
                    } else {
                        return
                    }
                    
                    switch index {
                    case 0:
                        hours.mon = "\(openAndCloseDictionary["open_time"] ?? "")-\(openAndCloseDictionary["close_time"] ?? "")"
                    case 1:
                        hours.tue = "\(openAndCloseDictionary["open_time"] ?? "")-\(openAndCloseDictionary["close_time"] ?? "")"
                    case 2:
                        hours.wed = "\(openAndCloseDictionary["open_time"] ?? "")-\(openAndCloseDictionary["close_time"] ?? "")"
                    case 3:
                        hours.thu = "\(openAndCloseDictionary["open_time"] ?? "")-\(openAndCloseDictionary["close_time"] ?? "")"
                    case 4:
                        hours.fri = "\(openAndCloseDictionary["open_time"] ?? "")-\(openAndCloseDictionary["close_time"] ?? "")"
                    case 5:
                        hours.sat = "\(openAndCloseDictionary["open_time"] ?? "")-\(openAndCloseDictionary["close_time"] ?? "")"
                    case 6:
                        hours.sun = "\(openAndCloseDictionary["open_time"] ?? "")-\(openAndCloseDictionary["close_time"] ?? "")"
                    default:
                        break
                    }
                }
                
                
                
                var cuisine = [CuisineStruct]()
                //------------------------------------
                // Obtain Array of "cuisine" JSON Objects
                //------------------------------------
                var arrayOfCuisineJsonObjects = Array<Any>()
                
                if let jsonArray = restaurantDictionary["cuisine"] as? [Any] {
                    arrayOfCuisineJsonObjects = jsonArray
                } else {
                    return
                }
                for index in 0..<arrayOfCuisineJsonObjects.count {
                    //-------------------------
                    // Obtain Cuisine Dictionary
                    //-------------------------
                    var cuisineDictionary = Dictionary<String, Any>()
                    
                    if let jsonDictionary = arrayOfCuisineJsonObjects[index] as? [String: Any] {
                        cuisineDictionary = jsonDictionary
                    } else {
                        return
                    }
                    let cuisineStruct = CuisineStruct(name: cuisineDictionary["name"] as! String)
                    cuisine.append(cuisineStruct)
                }
                
                
                var dietary = [DietaryRestrictionStruct]()
                //------------------------------------
                // Obtain Array of "dietary restriction" JSON Objects
                //------------------------------------
                var arrayOfDietaryJsonObjects = Array<Any>()
                
                if let jsonArray = restaurantDictionary["dietary_restrictions"] as? [Any] {
                    arrayOfDietaryJsonObjects = jsonArray
                } else {
                    return
                }
                for index in 0..<arrayOfDietaryJsonObjects.count {
                    //-------------------------
                    // Obtain Dietary Dictionary
                    //-------------------------
                    var dietaryDictionary = Dictionary<String, Any>()
                    
                    if let jsonDictionary = arrayOfDietaryJsonObjects[index] as? [String: Any] {
                        dietaryDictionary = jsonDictionary
                    } else {
                        return
                    }
                    let dietaryStruct = DietaryRestrictionStruct(name: dietaryDictionary["name"] as! String)
                    dietary.append(dietaryStruct)
                }
                
                print(location_id)
                print(latitude)
                print(longitude)
                print(rating)
                
                print(type(of: location_id))
                print(type(of: latitude))
                print(type(of: longitude))
                print(type(of: rating))
                
                let restaurant = RestaurantAPIStruct(location_id: Int(location_id), name: name as! String, latitude: latitude, longitude: longitude, rating: rating, price: price as! String, description: description as! String, phone: phone as! String, websiteUrl: websiteUrl as! String, address: address as! String, hours: hours, cuisine: cuisine, dietary_restrictions: dietary)
                
                foundRestaurantsList.append(restaurant)
            }   //End of for loop
            
        } catch {
            semaphore.signal()
            return
        }
        
        semaphore.signal()
    }).resume()
    
    /*
     The URLSession task above is set up. It begins in a suspended state.
     The resume() method starts processing the task in an execution thread.
     
     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires or timeout period of 10 seconds expires.
     */
    _ = semaphore.wait(timeout: .now() + 10)
}






