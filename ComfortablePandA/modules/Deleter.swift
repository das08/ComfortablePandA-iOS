//
//  Deleter.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/31.
//

import SwiftUI

func deleteKeychain(account: String) -> deleteResultMessage{
    var result = deleteResultMessage()
    do {
        try Keychain.delete(account: account)
        result.success = true
    }
    catch {
        
    }
    return result
}


struct deleteResultMessage {
    var success: Bool = false
    var errorMsg :Keychain.Errors = Keychain.Errors.keychainError
}
