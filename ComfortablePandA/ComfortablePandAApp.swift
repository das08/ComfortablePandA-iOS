//
//  ComfortablePandAApp.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/02.
//

import SwiftUI

@main
struct ComfortablePandAApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    @AppStorage("badgeCount", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    private var badgeCount: Int = 0
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
        -> Void) {
        completionHandler([[.banner, .list, .sound]])
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        UIApplication.shared.applicationIconBadgeNumber = badgeCount
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self

        return true
    }
}
