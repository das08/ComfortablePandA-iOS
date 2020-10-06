//
//  Loader.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/04.
//

import Foundation
import SwiftUI

class Loader {
    static let shared = Loader()
    
    @AppStorage("kadai", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    private var storedKadaiList: Data = Data()

    @AppStorage("lectureInfo", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    private var storedLectureInfo: Data = Data()
    
    func loadLectureInfoFromStorage() -> [LectureInfo]? {
        var loadLectureInfo: [LectureInfo]
        guard let load = try? JSONDecoder().decode([LectureInfo].self, from: storedLectureInfo) else { return nil }
        
        loadLectureInfo = load
        
        return loadLectureInfo
    }
    
    func loadKadaiListFromStorage() -> [Kadai]? {
        var loadKadaiList: [Kadai]
        guard let load = try? JSONDecoder().decode([Kadai].self, from: storedKadaiList) else { return nil }
        
        loadKadaiList = load
        
        return loadKadaiList
    }
    
}




func sortKadaiList(kadaiList: [Kadai]) -> [Kadai] {
    return kadaiList.sorted { (l: Kadai, r: Kadai) in
//        if (l.dueDate! < r.dueDate!) {return (l.dueDate! < r.dueDate!)}
//        if (l.dueDate! > r.dueDate!) {return (l.dueDate! > r.dueDate!)}
//        if (l.assignmentInfo < r.assignmentInfo) {return (l.assignmentInfo < r.assignmentInfo)}
//        if (l.assignmentInfo > r.assignmentInfo) {return (l.assignmentInfo > r.assignmentInfo)}
//        return true
        return (l.dueDate! < r.dueDate!)
    }
}

func createKadaiList(rawKadaiList: [AssignmentEntry]) -> [Kadai] {
    var kadaiList = [Kadai]()
    var lectureInfoList = Loader.shared.loadLectureInfoFromStorage()
    
    if lectureInfoList == nil {
        lectureInfoList = SakaiAPI.shared.fetchLectureInfoFromPandA()
        Saver.shared.saveLectureInfoToStorage(lectureInfoList: lectureInfoList!)
    }
    
    for rawEntry in rawKadaiList {
        let id = rawEntry.id
//        let lectureName = rawEntry.context
        let lectureName = findLectureName(lectureInfoList: lectureInfoList!, lecID:                                             rawEntry.context)
        let assignmentInfo = rawEntry.title
        let dueDate = Date(timeIntervalSince1970: TimeInterval(rawEntry.dueTime.time / 1000))
        let isFinished = false
        
        if (dueDate >= Date()){
            kadaiList.append(
                Kadai(id: id, lectureName: lectureName, assignmentInfo: assignmentInfo, dueDate: dueDate, isFinished: isFinished)
            )
        }
    }
    
    kadaiList = sortKadaiList(kadaiList: kadaiList)

    var validKadaiList = [Kadai]()
    
    var entryCount = 0
    
    for entry in kadaiList {
        if entryCount >= 5 {
            break
        }
        
        let daysUntil = getDaysUntil(dueDate: entry.dueDate, dispDate: entry.dispDate)
        
        if daysUntil > 0 {
            validKadaiList.append(entry)
            entryCount += 1
        }
    }
    
    return validKadaiList
}



