//
//  DueDates.swift
//  ComfortablePandA
//
//  Created by Kazuki Takeda on 2020/10/03.
//

import Foundation

struct kadaiDueDate: Codable {
    let days: Int
    let hour: Int
    let minute: Int
    
//    init(days: Int, hour: Int, minute: Int) {
//            self.days = days
//            self.hour = hour
//            self.minute = minute
//        }
}

extension Date {

    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}

func generateDate(y:Int, mo:Int, d:Int, h:Int, min:Int) -> Date? {
    var date = DateComponents()
    date.calendar = Calendar.current
    date.year = y
    date.month = mo
    date.day = d
    date.hour = h
    date.minute = min
    
    return date.date
}

func getTimeRemain(dueDate: Date?) -> kadaiDueDate {
//    let timeDiff = Date() - dueDate!
    let timeDiff = dueDate!-Date()
    let days = floor(Double(timeDiff.second!) / (3600 * 24))
    let hours = floor((Double(timeDiff.second!) - (days * 3600 * 24)) / 3600)
    let minutes = floor((Double(timeDiff.second!) - (days * 3600 * 24 + hours * 3600)) / 60)
    return kadaiDueDate(days: Int(days), hour: Int(hours), minute: Int(minutes))
}
