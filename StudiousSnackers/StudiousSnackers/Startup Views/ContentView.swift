//
//  ContentView.swift
//  StudiousSnackers
//
//  Created by Jason Dang on 4/14/22.
//

import SwiftUI

struct ContentView : View {
    
    @State private var userAuthenticated = false
    
    var body: some View {
        
        if userAuthenticated {
            // Foreground View
            MainView()
        } else {
            ZStack {
                // Background View
                LoginView(canLogin: $userAuthenticated)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
