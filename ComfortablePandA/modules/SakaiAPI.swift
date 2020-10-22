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
    case Default
    case Network
    case LTNotFound
}


final class SakaiAPI {
    
    static let shared = SakaiAPI()
    
    func getLoginToken() -> String? {
        let urlString = "https://cas.ecs.kyoto-u.ac.jp/cas/login?service=https%3A%2F%2Fpanda.ecs.kyoto-u.ac.jp%2Fsakai-login-tool%2Fcontainer"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.timeoutInterval = 6
        var loginToken: String?
        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
            } catch _ {
                
            }
            semaphore.signal()
        }
        task.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return loginToken
    }
    
    func isLoggedin() -> loginStatus {
        var result = loginStatus()
        
        let url = URL(string: "https://panda.ecs.kyoto-u.ac.jp/portal/")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 6
        var isLoggedin = false
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                guard let data = data else { throw Login.Network }
                let regex = try! NSRegularExpression(pattern: "\"loggedIn\": true");
                let str = String(data: data, encoding: .utf8)!
                let result = regex.matches(in: str, options: [], range: NSRange(0..<str.count))
                isLoggedin = result.count > 0
            } catch _ {
                result.success = false
                result.error = Login.Network
            }
            semaphore.signal()
        }
        task.resume()

        _ = semaphore.wait(timeout: .distantFuture)
        
        result.success = isLoggedin
        return result
    }

    func login() -> loginStatus {
        var result = loginStatus()
        
        let lt = getLoginToken()
        var ECS_ID = ""
        var Password = ""
        
        if lt == nil {
            result.success = false
            result.errorMsg = ErrorMsg.FailedToGetLT.rawValue
            return result
        }
        
        if getKeychain(account: "ECS_ID").success && getKeychain(account: "Password").success {
            ECS_ID = getKeychain(account: "ECS_ID").data
            Password = getKeychain(account: "Password").data
        }else{
            result.success = false
            result.errorMsg = ErrorMsg.FailedToGetKeychain.rawValue
            return result
        }
        
//        print("\(ECS_ID), \(Password)")
        let url = URL(string: "https://cas.ecs.kyoto-u.ac.jp/cas/login?service=https%3A%2F%2Fpanda.ecs.kyoto-u.ac.jp%2Fsakai-login-tool%2Fcontainer")!  //URLを生成
        
        let data : Data = "_eventId=submit&execution=e1s1&lt=\(lt!)&password=\(Password)&username=\(ECS_ID)".data(using: .utf8)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.httpBody = data
        
        let semaphore = DispatchSemaphore(value: 0)
        var isLoggedin = false
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let regex = try! NSRegularExpression(pattern: "\"loggedIn\": true");
            let str = String(data: data, encoding: .utf8)!
            let result = regex.matches(in: str, options: [], range: NSRange(0..<str.count))
            isLoggedin = result.count > 0
            semaphore.signal()
        }
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if !isLoggedin { result.errorMsg = ErrorMsg.FailedToLogin.rawValue }
        result.success = isLoggedin
        
        return result
    }
    
    func logout() -> () {
        let url = URL(string: "https://panda.ecs.kyoto-u.ac.jp/portal/logout")!
        let request = URLRequest(url: url)

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            semaphore.signal()
        }
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
    }
    

    func fetchAssignmentsFromPandA() -> kadaiFetchStatus {
        var result = kadaiFetchStatus()
        let loginCheck = isLoggedin()
        if (!loginCheck.success){
            
            if loginCheck.error == Login.Network {
                result.success = false
                result.errorMsg = ErrorMsg.FailedToGetResponse.rawValue
                return result
            }
            
            let loginRes = login()
            print("status: \(loginRes.success)")
            if !loginRes.success {
                result.success = false
                result.errorMsg = loginRes.errorMsg
                return result
            }
        }
        
        let urlString = "https://panda.ecs.kyoto-u.ac.jp/direct/assignment/my.json"
        let url = URL(string: urlString)!
        var assignmentEntry: [AssignmentEntry]?
        let semaphore = DispatchSemaphore(value: 0)
        
        let request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 10.0)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            guard let kadaiList = try? JSONDecoder().decode(AssignmentCollection.self, from: data) else {
                result.success = false
                result.errorMsg = ErrorMsg.FailedToGetKadaiList.rawValue
                return
            }
            assignmentEntry = kadaiList.assignment_collection
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        
        print("Logged in: \(isLoggedin())")
        
        Saver.shared.saveKadaiFetchedTimeToStorage()
        result.rawKadaiList = assignmentEntry
        
        return result
    }
    
    func fetchLectureInfoFromPandA() -> [LectureInfo]? {
        
        let urlString = "https://das82.com/site.json"
        let url = URL(string: urlString)!
        
        var lectureEntry: [LectureInfo]?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
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
        let res = SakaiAPI.shared.fetchAssignmentsFromPandA()
        if res.success {
            kadaiList = res.rawKadaiList!
        }else{
            kadaiList = [AssignmentEntry]()
        }
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
    let instructions: String
}

struct AssignmentEntryDueTime: Codable {
    let time: Int
}

struct loginStatus {
    var success = true
    var errorMsg = ""
    var error: Login = Login.Default
}

struct kadaiFetchStatus {
    var success = true
    var errorMsg = ""
    var rawKadaiList: [AssignmentEntry]?
}


func findLectureName(lectureInfoList: [LectureInfo], lecID: String) -> String {
    let index = lectureInfoList.firstIndex { $0.id == lecID }
    if index != nil {
        return lectureInfoList[index!].title.components(separatedBy: "]")[safe: 1]!
    }else{
        return "不明"
    }
}

