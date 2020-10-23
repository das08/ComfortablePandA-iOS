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
                Section(header: Text("カスタマイズ")) {
                    Toggle(isOn: CPSetting.shared.$showDoneAssignments){
                        Text("完了済みの課題を表示する")
                    }.onTapGesture {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    
                    Button(action: {
                        WidgetCenter.shared.reloadAllTimelines()
                    }) {
                        HStack{
                            Image(systemName: "arrow.2.circlepath")
                            Text("Widgetを更新")
                        }
                    }
                }
                
                Section(header: Text("PandA関連")) {
                    HStack {
                        NavigationLink(destination: LoginView()){
                            Text("PandAログイン")
                        }
                    }
                    Button(action:{
                        _ = SakaiAPI.shared.getLectureInfoList()
                        self.showingAlert = true
                        self.alertInfo = "多分取得できました！"
                    }
                    ) {
                        Text("講義名情報を再取得する")
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text(alertInfo))
                            }
                    }
                }
                
                Section(header: Text("デバッグ")) {
                    Button(action:{
                        setNotification(title: "📗新規課題", body: "2020/10/15 11:00 テスト配信\n課題１")
                        setNotification(title: "⏰提出1日前", body: "2020/10/10 12:00 テスト配信\n課題１")
                    }
                    ) {
                        Text("通知テスト")
                    }
                }
            }
            .navigationBarTitle("設定")
        }
    }
}

