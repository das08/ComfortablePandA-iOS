//
//  SakaiAPIs.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/04.
//
import Foundation

extension Collection where Indices.Iterator.Element == Index {
   public subscript(safe index: Index) -> Iterator.Element? {
    return (startIndex <= index && index < endIndex) ? self[index] : "不明" as! Self.Element
   }
}

final class SakaiAPI {
    
    static let shared = SakaiAPI()
    
    func fetchAssignmentsFromPandA_old(completion: @escaping ([AssignmentEntry]) -> ()) {
        
        let urlString = "https://das82.com/my.json"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("data is nil")
                return
            }
            
            guard let kadaiList = try? JSONDecoder().decode(AssignmentCollection.self, from: data) else {
                print("cannnot get kadai")
                return
            }
            
            completion(kadaiList.assignment_collection)
//            print(kadaiList.assignment_collection)
//            print("success")
        }
        task.resume()
    }
    

    func fetchAssignmentsFromPandA() -> [AssignmentEntry]? {
        
        let urlString = "https://das82.com/my2.json"
        let url = URL(string: urlString)!
        
        var assignmentEntry: [AssignmentEntry]?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("data is nil")
                return
            }
            
            guard let kadaiList = try? JSONDecoder().decode(AssignmentCollection.self, from: data) else {
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
    
    func fetchLectureInfoFromPandA() -> [LectureInfo]? {
        
        let urlString = "https://das82.com/site.json"
        let url = URL(string: urlString)!
        
        var lectureEntry: [LectureInfo]?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("data is nil")
                return
            }
            
            guard let lectureList = try? JSONDecoder().decode(LectureCollection.self, from: data) else {
                print("cannnot get kadai")
                return
            }
            
            lectureEntry = lectureList.site_collection
            semaphore.signal()
        }
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        print("load lecID")
        
        return lectureEntry
    }
    
    func getKK() -> [AssignmentEntry] {
        var kadaiList = [AssignmentEntry]()
        let anonymousFunc = { (fetchedKadaiList: [AssignmentEntry]) in
            
            kadaiList = fetchedKadaiList
//            print(kadaiList)
            
            
        }
        print(kadaiList)
        DispatchQueue.main.async {
            SakaiAPI.shared.fetchAssignmentsFromPandA_old(completion: anonymousFunc)
        }
        
        return kadaiList
    }
    
    func getRawKadaiList() -> [AssignmentEntry] {
        var kadaiList: [AssignmentEntry]

        kadaiList = SakaiAPI.shared.fetchAssignmentsFromPandA()!

        return kadaiList
    }
    
    func getLectureInfoList() -> [LectureInfo] {
        var lectureList: [LectureInfo]

        lectureList = SakaiAPI.shared.fetchLectureInfoFromPandA()!

        return lectureList
    }
    
    
}

struct AssignmentCollection: Codable {
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

struct LectureCollection: Codable {
    let site_collection: [LectureInfo]
}

struct LectureInfo: Codable, Identifiable, Equatable {
    let id: String
    let title: String
}

func findLectureName(lectureInfoList: [LectureInfo], lecID: String) -> String {
    let index = lectureInfoList.firstIndex { $0.id == lecID }
    if index != nil {
        return lectureInfoList[index!].title.components(separatedBy: "]")[safe: 1]!
    }else{
        return "不明"
    }
}

