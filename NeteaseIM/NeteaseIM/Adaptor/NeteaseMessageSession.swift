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

extension MessageSessionType {

    func toType() -> NIMSessionType {
        switch self {
        case .P2P:
            return .P2P
        case .Team:
            return .team
        case .Chatroom:
            return .chatroom
        }
    }
}

class NeteaseMessageSession: MessageSession {
    
    typealias ObjectType = NeteaseMessageObject
    
    var sessionType: MessageSessionType
    
    var user: MessageUser = NIMUser()
    
    var lastMessage: NeteaseMessageObject? = nil
    
    var messages = [NeteaseMessageObject]()
    
    var session: NIMSession
    
    var consumers = [MessageConsumer]()

    init(recent: NIMRecentSession) {
        if let last = recent.lastMessage {
            self.lastMessage = NeteaseMessageObject(message: last)
        }
        sessionType = recent.session!.sessionType.toType()
        self.session = recent.session!
        self.user = fetchUserInfo(session: self.session)
    }
    
    required init(id: String, type: MessageSessionType) {
        sessionType = type
        session = NIMSession(id, type: type.toType())
        self.user = fetchUserInfo(session: self.session)
    }
    
    func fetchUserInfo(session: NIMSession) -> MessageUser {
        switch session.sessionType {
        case .P2P:
            return p2pUserInfo(session: session)
        default:
            return teamUserInfo(session: session)
        }
    }
    
    func p2pUserInfo(session: NIMSession) -> MessageUser {
        if let user = NIMSDK.shared().userManager.userInfo(session.sessionId) {
            return user
        } else {
            NIMSDK.shared().userManager.fetchUserInfos([session.sessionId]) { (users, error) in
                if let user = users?.first {
                    self.user = user
                }
            }
            return NIMUser()
        }
    }
    
    func teamUserInfo(session: NIMSession) -> MessageUser {
        if let team = NIMSDK.shared().teamManager.team(byId: session.sessionId) {
            return team
        } else {
            NIMSDK.shared().teamManager.fetchTeamInfo(session.sessionId) { (error, team) in
                if let team = team {
                    self.user = team
                }
            }
            return NIMTeam()
        }
    }
    
    func onRecv(array: [NeteaseMessageObject]) {
        lastMessage = array.last
        self.messages.append(contentsOf: array)
        for consumer in consumers {
            consumer.on(sessionId: id, recv: array)
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
