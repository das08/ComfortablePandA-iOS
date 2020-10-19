//
//  Notification.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/19.
//

import Foundation
import UserNotifications

func testNotification() -> () {
    // 1.
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  {
        success, error in
        if success {
            print("authorization granted")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
    
    let content = UNMutableNotificationContent()
    content.title = "Notification Tutorial"
    content.subtitle = "from ioscreator.com"
    content.body = " Notification triggered"
    content.sound = UNNotificationSound.default
    
    
    // 3
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
    
    // 4
    UNUserNotificationCenter.current().add(request)
}

struct Notification {
    var id: String
    var title: String
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    // We have permission!
                }
        }
    }
    
    func addNotification(title: String) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
    }
    
    
}
