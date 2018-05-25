//
//  NeteaseMessageSession.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/7.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation


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
    
    var messages = [NeteaseMessageObject]()
    
    var session: NIMSession
    
    var consumers = [MessageConsumer]()
    
//    var user: MessageUser {
//        return info
//    }
    
    var info: NeteaseMessageUser

    
    init(session: NIMSession) {
        sessionType = .P2P
        info = NeteaseMessageUser(id: session.sessionId, displayName: session.sessionId, avatarURL: DefaultAvatarURL)
        self.session = session
    }
    
    init(recent: NIMRecentSession) {
        sessionType = .P2P
        let sessionId = recent.session?.sessionId ?? ""
        self.session = recent.session!
        info = NeteaseMessageUser(id: sessionId, displayName: sessionId, avatarURL: DefaultAvatarURL)
        info = fetchUserInfo(session: recent.session!)
    }
    
    func fetchUserInfo(session: NIMSession) -> NeteaseMessageUser {
        if let user = userInfo(session: session) {
            return NeteaseMessageUser(id: id, displayName: user.userInfo?.nickName ?? id, avatarURL: URL(string: user.userInfo?.avatarUrl ?? "") ?? DefaultAvatarURL)
        } else {
            let sessionId = session.sessionId
            return NeteaseMessageUser(id: sessionId, displayName: sessionId, avatarURL: DefaultAvatarURL)
        }
    }
    
    func userInfo(session: NIMSession) -> NIMUser? {
        switch session.sessionType {
        case .P2P:
            return NIMSDK.shared().userManager.userInfo(session.sessionId)
        default:
            break
        }
        return nil
    }
    
    func onRecv(message: NIMMessage) {
        let msg = NeteaseMessageObject(message: message)
        messages.append(msg)
        for consumer in consumers {
            consumer.on(sessionId: id, recv: [msg])
        }
    }
}
