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

//let DefaultAvatarURL = URL(string: "https://dn-coding-net-avatar.qbox.me/4d5b9231-5b44-4ade-b08f-8d1a825aae58.png?imageMogr2/thumbnail/80")!


enum AccountStatus {
    
    case Idle
    
    case Connecting

    case Connected

    case Disconnected
}

struct AccountSignupData {
    
    let username: String
    
    let password: String
    
    let nickname: String
}

struct AccountSigninData {
    
    let name: String
    
    let token: String
    
}


protocol MessageAccount: MessageUser, MessageProducer where SessionType: MessageSession {
    
    associatedtype ObjectType: MessageObject
    
    associatedtype ContactType: MessageContact
    
    associatedtype SessionManagerType: MessageSessionManager
    
    static var name: String { get }
    
    init()
    
    var status: AccountStatus { get set }
    
    static func canAutoSignin() -> Bool
    
    func signup(data: AccountSignupData, complete: Completion?)
    
    func signin(data: AccountSigninData, complete: Completion?)
    
    func autoSignin(complete: Completion?)
        
    func signout(complete: Completion?)

    
    var sessionManager: SessionManagerType { get set }
    
//    var sessions: [SessionType] { get set }

    func send(message: ObjectType, to session: SessionType)
    
    var contact: ContactType { get }
}

extension MessageAccount {
    
    func sender() -> Sender {
        return Sender(id: id, displayName: displayName)
    }

}
