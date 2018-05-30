//
//  MessageSession.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/7.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

enum MessageSessionType {
    case P2P
    case Team
    case Chatroom
}

protocol MessageSession {
    
    associatedtype ObjectType: MessageObject
    
    var sessionType: MessageSessionType { get }
    
    var lastMessage: ObjectType? { get set }
    
    var messages: [ObjectType] { get set }
    
    var consumers: [MessageConsumer] { get set }
    
    var id: String { get }
    
    var displayName: String { get }
    
    var avatarURL: URL { get }
    
    var user: MessageUser { get }
    
    func fetchLocalHistory() -> [ObjectType]

    func fetchRemoteHistory(complete: @escaping ([ObjectType], Error?) -> Void)
}

extension MessageSession {
    
    mutating func add(consumer: MessageConsumer) {
        for cs in consumers {
            if cs.hashValue == consumer.hashValue {
                return
            }
        }
        consumers.append(consumer)
    }
    
    mutating func remove(consumer: MessageConsumer) {
        for i in 0..<consumers.count {
            if consumer.hashValue == consumers[i].hashValue {
                consumers.remove(at: i)
                break
            }
        }
    }
}

protocol MessageRecentSession {
    
}
