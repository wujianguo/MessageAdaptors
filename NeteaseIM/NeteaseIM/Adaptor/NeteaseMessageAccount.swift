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
    
}

struct NeteaseLoginData {
    
    let name: String
    
    let token: String

}

class NeteaseMessageUser: MessageUser {
    
    var id: String
    
    var displayName: String
    
    var avatarURL: URL
    
    var info: NIMUser? = nil {
        didSet {
            if let userId = info?.userId {
                id = userId
            }
            if let name = info?.userInfo?.nickName {
                displayName = name
            }
            if let avatar = URL(string: info?.userInfo?.avatarUrl ?? "") {
                avatarURL = avatar
            }
        }
    }
    
    init(id: String, displayName: String, avatarURL: URL) {
        self.id = id
        self.displayName = displayName
        self.avatarURL = avatarURL
    }
    
}

class NeteaseMessageAccount: NSObject, MessageAccount, NIMChatManagerDelegate {    
    
    static var name: String = "NeteaseIM"
    
    typealias SessionType = NeteaseMessageSession
    
    typealias ObjectType  = NeteaseMessageObject
    
    var id: String = ""
    
    var displayName: String = ""
    
    var avatarURL: URL = DefaultAvatarURL
    
    var status: AccountStatus = .Idle {
        didSet {
            NotificationCenter.default.post(name: AccountStatusChangedNotificationName, object: self, userInfo: ["status": status])
        }
    }
    
    func sender() -> Sender {
        return Sender(id: id, displayName: displayName)
    }
    
    required override init() {
        super.init()
    }
    
    func autoLogin(complete: Completion?) {
        let name = "JustinWu"
        let token = "289a18bab6b5b60d9b1ce3c426833a9d"
        status = .Connecting
        NIMSDK.shared().loginManager.login(name, token: token) { (error) in
            self.displayName = name
            self.id = name
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
        for session in sessions {
            for message in messages {
                if message.session?.sessionId == session.session.sessionId {
                    session.onRecv(message: message)
                }
            }
        }
    }
}
