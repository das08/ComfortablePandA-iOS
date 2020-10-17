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
    
    @State private var kadaiList = Loader.shared.loadKadaiListFromStorage()!
    @State private var isShowing = false
    @State private var currentDate = Date()
    @State private var kadaiFetchedTime = Loader.shared.loadKadaiFetchedTimeFromStorage()
    
    var body: some View {
        VStack{
            Text("取得日時: \(kadaiFetchedTime)")
            Text("更新日時: \(dispDate(date: currentDate))")
            HStack{
                Button(action: {
                    kadaiList = createKadaiList(rawKadaiList: SakaiAPI.shared.getRawKadaiList(), count: 999)
                    Saver.shared.saveKadaiListToStorage(kadaiList: kadaiList)
                    Saver.shared.saveKadaiFetchedTimeToStorage()
                    
                    kadaiFetchedTime = Loader.shared.loadKadaiFetchedTimeFromStorage()
                    currentDate = Date()
                    
                }) {
                    HStack{
                        Image(systemName: "tray.and.arrow.down")
                        Text("課題を取得")
                    }
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
            
            List{
                ForEach(kadaiList){kadai in
                    let time = getTimeRemain(dueDate: kadai.dueDate, dispDate: currentDate)
                    let daysUntil = getDaysUntil(dueDate: kadai.dueDate, dispDate: currentDate)
                    
                    VStack(alignment: .leading, spacing: 10){
                        HStack{
                            CheckView(isFinished: kadai.isFinished)
                            HStack{
                                
                                LectureNameView(lectureName:kadai.lectureName, daysUntil: daysUntil)
                                Spacer()
                                DateTimeView(date: kadai.dueDate!, time: time)
                            }
                        }
                        Text(kadai.assignmentInfo)
                            .lineLimit(1)
                            .padding(.leading, 25)
                    }
                }
            }
            .pullToRefresh(isShowing: $isShowing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isShowing = false
                    kadaiList = Loader.shared.loadKadaiListFromStorage()!
                    kadaiFetchedTime = Loader.shared.loadKadaiFetchedTimeFromStorage()
                    currentDate = Date()
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
