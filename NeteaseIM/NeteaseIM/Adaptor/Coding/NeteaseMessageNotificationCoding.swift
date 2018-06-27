//
//  NeteaseMessageNotificationCoding.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/4.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit


class NeteaseMessageNotificationCoding: NeteaseMessageCoding {

    func encode(message: NeteaseMessageObject) -> NIMMessage? {
        return nil
    }
    
    func decode(message: NIMMessage) -> MessageKind? {
        guard let object = message.messageObject as? NIMNotificationObject else {
            return nil
        }
        var text: String? = nil
        switch object.notificationType {
        case .team:
            guard let content = object.content as? NIMTeamNotificationContent else {
                return nil
            }
            switch content.operationType {
            case .invite:
                text = "invite"
            case .kick:
                text = "kick"
            case .leave:
                text = "leave"
            case .update:
                text = "update"
            case .dismiss:
                text = "dismiss"
            case .applyPass:
                text = "applyPass"
            case .transferOwner:
                text = "transferOwner"
            case .addManager:
                text = "addManager"
            case .removeManager:
                text = "removeManager"
            case .acceptInvitation:
                text = "acceptInvitation"
            case .mute:
                text = "mute"
            }
        default:
            break
        }
        if let text = text {
            return .text(text)
        } else {
            return nil
        }
    }
    
    
    
}
