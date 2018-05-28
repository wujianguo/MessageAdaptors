//
//  NeteaseMessageObject.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/8.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit

extension MessageKind: Hashable {

    public var hashValue : Int {
        return 1
    }
    
    func toInt() -> Int {
        switch self {
        case .text:
            return 1
        case .attributedText:
            return 2
        case .photo:
            return 3
        case .video:
            return 4
        case .location:
            return 5
        case .emoji:
            return 6
        case .custom:
            return 7
        }
    }
    
    public static func == (lhs: MessageKind, rhs: MessageKind) -> Bool {
        return lhs.toInt() == rhs.toInt()
    }

    var messageContent: String {
        switch self {
        case .text(let text):
            return text
        default:
            break
        }
        return ""
    }
}

class NeteaseMessageTextCoder: MessageDecoder, MessageEncoder {
    
    func encode(text: String) -> NIMMessage {
        let ret = NIMMessage()
        ret.text = text
        return ret
    }
    
    func decode(message: NIMMessage) -> MessageKind {
        return .text(message.text ?? "")
    }
    
}

class NeteaseMessageImageCoder: MessageDecoder, MessageEncoder {
    
    func encode(text: String) -> NIMMessage {
        let ret = NIMMessage()
        ret.text = text
        return ret
    }
    
    func decode(message: NIMMessage) -> MessageKind {
        return .text("")
//        let item =
//        return .photo(item)
    }

}

class NeteaseMessageLocationCoder: MessageDecoder, MessageEncoder {
    
}

class NeteaseMessageEncoder {
    
    typealias EncoderFunc = (NeteaseMessageObject) -> NIMMessage

    static let encoders: [Int: EncoderFunc] = [
        1: NeteaseMessageEncoder.encodeText
    ]
    
    static func encodeText(message: NeteaseMessageObject) -> NIMMessage {
        return NIMMessage()
    }
    
    static func encode(message: NeteaseMessageObject) -> NIMMessage {
        let ret = NIMMessage()
        switch message.kind {
        case .text(let text):
            ret.text = text
        default:
            break
        }
        return ret
    }
    
}

class NeteaseMessageDecoder {
    
    static let decoders = ""
    
    static func decode(message: NIMMessage) -> MessageKind {
        switch message.messageType {
        case .text:
            if let text = message.text {
                return .text(text)
            }
        case .image:
            break
        default:
            break
        }
        return .text("[not support yet.]")
    }
    
    static func decode(textMessage: NIMMessage) -> NeteaseMessageObject {
        return NeteaseMessageObject(message: textMessage)
    }
    
}

extension NIMUser: MessageUser {
    
    var id: String {
        return userId ?? ""
    }
    
    var displayName: String {
        return userInfo?.nickName ?? ""
    }
    
    var avatarURL: URL {
        return URL(string: userInfo?.avatarUrl ?? "") ?? DefaultAvatarURL
    }
    
}

class NeteaseMessageObject: MessageObject {
    
    var sender: Sender {
        return Sender(id: user.id, displayName: user.displayName)
    }

    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    var messageContent: String
    
    var user: MessageUser {
        return info
    }
    
    var info: NeteaseMessageUser
    
    init(message: NIMMessage) {
        info = NeteaseMessageUser(id: message.from ?? "", displayName: message.senderName ?? "", avatarURL: DefaultAvatarURL)
        messageId = message.messageId
        sentDate = Date(timeIntervalSince1970: message.timestamp)
        kind = NeteaseMessageDecoder.decode(message: message)
        messageContent = kind.messageContent
        info.info = NIMSDK.shared().userManager.userInfo(user.id)
        if info.info == nil {
            NIMSDK.shared().userManager.fetchUserInfos([user.id]) { (infos, error) in
                self.info.info = infos?.first
            }
        }
    }
    
    required init(kind: MessageKind, sender: MessageUser) {
        self.info = NeteaseMessageUser(id: sender.id, displayName: sender.displayName, avatarURL: sender.avatarURL)
        self.kind = kind
        messageId = UUID().uuidString
        sentDate = Date(timeIntervalSinceNow: 0)
        messageContent = kind.messageContent
    }
    
    func encode() -> NIMMessage {
        return NeteaseMessageEncoder.encode(message: self)
    }
}
