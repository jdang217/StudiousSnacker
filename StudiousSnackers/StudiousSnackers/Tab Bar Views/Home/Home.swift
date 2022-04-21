//
//  Home.swift
//  StudiousSnackers
//
//  Created by Jason Dang on 4/21/22.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Image("Welcome")
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                Text("Powered By")
                    .bold()
                    .foregroundColor(.blue)
                    .font(.system(size: 20))
                
                Link(destination: URL(string: "https://rapidapi.com/ptwebsolution/api/worldwide-restaurants/")!) {
                    VStack {
                        Image("WorldwideRestaurants")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100.0)
                        Text("Worldwide Restaurants API")
                    }
                }
                .padding(.bottom, 30)
                
                Link(destination: URL(string: "https://developer.kroger.com/")!) {
                    Image("Kroger")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200.0)
                }
                .padding(.bottom, 20)
            }   //End of Vstack
        }   //End of scrollview
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
