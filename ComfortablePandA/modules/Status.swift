//
//  Status.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/22.
//

import Foundation

struct LoginStatus {
    var success = true
    var errorMsg = ""
    var error: Login = Login.Default
}

struct KadaiFetchStatus {
    var success = true
    var errorMsg = ""
    var rawKadaiList: [AssignmentEntry]?
}
