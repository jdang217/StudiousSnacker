//
//  RestaurantAPIData.swift
//  StudiousSnackers
//
//  Created by Jason Dang on 4/20/22.
//

import Foundation
import SwiftUI

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
            
            print(jsonResponse)
            //----------------------------
            // Obtain Top Level Dictionary
            //----------------------------
            var topLevelDictionary = Dictionary<String, Any>()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                topLevelDictionary = jsonObject
            } else {
                return
            }
            
            
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






