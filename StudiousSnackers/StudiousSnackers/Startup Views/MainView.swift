//
//  MainView.swift
//  StudiousSnackers
//
//  Created by Fariha Rafa on 4/24/22.
//  Copyright © 2022 Jason Dang, Catalina Lemus, and Fariha Rafa. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
//            PhotosList()
//                .tabItem {
//                    Image(systemName: "list.bullet")
//                    Text("Search Restaurants")
//                }
//            AddPhoto()
//                .tabItem {
//                    Image(systemName: "photo")
//                    Text("Favorite Restaurants")
//                }
//            PhotosGrid()
//                .tabItem {
//                    Image(systemName: "square.grid.3x3")
//                    Text("Search Snacks")
//                }
//            SlideShow()
//                .tabItem {
//                    Image(systemName: "slider.horizontal.below.rectangle")
//                    Text("Favorite Snacks")
//                }
//                .onAppear() {
//                    UIPageControl.appearance().currentPageIndicatorTintColor = .black
//                    UIPageControl.appearance().pageIndicatorTintColor = .gray
//                }
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            
        }   // End of TabView
            .font(.headline)
            .imageScale(.medium)
            .font(Font.title.weight(.regular))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
