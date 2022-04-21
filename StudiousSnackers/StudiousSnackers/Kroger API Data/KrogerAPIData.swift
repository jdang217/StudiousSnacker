//
//  KrogerAPIData.swift
//  StudiousSnackers
//
//  Created by Jason Dang on 4/20/22.
//

import Foundation
import SwiftUI

/*
***********************************************
MARK: Decode JSON response into Kroger store id info
***********************************************
*/
public func obtainKrogerStoreFromApi() {
    
    let token = "eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHBzOi8vYXBpLmtyb2dlci5jb20vdjEvLndlbGwta25vd24vandrcy5qc29uIiwia2lkIjoiWjRGZDNtc2tJSDg4aXJ0N0xCNWM2Zz09IiwidHlwIjoiSldUIn0.eyJhdWQiOiJzdHVkaW91c3NuYWNrZXJzLTcwMjU5MmVkNGNlZjgyZTllYjZhZmZjZGM1MjkwMmM0NTczMzQyNDc0MjYyNzI2NTQyNiIsImV4cCI6MTY1MDUxNjQxOCwiaWF0IjoxNjUwNTE0NjEzLCJpc3MiOiJhcGkua3JvZ2VyLmNvbSIsInN1YiI6IjQ0M2EyZmY4LWRlZTAtNTU5My1hYTViLWQ0MWRmNTkwMDI2ZiIsInNjb3BlIjoiIiwiYXV0aEF0IjoxNjUwNTE0NjE4Njg3OTM3NDY0LCJhenAiOiJzdHVkaW91c3NuYWNrZXJzLTcwMjU5MmVkNGNlZjgyZTllYjZhZmZjZGM1MjkwMmM0NTczMzQyNDc0MjYyNzI2NTQyNiJ9.Grm4dVw0h0OPZLWljA9e6JvPW8XJcPtMqh1Fv4HHHoiyFKRLtBKmQ3e90AvtdzJAmpuKPWeqMgsgvIn6LVSAF7Wl13SD1RQO-IlF-IiOVmFd5kqfPntG_Cvdn5mVkUMu5X34ZsOioL4V9OAiBUrILhiEa35HPzGJlRFUiNX6gNLpok69lrCSaqzQ2uSQw5AZIi3qq-2oSMJ0h-sUO09ChmEcGuMc1vUut6WLnflT95ycCeWQlBMzPTUwydSxrLzNCK0AENxZC6YRfO6RL-qsDKYkcn8p9C38mJTbwZQ5WkkxP9WCuuBXkFUWVzInrGx8a33BKMd0XtMb4GEMSo_wLA"
        
    let apiQueryUrl = "https://api.kroger.com/v1/locations?filter.zipCode.near=24060&filter.chain=kroger"
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
     *   HTTP GET Request Set Up   *
     *******************************
     */
    
    let headers = [
        "accept": "application/json",
        "cache-control": "no-cache",
        "Authorization": "Bearer \(token)"
    ]
    
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 20.0)
    
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
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


/*
***********************************************
MARK: Decode JSON response into Kroger store products info
***********************************************
*/
public func obtainKrogerProductFromApi() {
    
    let token = "eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHBzOi8vYXBpLmtyb2dlci5jb20vdjEvLndlbGwta25vd24vandrcy5qc29uIiwia2lkIjoiWjRGZDNtc2tJSDg4aXJ0N0xCNWM2Zz09IiwidHlwIjoiSldUIn0.eyJhdWQiOiJzdHVkaW91c3NuYWNrZXJzLTcwMjU5MmVkNGNlZjgyZTllYjZhZmZjZGM1MjkwMmM0NTczMzQyNDc0MjYyNzI2NTQyNiIsImV4cCI6MTY1MDUxNzYzNCwiaWF0IjoxNjUwNTE1ODI5LCJpc3MiOiJhcGkua3JvZ2VyLmNvbSIsInN1YiI6IjQ0M2EyZmY4LWRlZTAtNTU5My1hYTViLWQ0MWRmNTkwMDI2ZiIsInNjb3BlIjoicHJvZHVjdC5jb21wYWN0IiwiYXV0aEF0IjoxNjUwNTE1ODM0MTI1MTc4NDUwLCJhenAiOiJzdHVkaW91c3NuYWNrZXJzLTcwMjU5MmVkNGNlZjgyZTllYjZhZmZjZGM1MjkwMmM0NTczMzQyNDc0MjYyNzI2NTQyNiJ9.SJqEqWFMtTV8EOIK-TfDWP8h16DZB5IfeMFD5qBhYFiDTbbZpBA4TNNngubNuN8OTEXe5cAoNbnMTmjjh48NXFIinuAxOj6WJXcOcamaeUbTzBILja3a0hWIPJbo4fReIB9PMTIEljT64nAHO6h6gFDfeqr5XVebGYiLSSugVXI8LcHkIHYXHY14BQ1GAv3E4nj0YV-lxO2O01nBaeSWfhTa3xQRMIDt8lxF-Y05mIw_14p-cqQXwOiTGwZ93w6GCRPkEthu3_1OSZblRgXdEmWoMDGK95ytwDjlYQykvmEkwH4Ep1WZYx0_XQ15M_PmhUfIIu4g9kil5EzK87jiog"
    
    let ucbLocationId = "02900210"
        
    let apiQueryUrl = "https://api.kroger.com/v1/products?filter.term=cheezits&filter.locationId=\(ucbLocationId)"
    
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
     *   HTTP GET Request Set Up   *
     *******************************
     */
    
    let headers = [
        "accept": "application/json",
        "Authorization": "Bearer \(token)"
    ]
    
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 20.0)
    
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
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







