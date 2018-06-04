//
//  NeteaseMessageTextCoding.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/4.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit

class NeteaseMessageTextCoding: NeteaseMessageCoding {
    
    func encode(message: NeteaseMessageObject) -> NIMMessage? {
        guard let text = message.kind.text else {
            return nil
        }
        let ret = NIMMessage()
        ret.text = text
        return ret
    }
    
    func decode(message: NIMMessage) -> MessageKind? {
        guard let text = message.text else {
            return nil
        }
        return .text(text)
    }
}
