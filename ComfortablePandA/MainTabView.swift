//
//  MainTabView.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/17.
//

import SwiftUI

struct DateTimeView: View {
    let date: Date
    let time: kadaiDueDate
    @State var isDate:Bool = false
    func toggle(){isDate = !isDate}
    var body: some View {
        if isDate{
            Text(dispDate(date: date))
                .font(.system(size: 14))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 100/255 , green: 100/255, blue: 100/255))
                .padding(.bottom,5)
                .onTapGesture{
                    toggle()
                }
        } else {
            Text("あと\(time.days)日\(time.hour)時間\(time.minute)分")
                .font(.system(size: 14))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 100/255 , green: 100/255, blue: 100/255))
                .padding(.bottom,5)
                .onTapGesture{
                    toggle()
                }
        }
    }
}

struct LectureNameView: View {
    let lectureName:String
    let daysUntil:Int
    @State var isFull:Bool = false
    func toggle(){isFull = !isFull}
    var body: some View {
        if isFull{
            Text(lectureName)
                .font(.system(size: 14))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(getBadgeColor(days: daysUntil))
                )
                .onTapGesture{
                    toggle()
                }
        } else {
            Text(lectureName)
                .font(.system(size: 14))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(1)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(getBadgeColor(days: daysUntil))
                )
                .onTapGesture{
                    toggle()
                }
        }
    }
}

struct AssignmentInfoView: View {
    var assignmentInfo: String
    var description = ""
    @State var isDetailed:Bool = false
    
    func toggle(){isDetailed = !isDetailed}
    var body: some View {
        if isDetailed {
            VStack(alignment: .leading) {
                Text(assignmentInfo)
                    .fontWeight(.bold)
//                    .lineLimit(1)
                    .padding(.leading, 25)
                    .onTapGesture{
                        toggle()
                    }
                Text(description)
                    .padding(.leading, 25)
                    .onTapGesture{
                        toggle()
                    }
            }
        } else {
            Text(assignmentInfo)
                .lineLimit(1)
                .padding(.leading, 25)
                .onTapGesture{
                    toggle()
                }
        }
    }
}
