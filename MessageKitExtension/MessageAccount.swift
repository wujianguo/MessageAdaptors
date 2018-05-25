//
//  MessageAccount.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/7.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit

typealias Completion = (Error?) -> Void

let AccountStatusChangedNotificationName = Notification.Name("AccountStatusChangedNotificationName")

let DefaultAvatarURL = URL(string: "https://dn-coding-net-avatar.qbox.me/4d5b9231-5b44-4ade-b08f-8d1a825aae58.png?imageMogr2/thumbnail/80")!

protocol MessageUser {
    
    var id: String { get }
    
    var displayName: String { get }
    
    var avatarURL: URL { get }
}

//extension Sender: MessageUser {
//
//}

enum AccountStatus {
    
    case Idle
    
    case Connecting

    case Connected

    case Disconnected
}


protocol MessageAccount: MessageUser, MessageProducer where SessionType: MessageSession {
    
    associatedtype ObjectType: MessageObject
    
    static var name: String { get }
    
    init()
    
    
    var status: AccountStatus { get set }

    func sender() -> Sender
    
    func autoLogin(complete: Completion?)
        
    func logout(complete: Completion?)

    
    var sessions: [SessionType] { get set }

    func send(message: ObjectType, to session: SessionType)
    
}

