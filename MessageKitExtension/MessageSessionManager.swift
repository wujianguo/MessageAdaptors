//
//  MessageSessionManager.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/25.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

protocol MessageSessionManagerDelegate {

    var hashValue: Int { get }

    func on(sessionId: String, lastMessage: MessageObject, from: Int, to: Int)

    func onNewSession(count: Int)
    
    func reload()
}

protocol MessageSessionManager {
    
    associatedtype SessionType: MessageSession

    var recentSessions: [SessionType] { get }
    
    var delegates: [MessageSessionManagerDelegate] { get set }

    func delete(index: Int)
}


extension MessageSessionManager {
    
    mutating func add(delegate: MessageSessionManagerDelegate) {
        for cs in delegates {
            if cs.hashValue == delegate.hashValue {
                return
            }
        }
        delegates.append(delegate)
    }
    
    mutating func remove(delegate: MessageSessionManagerDelegate) {
        for i in 0..<delegates.count {
            if delegate.hashValue == delegates[i].hashValue {
                delegates.remove(at: i)
                break
            }
        }
    }

}
