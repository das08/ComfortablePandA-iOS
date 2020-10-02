//
//  ContentView.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/02.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("kadai", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    var kadaiList: Data = Data()
    
    let kadais = [
        Kadai(id: "001", lectureName: "Lec1", assignmentInfo: "Quiz1", dueDate: Date(), isFinished: false),
        Kadai(id: "002", lectureName: "Lec2", assignmentInfo: "Quiz2", dueDate: Date(), isFinished: false),
        Kadai(id: "003", lectureName: "Lec3", assignmentInfo: "Quiz3", dueDate: Date(), isFinished: false)
    ]
    
    var body: some View {
        VStack(spacing: 30){
            ForEach(kadais) { kadai in
                KadaiView(kadai: kadai)
                    .onTapGesture {
                        save(kadai)
                    }
            }
        }
    }
    
    func save(_ kadai: Kadai){
        guard let kadaiList = try? JSONEncoder().encode(kadai) else { return }
        self.kadaiList = kadaiList
        print("Save")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
