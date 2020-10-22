//
//  ErrorMsg.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/22.
//

import Foundation

enum ErrorMsg: String {
    case FailedToLogin = "ログインに失敗しました。"
    case FailedToGetLT = "LTの取得に失敗しました。PandAがダウンしている可能性があります。"
    case FailedToGetResponse = "PandAに接続することができませんでした。時間を開けて再度お試しください。"
    case FailedToGetKeychain = "ECS_IDまたはパスワードが保存されていません。"
    case FailedToGetKadaiList = "課題の取得に失敗しました。"
}
