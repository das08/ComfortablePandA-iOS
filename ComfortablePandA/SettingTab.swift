//
//  SettingTab.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/19.
//

import SwiftUI
import WidgetKit

struct SettingView: View {
    
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: CPSetting.shared.$showDoneAssignments){
                    Text("完了済みの課題を表示する")
                }.onTapGesture {
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            .navigationBarTitle("設定")
        }
    }
}

class CPSetting {
    static let shared = CPSetting()
    
    @AppStorage("showDoneAssignments", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    var showDoneAssignments: Bool = true
}
