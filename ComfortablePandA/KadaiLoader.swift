//
//  KadaiLoader.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/04.
//

import Foundation
//import SwiftUI

func getKadaiFromPandA() -> [Kadai] {
    var kadaiList = [
        Kadai(id: "001", lectureName: "電気電子工学基礎実験", assignmentInfo: "第２週予習課題（19~21班）", dueDate: generateDate(y: 2020, mo: 10, d: 6, h: 12, min: 30), isFinished: false),
        Kadai(id: "002", lectureName: "電気電子数学1", assignmentInfo: "Assignment 1", dueDate: generateDate(y: 2020, mo: 10, d: 6, h: 9, min: 0), isFinished: false),
        Kadai(id: "003", lectureName: "電気電子計測", assignmentInfo: "第1回レポート", dueDate: generateDate(y: 2020, mo: 10, d: 10, h: 9, min: 0), isFinished: false),
        
        Kadai(id: "005", lectureName: "電磁気学1", assignmentInfo: "確認問題１", dueDate: generateDate(y: 2020, mo: 10, d: 20, h: 9, min: 0), isFinished: false),
        Kadai(id: "006", lectureName: "電磁気学1", assignmentInfo: "確認問題１", dueDate: generateDate(y: 2020, mo: 10, d: 20, h: 9, min: 0), isFinished: false),
        Kadai(id: "004", lectureName: "電気電子計測", assignmentInfo: "第1回レポート", dueDate: generateDate(y: 2020, mo: 10, d: 13, h: 9, min: 0), isFinished: false)
        
    ]
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
    
    for rawEntry in rawKadaiList {
        let id = rawEntry.id
        let lectureName = rawEntry.context
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



