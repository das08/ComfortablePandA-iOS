//
//  HeaderView.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/02.
//

import SwiftUI

struct HeaderView: View {
    let updatedTime: String
    init(updatedTime: String) {
        self.updatedTime = updatedTime
    }

    var body: some View {
        VStack(alignment:.leading ,spacing: 15) {
            HStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, alignment: .center)
                    .padding(.leading, 5)
                    .padding(.trailing, 16)
                Spacer()
                Text(updatedTime)
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .padding(16)
            }.frame(height: 40, alignment: .topLeading)
        }
    }
}
