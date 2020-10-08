//
//  ContentView.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/02.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    VStack {
                        Image(systemName: "a")
                        Text("TabA")
                    }
                }.tag(1)
            SettingView()
                .tabItem {
                    VStack {
                        Image(systemName: "bold")
                        Text("TabB")
                    }
                }.tag(2)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

