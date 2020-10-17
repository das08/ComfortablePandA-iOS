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
    
    @AppStorage("lastKadaiFetched", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    private var storedKadaiFetchedTime: Data = Data()
    
    @AppStorage("kadai", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    private var storedKadaiList: Data = Data()

    @AppStorage("lectureInfo", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    private var storedLectureInfo: Data = Data()
    
    func loadKadaiFetchedTimeFromStorage() -> String {
        var loadKadaiFetchedTime: Date
        guard let load = try? JSONDecoder().decode(Date.self, from: storedKadaiFetchedTime) else {
            return "未取得"
        }
        
        loadKadaiFetchedTime = load
        return dispDate(date: loadKadaiFetchedTime)
    }
    
    func loadLectureInfoFromStorage() -> [LectureInfo]? {
        var loadLectureInfo: [LectureInfo]
        guard let load = try? JSONDecoder().decode([LectureInfo].self, from: storedLectureInfo) else {
            let loadLectureInfo = SakaiAPI.shared.fetchLectureInfoFromPandA()!
            Saver.shared.saveLectureInfoToStorage(lectureInfoList: loadLectureInfo)
            return loadLectureInfo
        }
        
        loadLectureInfo = load
        return loadLectureInfo
    }
    
    func loadKadaiListFromStorage() -> [Kadai]? {
        var loadKadaiList: [Kadai]
        guard let load = try? JSONDecoder().decode([Kadai].self, from: storedKadaiList) else {
            let rawKadaiList = SakaiAPI.shared.getRawKadaiList()
            let kadaiList = createKadaiList(rawKadaiList: rawKadaiList, count: 999)
            Saver.shared.saveKadaiListToStorage(kadaiList: kadaiList)
            return kadaiList
        }
        
                
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

func createKadaiList(rawKadaiList: [AssignmentEntry], count: Int) -> [Kadai] {
    var kadaiList = [Kadai]()
    let lectureInfoList = Loader.shared.loadLectureInfoFromStorage()
    
//    if lectureInfoList == nil {
//        lectureInfoList = SakaiAPI.shared.fetchLectureInfoFromPandA()
//        Saver.shared.saveLectureInfoToStorage(lectureInfoList: lectureInfoList!)
//    }
    
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
        if entryCount >= count {
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

func createKadaiList(_kadaiList: [Kadai], count: Int) -> [Kadai] {
    let kadaiList = sortKadaiList(kadaiList: _kadaiList)

    var validKadaiList = [Kadai]()
    
    var entryCount = 0
    
    for entry in kadaiList {
        if entryCount >= count {
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

func loadKadaiListFromStorage(storedKadaiList: Data) -> [Kadai]? {
    var loadKadaiList: [Kadai]
    guard let load = try? JSONDecoder().decode([Kadai].self, from: storedKadaiList) else {
        return []
    }
    
            
    loadKadaiList = load
    
    return loadKadaiList
}

func getKeychain(account: String) -> loadResultMessage {
    var result = loadResultMessage()
    do {
        let key = try Keychain.get(account: account)
        result.success = true
        result.data = String(data: key!, encoding: .utf8)!
    }
    catch Keychain.Errors.keychainNotFound{
        result.data = "KeychainNotFound"
        result.errorMsg = Keychain.Errors.keychainNotFound
    }
    catch {
        result.data = "something went wrong"
    }
    return result
}


struct loadResultMessage {
    var success: Bool = false
    var data: String = ""
    var errorMsg :Keychain.Errors = Keychain.Errors.keychainError
}
