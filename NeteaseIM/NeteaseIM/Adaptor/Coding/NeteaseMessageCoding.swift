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

/*
extension MessageVoteObject2: NIMCustomAttachment {
    
    func encode() -> String {
        do {
            let data = try JSONEncoder().encode(self)
            if let str = String(bytes: data, encoding: .utf8) {
                return str
            }
        } catch {
            
        }
        return ""
    }

}

extension MessageVoteObject2: Codable {
    
}
*/

class NeteaseMessageCustomAttachment: NSObject, NIMCustomAttachment {
    
    var data: Data? = nil
    
    init(data: Data) {
        self.data = data
        super.init()
    }
    
    func encode() -> String {
        return ""
    }
    
}

struct NeteaseMessageWrappedObject: Codable {
    
    let type: Int
    
//    let data: Codable
    
}

class NeteaseMessageCustomCoding: NSObject, NeteaseMessageCoding, NIMCustomAttachmentCoding {
    
    func encode(message: NeteaseMessageObject) -> NIMMessage? {
        return nil
    }
    
    func decode(message: NIMMessage) -> MessageKind? {
        guard let object = message.messageObject as? NIMCustomObject else {
            return nil
        }
        guard let attachment = object.attachment as? NeteaseMessageCustomAttachment else {
            return nil
        }
        guard let data = attachment.data else {
            return nil
        }

        if let wrapped = try? JSONDecoder().decode(NeteaseMessageWrappedObject.self, from: data) {
            for adap in MessageCustomLayoutManager.cellAdaptors {
                if adap.objectType.type == wrapped.type {
                    if let decodedObject = try? JSONDecoder().decode(adap.objectType, from: data) {
                        return .custom(decodedObject)
                    }
                }
            }
        }
        return nil
    }

    func decodeAttachment(_ content: String?) -> NIMCustomAttachment? {
        guard let data = content?.data(using: .utf8) else {
            return nil
        }
        let str = String(bytes: data, encoding: .utf8)
        print(str)
        return NeteaseMessageCustomAttachment(data: data)
        /*
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any> else {
            return nil
        }
        guard let type = json?["type"] as? Int else {
            return nil
        }
//        guard let content = json?["data"] as? Dictionary<String, Any> else {
//            return nil
//        }
        for adap in MessageCustomLayoutManager.cellAdaptors {
            if adap.objectType.type == type {
                if let object = try? JSONDecoder().decode(adap.objectType, from: data) {
                    return NeteaseMessageCustomAttachment(object: object)
                }
                return nil
            }
        }

        return nil
 */
    }
}
/*
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
*/

class NeteaseMessageCoderManager {
    
    static let coders: [NeteaseMessageCoding] = [
        NeteaseMessageTextCoding(),
        NeteaseMessagePhotoCoding(),
        NeteaseMessageVideoCoding(),
        NeteaseMessageLocationCoding(),
        NeteaseMessageNotificationCoding(),
//        NeteaseMessageCustomCoding(),
    ]
    
    static func encode(message: NeteaseMessageObject) -> NIMMessage {
        for coder in coders {
            if let encodedMessage = coder.encode(message: message) {
                return encodedMessage
            }
        }
        let encodedMessage = NIMMessage()
        encodedMessage.text = Strings.notSupportYet
        return encodedMessage
    }
    
    static func decode(message: NIMMessage) -> MessageKind {
        for coder in coders {
            if let decodedMessage = coder.decode(message: message) {
                return decodedMessage
            }
        }

        if let content = message.apnsContent {
            return .text(content)
        } else {
            return .text(Strings.notSupportYet)
        }
    }
}
/*
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
*/
