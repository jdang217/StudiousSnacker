//
//  RestaurantAPIStruct.swift
//  StudiousSnackers
//
//  Created by Jason Dang on 4/20/22.
//

import SwiftUI

public struct RestaurantAPIStruct: Decodable {
   
    var name: String
}


/*
 "location_id":"2249194"
 "name":"Carol Lee Donuts"
 "latitude":"37.247353"
 "longitude":"-80.414314"
 "num_reviews":"257"
 "timezone":"America/New_York"
 "location_string":"Blacksburg, Virginia"
 "photo":{...}8 items
 "api_detail_url":"https://api.tripadvisor.com/api/internal/1.14/location/2249194"
 "awards":[...]7 items
 "doubleclick_zone":"na.us.virginia"
 "preferred_map_engine":"default"
 "raw_ranking":"4.732071876525879"
 "ranking_geo":"Blacksburg"
 "ranking_geo_id":"57513"
 "ranking_position":"1"
 "ranking_denominator":"118"
 "ranking_category":"restaurant"
 "ranking":"#1 of 5 Dessert in Blacksburg"
 "distance":NULL
 "distance_string":NULL
 "bearing":NULL
 "rating":"5.0"
 "is_closed":false
 "open_now_text":"Closed Now"
 "is_long_closed":false
 "price_level":"$"
 "description":"Carol Lee Donuts is a retail take-out doughnut shop. Coffee, milk, and tea are available inside. We will be adding beverages soon."
 "web_url":"https://www.tripadvisor.com/Restaurant_Review-g57513-d2249194-Reviews-Carol_Lee_Donuts-Blacksburg_Virginia.html"
 "write_review":"https://www.tripadvisor.com/UserReview-g57513-d2249194-Carol_Lee_Donuts-Blacksburg_Virginia.html"
 "ancestors":[...]3 items
 "category":{...}2 items
 "subcategory":[...]1 item
 "parent_display_name":"Blacksburg"
 "is_jfy_enabled":false
 "nearest_metro_station":[]0 items
 "phone":"+1 540-552-6706"
 "website":"http://Carolleedonuts.com"
 "address_obj":{...}6 items
 "address":"1414 N Main St, Blacksburg, VA 24060-2522"
 "hours":{...}2 items
 "is_candidate_for_contact_info_suppression":false
 "cuisine":[...]1 item
 "dietary_restrictions":[]0 items
 "establishment_types":[...]2 items
 */
