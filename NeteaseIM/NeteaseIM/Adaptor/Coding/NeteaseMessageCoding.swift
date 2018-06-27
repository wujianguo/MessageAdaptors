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

class NeteaseMessageCustomAttachment<CustomType: MessageCustomObject>: NSObject, NIMCustomAttachment {
    
    var object: CustomType? = nil
    
    init(object: CustomType) {
        self.object = object
        super.init()
    }
    
    func encode() -> String {
        if let object = object {
            do {
                let data = try JSONEncoder().encode(object)
                if let str = String(bytes: data, encoding: .utf8) {
                    return str
                }
            } catch {
                
            }
        }
        return ""
    }
    
}


class NeteaseMessageCustomCoding: NSObject, NeteaseMessageCoding, NIMCustomAttachmentCoding {
    
    func encode(message: NeteaseMessageObject) -> NIMMessage? {
        return nil
    }
    
    func decode(message: NIMMessage) -> MessageKind? {
        guard let object = message.messageObject as? NIMCustomObject else {
            return nil
        }
        for adapt in MessageCustomLayoutManager.cellAdaptors {
            if adapt.objectType == type(of: object.attachment) {
                return .custom(object.attachment)
            }
        }

        return .custom(object.attachment)
    }

    func decodeAttachment(_ content: String?) -> NIMCustomAttachment? {
        guard let data = content?.data(using: .utf8) else {
            return nil
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any> else {
            return nil
        }
        guard let type = json?["type"] as? Int else {
            return nil
        }
        for adap in MessageCustomLayoutManager.cellAdaptors {
            if adap.objectType.type == type {
                if let object = try? JSONDecoder().decode(adap.objectType, from: data) {
                    return NeteaseMessageCustomAttachment(object: object)
                }
                return nil
            }
        }

        return nil
    }
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


class NeteaseMessageCoder {
    
    var coders = [NeteaseMessageCoding]()
    
    init() {
        coders = [
            NeteaseMessageTextCoding(),
            NeteaseMessagePhotoCoding(),
            NeteaseMessageVideoCoding(),
            NeteaseMessageLocationCoding(),
            NeteaseMessageNotificationCoding(),
            NeteaseMessageCustomCoding(),
        ]
    }
    

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

}
