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
//    let kadais = [
//        Kadai(id: "001", lectureName: "Lec1", assignmentInfo: "Quiz1", dueDate: generateDate(y: 2020, mo: 10, d: 4, h: 9, min: 0), isFinished: false),
//        Kadai(id: "002", lectureName: "Lec2", assignmentInfo: "Quiz2", dueDate: generateDate(y: 2020, mo: 10, d: 8, h: 9, min: 0), isFinished: false),
//        Kadai(id: "003", lectureName: "Lec3", assignmentInfo: "Quiz3", dueDate: generateDate(y: 2020, mo: 10, d: 8, h: 9, min: 0), isFinished: false)
//    ]

    
//    var kadaiList: [AssignmentEntry] = loadKadai()!.assignment_collection
    
    
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
            let kadaiList = createKadaiList(rawKadaiList: SakaiAPI.shared.getRawKadaiList())
            
            guard let saveKadaiList = try? JSONEncoder().encode(kadaiList) else { return }
            self.storedKadaiList = saveKadaiList
            print("saved")
        }
        Button("Load and Show"){
            guard let loadKadaiList = try? JSONDecoder().decode([Kadai].self, from: storedKadaiList) else { return }
            
            kadaiList = loadKadaiList
            print("loaded")
        }
        List{

//            let kadaiList = createKadaiList(rawKadaiList: SakaiAPI.shared.getRawKadaiList())
            
            
            ForEach(kadaiList){kadai in
                
                VStack(alignment: .leading){
                    HStack{
//                        Text(findLectureName(lectureInfoList: lectureInfoList!, lecID: "kadai.lectureName"))
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
    
//    func save(_ kadai: Kadai){
//        guard let kadaiList = try? JSONEncoder().encode(kadai) else { return }
//        self.kadaiList = kadaiList
//        print("Save")
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
