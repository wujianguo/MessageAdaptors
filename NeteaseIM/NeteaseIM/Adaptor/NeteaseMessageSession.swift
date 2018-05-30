//
//  NeteaseMessageSession.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/7.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

extension NIMSessionType {
    
    func toType() -> MessageSessionType {
        switch self {
        case .P2P:
            return .P2P
        case .team:
            return .Team
        case .chatroom:
            return .Chatroom
        }
    }
    
}

class NeteaseMessageSession: MessageSession {
    
    typealias ObjectType = NeteaseMessageObject
    
    var sessionType: MessageSessionType
    
    var id: String {
        return info.id
    }

    var displayName: String {
        return info.displayName
    }
    
    var avatarURL: URL {
        return info.avatarURL
    }
    
    var user: MessageUser {
        return info
    }
    
    var lastMessage: NeteaseMessageObject? = nil
    
    var messages = [NeteaseMessageObject]()
    
    var session: NIMSession
    
    var consumers = [MessageConsumer]()
        
    var info: NeteaseMessageUser

    init(recent: NIMRecentSession) {
        if let last = recent.lastMessage {
            self.lastMessage = NeteaseMessageObject(message: last)
        }
        sessionType = recent.session!.sessionType.toType()
        let sessionId = recent.session?.sessionId ?? ""
        self.session = recent.session!
        info = NeteaseMessageUser(id: sessionId, displayName: sessionId, avatarURL: DefaultAvatarURL)
        info = fetchUserInfo(session: recent.session!)
    }
    
    func fetchUserInfo(session: NIMSession) -> NeteaseMessageUser {
        var info: NeteaseMessageUser? = nil
        switch session.sessionType {
        case .P2P:
            info = p2pUserInfo(session: session)
        default:
            info = teamUserInfo(session: session)
        }
        if let info = info {
            return info
        } else {
            let sessionId = session.sessionId
            return NeteaseMessageUser(id: sessionId, displayName: sessionId, avatarURL: DefaultAvatarURL)
        }
    }
    
    func p2pUserInfo(session: NIMSession) -> NeteaseMessageUser? {
        if let user = NIMSDK.shared().userManager.userInfo(session.sessionId) {
            return NeteaseMessageUser(id: id, displayName: user.userInfo?.nickName ?? id, avatarURL: URL(string: user.userInfo?.avatarUrl ?? "") ?? DefaultAvatarURL)
        } else {
            NIMSDK.shared().userManager.fetchUserInfos([session.sessionId]) { (users, error) in
                
            }
            return nil
        }
    }
    
    func teamUserInfo(session: NIMSession) -> NeteaseMessageUser? {
        if let team = NIMSDK.shared().teamManager.team(byId: session.sessionId) {
            return NeteaseMessageUser(id: id, displayName: team.teamName ?? id, avatarURL: URL(string: team.avatarUrl ?? "") ?? DefaultAvatarURL)
        } else {
            NIMSDK.shared().teamManager.fetchTeamInfo(session.sessionId) { (error, team) in
                
            }
            return nil
        }
    }
    
    func onRecv(message: NIMMessage) {
        let msg = NeteaseMessageObject(message: message)
        lastMessage = msg
        messages.append(msg)
        for consumer in consumers {
            consumer.on(sessionId: id, recv: [msg])
        }
    }
    
    func fetchLocalHistory() -> [NeteaseMessageObject] {
        var history = [NeteaseMessageObject]()
        if let msgs = NIMSDK.shared().conversationManager.messages(in: session, message: messages.last?.message, limit: 100) {
            for msg in msgs {
                history.append(NeteaseMessageObject(message: msg))
            }
            messages.insert(contentsOf: history, at: 0)
        }
        return history
    }
    
    func fetchRemoteHistory(complete: @escaping ([ObjectType], Error?) -> Void) {
        DispatchQueue.main.async {
            complete([], nil)
        }
    }
}
