//
//  Updater.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/19.
//

import Foundation

func toggleIsFinished(kadaiList: [Kadai], kid: String) -> [Kadai] {
    var toggledKadaiList = [Kadai]()
    for var kadaiEntry in kadaiList {
        if kadaiEntry.id == kid {
            if kadaiEntry.isFinished {
                BadgeCount.shared.badgeCount += 1
            }else{
                BadgeCount.shared.badgeCount -= 1
            }
            kadaiEntry.isFinished = !kadaiEntry.isFinished
        }
        toggledKadaiList.append(kadaiEntry)
    }
    
    Saver.shared.saveKadaiListToStorage(kadaiList: toggledKadaiList)
    
    return toggledKadaiList
}
