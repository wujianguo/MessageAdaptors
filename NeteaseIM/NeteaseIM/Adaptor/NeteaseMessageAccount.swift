//
//  NeteaseMessageAccount.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/7.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit

class NeteaseMessageAccount: NSObject, MessageAccount {
    
    static var name: String = "NeteaseIM"
    
    typealias SessionType   = NeteaseMessageSession
    
    typealias ObjectType    = NeteaseMessageObject
    
    typealias ContactType   = NeteaseMessageContact
    
    typealias SessionManagerType = NeteaseSessionManager
    
    var id: String          = ""
    
    var displayName: String = ""
    
    var avatarURL: URL = Images.avatarURL(id: NeteaseMessageAccount.name)
    
    var contact = NeteaseMessageContact()
    
    var status: AccountStatus = .Idle {
        didSet {
            NotificationCenter.default.post(name: AccountStatusChangedNotificationName, object: self, userInfo: ["status": status])
        }
    }
        
    required override init() {
        super.init()
    }
    
    static func canAutoSignin() -> Bool {
        let name = UserDefaults.standard.string(forKey: "name")
        let token = UserDefaults.standard.string(forKey: "token")
        return name != nil && token != nil
    }
    
    func autoSignin(complete: Completion?) {
        guard let name = UserDefaults.standard.string(forKey: "name") else {
            return
        }
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        
//        let name = "justin11"
//        let token = "123456".md5()
        status = .Connecting
        NIMSDK.shared().loginManager.login(name, token: token) { (error) in
            self.displayName = name
            self.id = NIMSDK.shared().loginManager.currentAccount()
            self.onSignin(error: error)
            complete?(error)
        }
    }
    
    func signup(data: AccountSignupData, complete: Completion?) {
        var request = URLRequest(url: URL(string: "https://app.netease.im/api/createDemoUser")!)
        request.httpMethod = "POST"
        request.setValue(NIMSDK.shared().appKey(), forHTTPHeaderField: "appkey")
        request.setValue("nim_demo_ios", forHTTPHeaderField: "User-Agent")
        request.setValue("application/x-www-form-urlencoded;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "username=\(data.username)&nickname=\(data.nickname)&password=\(data.password.md5())".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                complete?(error)
            }
        }
        task.resume()
    }
    
    func signin(data: AccountSigninData, complete: Completion?) {
        NIMSDK.shared().loginManager.login(data.name, token: data.token.md5()) { (error) in
            if error == nil {
                UserDefaults.standard.set(data.name, forKey: "name")
                UserDefaults.standard.set(data.token.md5(), forKey: "token")
            }
            self.displayName = data.name
            self.id = NIMSDK.shared().loginManager.currentAccount()
            self.onSignin(error: error)
            complete?(error)
        }
    }
    
    func signout(complete: Completion?) {
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "token")
//        NIMSDK.shared().chatManager.remove(self)
        NIMSDK.shared().loginManager.logout(complete)
    }
    
    func onSignin(error: Error?) {
        guard error == nil else {
            status = .Disconnected
            return
        }
        
        sessionManager.load()
//        let recentSessions = NIMSDK.shared().conversationManager.allRecentSessions() ?? []
//        for session in recentSessions {
//            let s = NeteaseMessageSession(recent: session)
//            sessions.append(s)
//        }
        
//        NIMSDK.shared().chatManager.add(self)
        status = .Connected
    }
    
    
    func send(message: NeteaseMessageObject, to session: NeteaseMessageSession) {
        session.messages.append(message)
        do {
            try NIMSDK.shared().chatManager.send(message.encode(), to: session.session)
        } catch {
            
        }
    }
    
    
    var sessionManager = NeteaseSessionManager()

    /*
    var sessions = [NeteaseMessageSession]()
    
    
    func onRecvMessages(_ messages: [NIMMessage]) {
        dispatchMessages(messages: messages)
    }
    
    func dispatchMessages(messages: [NIMMessage]) {
        var count = 0
        for session in sessions {
            var array = [NeteaseMessageObject]()
            for message in messages {
                if message.session?.sessionId == session.session.sessionId {
                    count += 1
                    array.append(NeteaseMessageObject(message: message))
                }
            }
            if array.count > 0 {
                session.onRecv(array: array)
            }
            if count == messages.count {
                break;
            }
        }
    }
    */
}
