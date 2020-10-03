//
//  KadaiVIew.swift
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
    
    var body: some View {
        VStack(alignment:.leading ,spacing: 20){
            HeaderView(updatedTime: "2020/10/02 15:00 更新")
            VStack(alignment:.leading, spacing:5){
                ForEach(kadaiList){entry in
                    
                    let time = getTimeRemain(dueDate: entry.dueDate)
                    
                    VStack(alignment:.leading, spacing:5){
                        HStack(spacing:0){
                            Text(entry.lectureName)
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.red)
//                                        .frame(width: 70, height: 15)
                                )
                                .padding(.horizontal, 5)
                            Text("あと\(time.days)日\(time.hour)時間\(time.minute)分")
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 100/255 , green: 100/255, blue: 100/255))
                            
                        }
                        HStack(alignment: .center, spacing: 0){
                            Text(entry.assignmentInfo)
                                .font(.system(size: 14))
                                .lineLimit(1)
                                .padding(.leading)
                                .padding(.bottom,5)
                        }
                        
                    }
                    
                }
            }
            Spacer()
        }
    }
}



