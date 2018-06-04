//
//  NeteaseMessageObject.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/8.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit
import class CoreLocation.CLLocation


class NeteaseMessageObject: MessageObject {
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    var messageContent: String
    
    var user: MessageUser {
        didSet {

        }
    }
    
    var message: NIMMessage? = nil
    
    init(message: NIMMessage) {
        self.message = message
        messageId = message.messageId
        sentDate = Date(timeIntervalSince1970: message.timestamp)
        kind = NeteaseMessageCoder.decode(message: message)
        if let content = message.apnsContent {
            messageContent = content
        } else {
            messageContent = kind.messageContent
        }
        if let user = NIMSDK.shared().userManager.userInfo(message.from ?? "") {
            self.user = user
            if user.userInfo == nil {
                NIMSDK.shared().userManager.fetchUserInfos([message.from ?? ""]) { (infos, error) in
                    if let user = infos?.first {
                        self.user = user
                    }
                }
            }
        } else {
            self.user = NIMUser()
            NIMSDK.shared().userManager.fetchUserInfos([message.from ?? ""]) { (infos, error) in
                if let user = infos?.first {
                    self.user = user
                }
            }
        }
        
        func fetchUser(userId: String) {
            NIMSDK.shared().userManager.fetchUserInfos([userId]) { (infos, error) in
                if let user = infos?.first {
                    self.user = user
                }
            }
        }
    }
    
    required init(kind: MessageKind, sender: MessageUser) {
        self.user = sender
        self.kind = kind
        messageId = UUID().uuidString
        sentDate = Date(timeIntervalSinceNow: 0)
        messageContent = kind.messageContent
    }
    
    func encode() -> NIMMessage {
        return NeteaseMessageCoder.encode(message: self)
    }
}
