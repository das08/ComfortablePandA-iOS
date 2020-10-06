//
//  Saver.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/06.
//

import Foundation
import SwiftUI

class Saver {
    static let shared = Saver()
    
    @AppStorage("kadai", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    private var storedKadaiList: Data = Data()

    @AppStorage("lectureInfo", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    private var storedLectureInfo: Data = Data()
    
    func saveLectureInfoToStorage(lectureInfoList: [LectureInfo]) -> () {
        guard let save = try? JSONEncoder().encode(lectureInfoList) else { return }
        self.storedLectureInfo = save
        print("saved lecID")
    }
    
    func saveKadaiListToStorage(kadaiList: [Kadai]) -> () {
        guard let save = try? JSONEncoder().encode(kadaiList) else { return }
        self.storedKadaiList = save
        print("saved kadaiList")
    }
}
