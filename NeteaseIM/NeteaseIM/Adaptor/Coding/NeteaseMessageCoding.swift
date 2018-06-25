//
//  NeteaseMessageCoding.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/4.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit

protocol NeteaseMessageCoding: MessageCoding {
    
    func encode(message: NeteaseMessageObject) -> NIMMessage?
    
    func decode(message: NIMMessage) -> MessageKind?
    
}

extension MessageKind {

    var typeValue: Int {
        switch self {
        case .text:
            return NIMMessageType.text.rawValue
        case .attributedText:
            return NIMMessageType.text.rawValue
        case .photo:
            return NIMMessageType.image.rawValue
        case .video:
            return NIMMessageType.video.rawValue
        case .location:
            return NIMMessageType.location.rawValue
        case .emoji:
            return NIMMessageType.text.rawValue
        case .custom:
            return NIMMessageType.custom.rawValue
        }
    }

}

protocol NeteaseMessageCustomCoding {
    
}


class NeteaseMessageCoder {
    
    var coders = [NeteaseMessageCoding]()
    
    init() {
        coders = [
            NeteaseMessageTextCoding(),
            NeteaseMessagePhotoCoding(),
            NeteaseMessageVideoCoding(),
            NeteaseMessageLocationCoding(),
            NeteaseMessageNotificationCoding(),
        ]
    }
    
    
    static let customCodings: [NeteaseMessageCustomCoding] = [
        
    ]
    
    static let coders: [Int: NeteaseMessageCoding] = [
        NIMMessageType.text.rawValue: NeteaseMessageTextCoding(),
        NIMMessageType.tip.rawValue: NeteaseMessageTextCoding(),
        NIMMessageType.image.rawValue: NeteaseMessagePhotoCoding(),
        NIMMessageType.video.rawValue: NeteaseMessageVideoCoding(),
        NIMMessageType.location.rawValue: NeteaseMessageLocationCoding(),
        NIMMessageType.notification.rawValue: NeteaseMessageNotificationCoding(),
    ]
    
    static func encode(message: NeteaseMessageObject) -> NIMMessage {
        if let coder = NeteaseMessageCoder.coders[message.kind.typeValue] {
            if let ret = coder.encode(message: message) {
                return ret
            }
        }
        let ret = NIMMessage()
        ret.text = Strings.notSupportYet
        return ret
    }
    
    static func decode(message: NIMMessage) -> MessageKind {
        if let coder = NeteaseMessageCoder.coders[message.messageType.rawValue] {
            if let ret = coder.decode(message: message) {
                return ret
            }
        }
        if let content = message.apnsContent {
            return .text(content)
        } else {
            return .text(Strings.notSupportYet)
        }
    }
    
    static func register(at collectionView: UICollectionView) {
        for customCoding in NeteaseMessageCoder.customCodings {
//            customCoding.register(at: collectionView)
        }
    }

    func dequeueReusableCell(at collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
    }
    
}
