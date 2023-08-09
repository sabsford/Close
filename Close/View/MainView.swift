//
//  MainView.swift
//  Close
//
//  Created by SF on 8/8/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            Text("Recent Post's")
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Post's")
                }
            Text("Profile View")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Post's")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
