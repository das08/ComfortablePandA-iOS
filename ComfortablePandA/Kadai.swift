//
//  Kadai.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/02.
//

import Foundation

struct Kadai: Identifiable, Codable{
    var id: String
    let lectureName: String
    let assignmentInfo: String
    let dueDate: Date?
    var dispDate = Date()
    let isFinished: Bool
}

//struct AssignmentEntry: Codable, Identifiable {
//    let context: String
//    let id: String
//    let title: String
//    let dueTime: AssignmentEntryDueTime
//}
//
//struct AssignmentEntryDueTime: Codable {
//    let time: Int
//}
