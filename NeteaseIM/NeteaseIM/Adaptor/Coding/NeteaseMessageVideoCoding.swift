//
//  NeteaseMessageVideoCoding.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/4.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit

class NeteaseMessageVideoCoding: NeteaseMessageCoding {
    
    func encode(message: NeteaseMessageObject) -> NIMMessage? {
        return nil
    }
    
    func decode(message: NIMMessage) -> MessageKind? {
        guard let object = message.messageObject as? NIMVideoObject else {
            return nil
        }
        let placeholder = UIImage()
        var size = object.coverSize
        let m = max(size.width, size.height)
        if m > 100 {
            let ratio = m / 100.0
            size = CGSize(width: size.width/ratio, height: size.height/ratio)
        }
        let item = MessageMediaItem(placeholderImage: placeholder, size: size)
        item.url = URL(string: object.url ?? "")
        return .video(item)
    }
    
    
}
