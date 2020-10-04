//
//  SakaiAssignment.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/04.
//
import Foundation

final class SakaiAPI {
    
    static let shared = SakaiAPI()
    
    func fetchAssignmentsFromPandA(completion: @escaping ([AssignmentEntry]) -> ()) {
        
        let urlString = "https://das82.com/my.json"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("data is nil")
                return
            }
            
            guard let kadaiList = try? JSONDecoder().decode(SakaiAssignment.self, from: data) else {
                print("cannnot get kadai")
                return
            }
            
            completion(kadaiList.assignment_collection)
//            print(kadaiList.assignment_collection)
//            print("success")
        }
        task.resume()
    }
    
    enum SakaiError: Error{
        case url
    }
    
    func fetchAssignmentsFromPandA2() -> [AssignmentEntry]? {
        
        let urlString = "https://das82.com/my.json"
        let url = URL(string: urlString)!
        
        var assignmentEntry: [AssignmentEntry]?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("data is nil")
                return
            }
            
            guard let kadaiList = try? JSONDecoder().decode(SakaiAssignment.self, from: data) else {
                print("cannnot get kadai")
                return
            }
            
            assignmentEntry = kadaiList.assignment_collection
            semaphore.signal()
        }
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return assignmentEntry
    }
    
    func getKK() -> [AssignmentEntry] {
        var kadaiList = [AssignmentEntry]()
        let anonymousFunc = { (fetchedKadaiList: [AssignmentEntry]) in
            
            kadaiList = fetchedKadaiList
//            print(kadaiList)
            
            
        }
        print(kadaiList)
        DispatchQueue.main.async {
            SakaiAPI.shared.fetchAssignmentsFromPandA(completion: anonymousFunc)
        }
        
        return kadaiList
    }
    
    func getLL() -> [AssignmentEntry] {
        var kadaiList: [AssignmentEntry]

        kadaiList = SakaiAPI.shared.fetchAssignmentsFromPandA2()!

        return kadaiList
    }
}

struct SakaiAssignment: Codable {
    let assignment_collection: [AssignmentEntry]
}

struct AssignmentEntry: Codable, Identifiable {
    let context: String
    let id: String
    let title: String
    let dueTime: AssignmentEntryDueTime
}

struct AssignmentEntryDueTime: Codable {
    let time: Int
}



