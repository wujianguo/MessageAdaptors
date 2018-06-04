//
//  NeteaseMessageLocationCoding.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/4.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit
import class CoreLocation.CLLocation

class NeteaseMessageLocationCoding: NeteaseMessageCoding {
    
    func encode(message: NeteaseMessageObject) -> NIMMessage? {
        return nil
    }
    
    func decode(message: NIMMessage) -> MessageKind? {
        guard let object = message.messageObject as? NIMLocationObject else {
            return nil
        }
        let item = MessageLocationItem(location: CLLocation(latitude: object.latitude, longitude: object.longitude), size: CGSize(width: 100, height: 100))
        return .location(item)
    }
    
    
}
