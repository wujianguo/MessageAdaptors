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
        return .custom("hello")
    }
    
    
    
}
