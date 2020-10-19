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
                        Image(systemName: "tray.2.fill")
                        Text("課題一覧")
                    }
                }.tag(1)
            LoginView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("PandAログイン")
                    }
                }.tag(2)
            SettingView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("設定")
                    }
                }.tag(3)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

