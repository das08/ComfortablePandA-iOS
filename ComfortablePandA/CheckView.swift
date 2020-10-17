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
       
        Image(systemName: isFinished ? "checkmark.square" : "square")
            .onTapGesture {
                toggle()
            }
    }
}

