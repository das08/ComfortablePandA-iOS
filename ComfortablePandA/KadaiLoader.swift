//
//  KadaiLoader.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/04.
//

import Foundation
//import SwiftUI

internal func getKadaiFromPandA() -> [Kadai] {
    return [
        Kadai(id: "001", lectureName: "電気電子工学基礎実験", assignmentInfo: "第２週予習課題（19~21班）", dueDate: generateDate(y: 2020, mo: 10, d: 4, h: 16, min: 0), isFinished: false),
        Kadai(id: "002", lectureName: "電気電子数学1", assignmentInfo: "Assignment 1", dueDate: generateDate(y: 2020, mo: 10, d: 6, h: 9, min: 0), isFinished: false),
        Kadai(id: "003", lectureName: "電気電子計測", assignmentInfo: "第1回レポート", dueDate: generateDate(y: 2020, mo: 10, d: 10, h: 9, min: 0), isFinished: false),
        Kadai(id: "004", lectureName: "電気電子計測", assignmentInfo: "第1回レポート", dueDate: generateDate(y: 2020, mo: 10, d: 10, h: 9, min: 0), isFinished: false),
        Kadai(id: "005", lectureName: "電磁気学1", assignmentInfo: "確認問題１", dueDate: generateDate(y: 2020, mo: 10, d: 20, h: 9, min: 0), isFinished: false)
    ]
}

class GetKadaiFromPandA {
    func loadKadai(completion: @escaping (SakaiAssignment?)->Void){
        let url: URL = URL(string: "https://das82.com/my.json")!
        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            
            var result: SakaiAssignment?
            do {
                result = try JSONDecoder().decode(SakaiAssignment.self, from: data!)
                completion(result)
                
            }
            catch {
                print("error:", error.localizedDescription)
                completion(SakaiAssignment())
            }

        })
        task.resume()
        
    }
}


