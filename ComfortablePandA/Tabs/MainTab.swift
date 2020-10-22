//
//  MainTab.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/08.
//

import WidgetKit
import SwiftUI
import SwiftUIRefresh

struct MainView: View {
    @AppStorage("kadai", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    private var storedKadaiList: Data = Data()
    
    @State private var errorAlert = false
    @State private var errorAlertMsg = ""
    
    @State private var kadaiList = createKadaiList(_kadaiList: Loader.shared.loadKadaiListFromStorage()!, count: 999)
    @State private var isShowing = false
    @State private var currentDate = Date()
    @State private var kadaiFetchedTime = Loader.shared.loadKadaiFetchedTimeFromStorage()
    
    @State var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack{
            Text("取得日時: \(kadaiFetchedTime)")
            Text("更新日時: \(dispDate(date: currentDate))")
                .onReceive(timer){ _ in
                    kadaiList = createKadaiList(_kadaiList: Loader.shared.loadKadaiListFromStorage()!, count: 999)
                    kadaiFetchedTime = Loader.shared.loadKadaiFetchedTimeFromStorage()
                    currentDate = Date()
                    print("ok!")
//                    setNotification(title: "📗定期実行", body: "\(dispDate(date: Date()))")
                }
            HStack{
                Button(action: {
                    
                    let res = SakaiAPI.shared.fetchAssignmentsFromPandA()
                    if res.success {
                        kadaiList = createKadaiList(rawKadaiList: res.rawKadaiList!, count: 999)
                        Saver.shared.mergeAndSaveKadaiListToStorage(newKadaiList: kadaiList)
                        Saver.shared.saveKadaiFetchedTimeToStorage()
                        kadaiList = createKadaiList(_kadaiList: Loader.shared.loadKadaiListFromStorage()!, count: 999)
                        
                        kadaiFetchedTime = Loader.shared.loadKadaiFetchedTimeFromStorage()
                        currentDate = Date()
                        WidgetCenter.shared.reloadAllTimelines()
                        UIApplication.shared.applicationIconBadgeNumber = BadgeCount.shared.badgeCount
                    }else{
                        errorAlert = true
                        errorAlertMsg = res.errorMsg
                    }

                }) {
                    HStack{
                        Image(systemName: "tray.and.arrow.down")
                        Text("課題を取得")
                    }
                }.alert(isPresented: $errorAlert) {
                    Alert(title: Text("\(errorAlertMsg)"))
                }

                
                Button(action: {
                    WidgetCenter.shared.reloadAllTimelines()
                }) {
                    HStack{
                        Image(systemName: "arrow.2.circlepath")
                        Text("Widgetを更新")
                    }
                }
                Button(action:{
                    setNotification(title: "📗新規課題", body: "2020/10/15 11:00 電気電子工学概論\n課題１")
                    setNotification(title: "⏰提出1日前", body: "2020/10/10 12:00 電気電子工学概論\n課題１")
                    BadgeCount.shared.badgeCount = 99
                    UIApplication.shared.applicationIconBadgeNumber = BadgeCount.shared.badgeCount
                }
                ) {
                    Text("通知")
                }
            }
            
            List{
                ForEach(kadaiList){kadai in
                    let time = getTimeRemain(dueDate: kadai.dueDate, dispDate: currentDate)
                    let daysUntil = getDaysUntil(dueDate: kadai.dueDate, dispDate: currentDate)
                    
                    VStack(alignment: .leading, spacing: 10){
                        HStack{
                            CheckView(isFinished: kadai.isFinished, kadaiList: self.$kadaiList ,kid: kadai.id)
                            HStack{
                                
                                LectureNameView(lectureName:kadai.lectureName, daysUntil: daysUntil)
                                Spacer()
                                DateTimeView(date: kadai.dueDate, time: time)
                            }
                        }
                        AssignmentInfoView(assignmentInfo: kadai.assignmentInfo, description: kadai.description)
                    }
                }
            }
            .pullToRefresh(isShowing: $isShowing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isShowing = false
                    kadaiList = createKadaiList(_kadaiList: Loader.shared.loadKadaiListFromStorage()!, count: 999)
                    kadaiFetchedTime = Loader.shared.loadKadaiFetchedTimeFromStorage()
                    currentDate = Date()
                    UIApplication.shared.applicationIconBadgeNumber = BadgeCount.shared.badgeCount
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
