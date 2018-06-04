//
//  NeteaseMessageAccount.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/7.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit

struct NeteaseRegisterData {
    
    let username: String
    
    let password: String
    
    let nickname: String
}

struct NeteaseLoginData {
    
    let name: String
    
    let token: String

}


class NeteaseMessageAccount: NSObject, MessageAccount, NIMChatManagerDelegate {    
    
    static var name: String = "NeteaseIM"
    
    typealias SessionType = NeteaseMessageSession
    
    typealias ObjectType  = NeteaseMessageObject
    
    typealias ContactType = NeteaseMessageContact
    
    var id: String = ""
    
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
    
    func autoLogin(complete: Completion?) {
        let name = "justin11"
        let token = "e10adc3949ba59abbe56e057f20f883e"
        status = .Connecting
        NIMSDK.shared().loginManager.login(name, token: token) { (error) in
            self.displayName = name
            self.id = NIMSDK.shared().loginManager.currentAccount()
            self.onLogin(error: error)
            complete?(error)
        }
    }
    
    func register(data: NeteaseRegisterData, complete: Completion?) {
        
    }
    
    func login(data: NeteaseLoginData, complete: Completion?) {
        NIMSDK.shared().loginManager.login(data.name, token: data.token) { (error) in
            self.onLogin(error: error)
            complete?(error)
        }
    }
    
    func logout(complete: Completion?) {
        NIMSDK.shared().chatManager.remove(self)
        NIMSDK.shared().loginManager.logout(complete)
    }
    
    func onLogin(error: Error?) {
        guard error == nil else {
            status = .Disconnected
            return
        }
        
        let recentSessions = NIMSDK.shared().conversationManager.allRecentSessions() ?? []
        for session in recentSessions {
            let s = NeteaseMessageSession(recent: session)
            sessions.append(s)
        }
        
        NIMSDK.shared().chatManager.add(self)
        status = .Connected
    }
    
    
    func send(message: NeteaseMessageObject, to session: NeteaseMessageSession) {
        session.messages.append(message)
        do {
            try NIMSDK.shared().chatManager.send(message.encode(), to: session.session)
        } catch {
            
        }
    }

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
}
