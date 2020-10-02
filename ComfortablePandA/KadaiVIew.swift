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
