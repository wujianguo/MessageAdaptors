//
//  NeteaseSessionManager.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/20.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

class NeteaseSessionManager: NSObject, MessageSessionManager, NIMChatManagerDelegate {
    
    typealias SessionType = NeteaseMessageSession

    var recentSessions = [SessionType]()
    
    var delegates = [MessageSessionManagerDelegate]()
    
    deinit {
        NIMSDK.shared().chatManager.remove(self)
    }
    
    func load() {
        let recents = NIMSDK.shared().conversationManager.allRecentSessions() ?? []
        for session in recents {
            let s = NeteaseMessageSession(recent: session)
            recentSessions.append(s)
        }
        
        NIMSDK.shared().chatManager.add(self)
    }
    
    func delete(index: Int) {
        let session = recentSessions[index]
        if let recent = NIMSDK.shared().conversationManager.recentSession(by: session.session) {
            NIMSDK.shared().conversationManager.delete(recent)
        }
        recentSessions.remove(at: index)
    }
    
    func onRecvMessages(_ messages: [NIMMessage]) {
        dispatchMessages(messages: messages)
    }
    
    func dispatchMessages(messages: [NIMMessage]) {
        var count = 0
        var index = 0
//        var from = -1
        for session in recentSessions {
            var array = [NeteaseMessageObject]()
            for message in messages {
                if message.session?.sessionId == session.session.sessionId {
                    count += 1
                    array.append(NeteaseMessageObject(message: message))
//                    from = index
                }
            }
            if array.count > 0 {
                session.onRecv(array: array)
                for delegate in delegates {
                    delegate.on(sessionId: session.id, lastMessage: array.last!, from: index, to: index)
                }
            }
            if count == messages.count {
                break;
            }
            index += 1
        }
        
        if count < messages.count {
            var lastSession: NeteaseMessageSession? = nil
            var insertCount = 0
            for i in count..<messages.count {
                if lastSession == nil || lastSession?.session.sessionId != messages[i].session?.sessionId {
                    if let recent = NIMSDK.shared().conversationManager.recentSession(by: messages[i].session!) {
                        lastSession = NeteaseMessageSession(recent: recent)
                        recentSessions.insert(lastSession!, at: 0)
                        insertCount += 1
                    }
                }
            }
            for delegate in delegates {
                delegate.onNewSession(count: insertCount)
            }
        }
    }

}
