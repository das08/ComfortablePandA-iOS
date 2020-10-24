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
    var storedKadaiList: Data = Data()
    
    @State private var errorAlert = false
    @State private var errorAlertMsg = ""
    
    @State private var kadaiList = createKadaiList(_kadaiList: Loader.shared.loadKadaiListFromStorage2(), count: 999)
    @State private var isShowing = false
    @State private var currentDate = Date()
    @State private var kadaiFetchedTime = Loader.shared.loadKadaiFetchedTimeFromStorage()
    
    @State private var isSheetPresented = true
    
    @State var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack{
            Text("取得日時: \(kadaiFetchedTime)")
            Text("更新日時: \(dispDate(date: currentDate))")
                .onReceive(timer){ _ in
                    kadaiList = createKadaiList(_kadaiList: Loader.shared.loadKadaiListFromStorage2(), count: 999)
                    kadaiFetchedTime = Loader.shared.loadKadaiFetchedTimeFromStorage()
                    currentDate = Date()
                }
            
            HStack{
                Button(action: {
                    let res = SakaiAPI.shared.fetchAssignmentsFromPandA()
                    if res.success {
                        kadaiList = createKadaiList(rawKadaiList: res.rawKadaiList!, count: 999)
                        Saver.shared.mergeAndSaveKadaiListToStorage(newKadaiList: kadaiList)
                        Saver.shared.saveKadaiFetchedTimeToStorage()
                        kadaiList = createKadaiList(_kadaiList: Loader.shared.loadKadaiListFromStorage2(), count: 999)
                        
                        
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
                            .font(Font.system(size: 20, weight: .semibold))
                        Text("課題を取得")
                            .fontWeight(.semibold)
                            
                    }
                    .padding(10)
                    .foregroundColor(Color.white)
                    
                         .background(Color(red: 54/255 , green: 200/255, blue: 150/255))
                         .cornerRadius(8)
                }.alert(isPresented: $errorAlert) {
                    Alert(title: Text("\(errorAlertMsg)"))
                }
                .buttonStyle(ShrinkButtonStyle())

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
//                    kadaiList = createKadaiList(_kadaiList: Loader.shared.loadKadaiListFromStorage()!, count: 999)
                    kadaiList = createKadaiList(_kadaiList: Loader.shared.loadKadaiListFromStorage2(), count: 999)
                    
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

struct ShrinkButtonStyle: ButtonStyle {

   func makeBody(configuration: Self.Configuration) -> some View {

     let isPressed = configuration.isPressed

     return configuration.label
       .scaleEffect(x: isPressed ? 0.9 : 1, y: isPressed ? 0.9 : 1, anchor: .center)
       .animation(.spring(response: 0.2, dampingFraction: 0.9, blendDuration: 0))
   }
 }


