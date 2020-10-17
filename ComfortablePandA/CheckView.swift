//
//  CheckView.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/17.
//

import SwiftUI

struct CheckView: View {
    @State var isFinished:Bool = false
    func toggle(){isFinished = !isFinished}
    var body: some View {
        Button(action: toggle) {
            Image(systemName: isFinished ? "checkmark.square" : "square")
        }
    }
}


struct DateTimeView: View {
    let date: Date
    let time: kadaiDueDate
    @State var isDate:Bool = false
    func toggle(){isDate = !isDate}
    var body: some View {
        HStack{
            Button(action: toggle) {
                if isDate{
                    Text("あと\(time.days)日\(time.hour)時間\(time.minute)分")
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 100/255 , green: 100/255, blue: 100/255))
                } else {
                    Text(dispDate(date: date))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 100/255 , green: 100/255, blue: 100/255))
                }
            }
        }
    }
}
