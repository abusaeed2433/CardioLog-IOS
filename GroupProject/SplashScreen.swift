//
//  SplashScreen.swift
//  GroupProject
//
//  Created by Abu Saeed on 8/10/23.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        
        VStack{
            Image("heart")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        .frame(height: 200)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
