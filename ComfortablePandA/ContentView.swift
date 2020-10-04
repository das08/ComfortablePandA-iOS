//
//  ContentView.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/02.
//

import SwiftUI


struct ContentView: View {
    
//    @AppStorage("kadai", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
//    var kadaiList: Data = Data()
//
//    let kadais = [
//        Kadai(id: "001", lectureName: "Lec1", assignmentInfo: "Quiz1", dueDate: generateDate(y: 2020, mo: 10, d: 4, h: 9, min: 0), isFinished: false),
//        Kadai(id: "002", lectureName: "Lec2", assignmentInfo: "Quiz2", dueDate: generateDate(y: 2020, mo: 10, d: 8, h: 9, min: 0), isFinished: false),
//        Kadai(id: "003", lectureName: "Lec3", assignmentInfo: "Quiz3", dueDate: generateDate(y: 2020, mo: 10, d: 8, h: 9, min: 0), isFinished: false)
//    ]

    
//    var kadaiList: [AssignmentEntry] = loadKadai()!.assignment_collection
    
    
    var body: some View {
        Text("課題一覧")
            .onAppear(
                perform: {
                    let kadaiList = SakaiAPI.shared.getKadaiList()
                    print(kadaiList)
                    
                }
            )
        List{
            let kadaiList = SakaiAPI.shared.getKadaiList()
            ForEach(kadaiList){kadai in
                VStack(alignment: .leading){
                    Text(kadai.context)
                        .fontWeight(.bold)
                    HStack{
                        Text(kadai.title)
                            .lineLimit(1)
                        Text(String(kadai.dueTime.time))
                    }
                    
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
