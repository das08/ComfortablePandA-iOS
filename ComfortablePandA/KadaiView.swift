//
//  KadaiView.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/02.
//

import SwiftUI

struct KadaiView: View{
    let kadai: Kadai
    
    var body: some View {
        Text(kadai.lectureName)
            .font(.largeTitle)
            .padding()
    }
}

struct KadaiViewLarge: View{
    let kadaiList: [Kadai]
    let kadaiFetchedTime = Loader.shared.loadKadaiFetchedTimeFromStorage()
    
    var body: some View {
        VStack(alignment:.leading ,spacing: 0){
            Spacer()
                .frame(height:8)
            HeaderView(updatedTime: kadaiFetchedTime)
            Spacer()
                .frame(height:15)
            VStack(alignment:.leading, spacing:5){
                ForEach(kadaiList){entry in
                    
                    let time = getTimeRemain(dueDate: entry.dueDate, dispDate: entry.dispDate)
                    let daysUntil = getDaysUntil(dueDate: entry.dueDate, dispDate: entry.dispDate)
                    
                    VStack(alignment:.leading, spacing:0){
                        VStack(alignment:.leading, spacing:5){
                            HStack(spacing:0){
                                Text(entry.lectureName)
                                    .font(.system(size: 13))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(getBadgeColor(days: daysUntil))
                                    )
                                    .padding(.horizontal, 5)
                                Text("あと\(time.days)日\(time.hour)時間\(time.minute)分")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 100/255 , green: 100/255, blue: 100/255))
                                
                            }
                            HStack(alignment: .center, spacing: 0){
                                Text(entry.assignmentInfo)
                                    .font(.system(size: 13))
                                    .lineLimit(1)
                                    .padding(.leading)
                                    .padding(.bottom,5)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        Spacer()
    }
}



