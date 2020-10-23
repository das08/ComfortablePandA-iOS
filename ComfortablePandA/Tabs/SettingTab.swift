//
//  SettingTab.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/19.
//

import SwiftUI
import WidgetKit

struct SettingView: View {
    @State var showingAlert = false
    @State var alertInfo = ""
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: CPSetting.shared.$showDoneAssignments){
                    Text("完了済みの課題を表示する")
                }.onTapGesture {
                    WidgetCenter.shared.reloadAllTimelines()
                }
                HStack {
                    NavigationLink(destination: LoginView()){
                        Text("PandAログイン")
                    }
                }
                Text("講義名情報を再取得する")
                    .onTapGesture {
                        _ = SakaiAPI.shared.getLectureInfoList()
                        self.showingAlert = true
                        self.alertInfo = "多分取得できました！"
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(alertInfo))
                    }
            }
            .navigationBarTitle("設定")
        }
    }
}

