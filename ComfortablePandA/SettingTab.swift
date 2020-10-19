//
//  SettingTab.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/19.
//

import SwiftUI

struct SettingView: View {
    @State private var showDoneAssignments: Bool = true
    
    var body: some View {
            NavigationView {
                List {
                    Toggle(isOn: self.$showDoneAssignments){
                        Text("完了済みの課題を表示する")
                    }
                }
                .navigationBarTitle("設定")
            }
        }
    
}
