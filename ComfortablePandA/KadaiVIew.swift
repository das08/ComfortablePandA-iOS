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
        VStack(alignment:.leading ,spacing: 5){
            HeaderView(updatedTime: "2020/10/02 15:00 更新")
            VStack(alignment:.leading, spacing:0){
                ForEach(kadaiList){entry in
                    VStack(alignment:.leading, spacing:0){
                        HStack{
                            Text("24時間以内")
                                    .fontWeight(.bold)
                                    .font(.system(size: 11))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.red)
                                                .frame(width: 70, height: 15)
                                        )
                            Text(entry.lectureName)
                                .font(.system(size: 18))
                            Text("あと0日5時間30分")
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        }
                        Text(entry.assignmentInfo)
                            .font(.system(size: 16))
                    }
                    
                }
                
            }
        }
        
        
    }
}
