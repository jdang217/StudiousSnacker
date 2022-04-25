//
//  DatabaseChange.swift
//  StudiousSnackers
//
//  Created by Catalina Lemus on 4/24/22.
//  Copyright © 2022 Jason Dang, Catalina Lemus, and Fariha Rafa. All rights reserved.
//

import Combine
import SwiftUI

final class DatabaseChange: ObservableObject {

    /*
     The 'indicator' value will be toggled to indicate that the Core Data database
     has changed upon which all subscribing views shall refresh their views.
     */
    @Published var indicator = false
}
