//
//  MainTab.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/08.
//

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
            List{
                ForEach(kadaiList){kadai in
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text(kadai.lectureName)
                                .fontWeight(.bold)
                            Text(dispDate(date: kadai.dueDate!))
                        }
                        Text(kadai.assignmentInfo)
                            .lineLimit(1)
                        
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
