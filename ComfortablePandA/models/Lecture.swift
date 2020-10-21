//
//  Lecture.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/21.
//

import Foundation

struct LectureCollection: Codable {
    let site_collection: [LectureInfo]
}

struct LectureInfo: Codable, Identifiable, Equatable {
    let id: String
    let title: String
}
