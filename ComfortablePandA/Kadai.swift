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
    let dueDate: Date
    let isFinished: Bool
}
