//
//  MainTab.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/08.
//

import WidgetKit
import SwiftUI

struct MainView: View {
    @AppStorage("kadai", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    private var storedKadaiList: Data = Data()
    
    @State private var kadaiList = Loader.shared.loadKadaiListFromStorage()!
    

    
    
    var body: some View {
        VStack{
            Button("Load and Save"){
                kadaiList = createKadaiList(rawKadaiList: SakaiAPI.shared.getRawKadaiList(), count: 999)
                Saver.shared.saveKadaiListToStorage(kadaiList: kadaiList)
                Saver.shared.saveKadaiFetchedTimeToStorage()
                
            }
            Button("refresh widget"){
                WidgetCenter.shared.reloadAllTimelines()
                
            }
            List{
                ForEach(kadaiList){kadai in
                    let time = getTimeRemain(dueDate: kadai.dueDate, dispDate: kadai.dispDate)
                    let daysUntil = getDaysUntil(dueDate: kadai.dueDate, dispDate: kadai.dispDate)
                    
                    VStack(alignment: .leading, spacing: 5){
                        HStack{
                            CheckView(isFinished: kadai.isFinished)
                            HStack{
                                
                                LectureNameView(lectureName:kadai.lectureName, daysUntil: daysUntil)
                                DateTimeView(date: kadai.dueDate!, time: time)
                            }
                        }
                        

                        Text(kadai.assignmentInfo)
                            .lineLimit(1)
                            .padding(.leading, 25)
                        
                    }
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
