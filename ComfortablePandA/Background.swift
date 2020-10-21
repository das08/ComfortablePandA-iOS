//
//  Background.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/21.
//

import SwiftUI
import BackgroundTasks

class BGTask {
    static let shared = BGTask()
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.das08.ComfortablePandA.fetch")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 10)
        
        do {
            // スケジューラーに実行リクエストを登録
            try BGTaskScheduler.shared.submit(request)
            print("success registering schedule")
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        print("handling")
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        let array = [1, 2, 3, 4, 5]
        array.enumerated().forEach { arg in
            let (offset, value) = arg
            let operation = PrintOperation(id: value)
            //            setNotification(title: "📗定期実行2", body: "\(dispDate(date: Date()))")
            if offset == array.count - 1 {
                operation.completionBlock = {
                    task.setTaskCompleted(success: operation.isFinished)
                }
            }
            queue.addOperation(operation)
        }
    }
}
