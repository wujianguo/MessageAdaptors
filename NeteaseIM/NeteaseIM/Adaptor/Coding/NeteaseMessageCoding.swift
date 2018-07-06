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

struct NeteaseMessageWrappedObject: Decodable {
    
    let type: Int
    
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

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any> {
                if let type = json["type"] as? Int {
                    for adap in MessageCustomLayoutManager.cellAdaptors {
                        if adap.type == type {
                            if let value = json["data"] as? Dictionary<String, Any> {
                                if let decodedObject = adap.decode(data: value) {
                                    return decodedObject.kind()
                                }

                            }
                        }
                    }
                }
            }
//            let wrapped = try JSONDecoder().decode(NeteaseMessageWrappedObject.self, from: data)
//            for adap in MessageCustomLayoutManager.cellAdaptors {
//                if adap.type == wrapped.type {
//                    if let decodedObject = adap.decode(data: wrapped.data) {
//                        return decodedObject.kind()
//                    }
//                }
//            }
        } catch {
            print(error)
        }
        return nil
    }

    func decodeAttachment(_ content: String?) -> NIMCustomAttachment? {
        guard let data = content?.data(using: .utf8) else {
            return nil
        }
        let str = String(bytes: data, encoding: .utf8)
        debugPrint(str ?? "")
        return NeteaseMessageCustomAttachment(data: data)
    }
}

class NeteaseMessageCoderManager {
    
    static let coders: [NeteaseMessageCoding] = [
        NeteaseMessageTextCoding(),
        NeteaseMessagePhotoCoding(),
        NeteaseMessageVideoCoding(),
        NeteaseMessageLocationCoding(),
        NeteaseMessageNotificationCoding(),
        NeteaseMessageCustomCoding(),
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
