//
//  NeteaseMessageColorCoding.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/21.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit


class NeteaseMessageColorObject: MessageCustomObject {
    
}

class NeteaseMessageColorCoding: NeteaseMessageCoding {
    
    func encode(message: NeteaseMessageObject) -> NIMMessage? {
        guard let dict = message.kind.custom as? Dictionary<String, Float> else {
            return nil
        }
        let ret = NIMMessage()
        ret.messageObject = NIMCustomObject()
        return ret
    }
    
    func decode(message: NIMMessage) -> MessageKind? {
        guard let object = message.messageObject as? NIMCustomObject else {
            return nil
        }
        return .custom(nil)
    }
    
    
    
}
