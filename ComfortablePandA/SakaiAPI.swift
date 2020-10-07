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

enum Login: Error {
    case Network
    case LTNotFound
}


final class SakaiAPI {
    
    static let shared = SakaiAPI()
    
    func getLoginToken() -> String? {
        
        let urlString = "https://cas.ecs.kyoto-u.ac.jp/cas/login?service=https%3A%2F%2Fpanda.ecs.kyoto-u.ac.jp%2Fsakai-login-tool%2Fcontainer"
        let url = URL(string: urlString)!

        var loginToken: String?

        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in  //非同期で通信を行う
            do {
                guard let data = data else { throw Login.Network }
                let regex = try! NSRegularExpression(pattern: "<input type=\"hidden\" name=\"lt\" value=\"(.+)\" \\/>");
                let str = String(data: data, encoding: .utf8)!

                guard let result = regex.firstMatch(in: str, options: [], range: NSRange(0..<str.count)) else {
                    throw Login.LTNotFound
                }
                let start = result.range(at: 1).location;
                let end = start + result.range(at: 1).length;
                print(String(str[str.index(str.startIndex, offsetBy: start)..<str.index(str.startIndex, offsetBy: end)]));
                loginToken = String(str[str.index(str.startIndex, offsetBy: start)..<str.index(str.startIndex, offsetBy: end)])
            } catch let error {
                print(error)
            }
            semaphore.signal()
        }
        task.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return loginToken
    }
    
    func login() -> () {
        let url = URL(string: "https://cas.ecs.kyoto-u.ac.jp/cas/login?service=https%3A%2F%2Fpanda.ecs.kyoto-u.ac.jp%2Fsakai-login-tool%2Fcontainer")!  //URLを生成
        let lt = getLoginToken()!
        let data : Data = "_eventId=submit&execution=e1s1&lt=\(lt)&password=8-8&username=8".data(using: .utf8)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.httpBody = data
        
        

        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("data is nil")
                return
            }
            
//            print(String(data: data, encoding: .utf8))
            semaphore.signal()
        }
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
    }
    

    func fetchAssignmentsFromPandA() -> [AssignmentEntry]? {
        login()
        
//        let urlString = "https://das82.com/my2.json"
        let urlString = "https://panda.ecs.kyoto-u.ac.jp/direct/assignment/my.json"
        let url = URL(string: urlString)!
        
        var assignmentEntry: [AssignmentEntry]?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("data is nil")
                return
            }
//            print(String(data: data, encoding: .utf8))
            guard let kadaiList = try? JSONDecoder().decode(AssignmentCollection.self, from: data) else {
                print("cannnot get kadai")
                return
            }
            
            assignmentEntry = kadaiList.assignment_collection
            semaphore.signal()
        }
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        print("load kadaiList from panda")
        
        Saver.shared.saveKadaiFetchedTimeToStorage()
        
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
        
        print("load lecID from panda")
        
        return lectureEntry
    }
    
    
    func getRawKadaiList() -> [AssignmentEntry] {
        var kadaiList: [AssignmentEntry]

        kadaiList = SakaiAPI.shared.fetchAssignmentsFromPandA()!

        return kadaiList
    }
    
    func getLectureInfoList() -> [LectureInfo] {
        var lectureInfoList: [LectureInfo]

        lectureInfoList = SakaiAPI.shared.fetchLectureInfoFromPandA()!
        Saver.shared.saveLectureInfoToStorage(lectureInfoList: lectureInfoList)

        return lectureInfoList
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

