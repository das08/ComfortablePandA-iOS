//
//  ContentView.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/02.
//

import SwiftUI


struct ContentView: View {
    
    @AppStorage("kadai", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    private var storedKadaiList: Data = Data()
    
    @State private var kadaiList = Loader.shared.loadKadaiListFromStorage()!
//
    
    
    var body: some View {
//        Text("課題一覧")
//            .onAppear(
//                perform: {
//                    let kadaiList = createKadaiList(rawKadaiList: SakaiAPI.shared.getRawKadaiList())
////                    print(kadaiList)
//
//                }
//            )
        

        Button("Load and Save"){
            kadaiList = createKadaiList(rawKadaiList: SakaiAPI.shared.getRawKadaiList())
            Saver.shared.saveKadaiListToStorage(kadaiList: kadaiList)
            Saver.shared.saveKadaiFetchedTimeToStorage()
            
        }
//        Button("Load and Show"){
//            guard let loadKadaiList = try? JSONDecoder().decode([Kadai].self, from: storedKadaiList) else { return }
//
//            kadaiList = loadKadaiList
//            print("loaded")
//        }
        List{

//            let kadaiList = createKadaiList(rawKadaiList: SakaiAPI.shared.getRawKadaiList())
            
            
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

