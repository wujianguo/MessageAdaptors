//
//  NeteaseMessageObject.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/8.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit
import class CoreLocation.CLLocation


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
            if let object = message.messageObject as? NIMImageObject {
                let placeholder = UIImage()
                var size = object.size
                let m = max(size.width, size.height)
                if m > 100 {
                    let ratio = m / 100.0
                    size = CGSize(width: size.width/ratio, height: size.height/ratio)
                }
                let item = MessageMediaItem(placeholderImage: placeholder, size: size)
                item.url = URL(string: object.url ?? "")
                return .photo(item)
            }
        case .location:
            if let object = message.messageObject as? NIMLocationObject {
                let item = MessageLocationItem(location: CLLocation(latitude: object.latitude, longitude: object.longitude), size: CGSize(width: 100, height: 100))
                return .location(item)
            }
        default:
            break
        }
        if let content = message.apnsContent {
            return .text(content)
        } else {
            return .text(Strings.NotSupportYet)
        }
    }
    
    static func decode(textMessage: NIMMessage) -> NeteaseMessageObject {
        return NeteaseMessageObject(message: textMessage)
    }
    
}


class NeteaseMessageObject: MessageObject {
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    var messageContent: String
    
    var user: MessageUser {
        didSet {

        }
    }
    
    var message: NIMMessage? = nil
    
    init(message: NIMMessage) {
        self.message = message
        messageId = message.messageId
        sentDate = Date(timeIntervalSince1970: message.timestamp)
        kind = NeteaseMessageDecoder.decode(message: message)
        if let content = message.apnsContent {
            messageContent = content
        } else {
            messageContent = kind.messageContent
        }
        if let user = NIMSDK.shared().userManager.userInfo(message.from ?? "") {
            self.user = user
            if user.userInfo == nil {
                NIMSDK.shared().userManager.fetchUserInfos([message.from ?? ""]) { (infos, error) in
                    if let user = infos?.first {
                        self.user = user
                    }
                }
            }
        } else {
            self.user = NIMUser()
            NIMSDK.shared().userManager.fetchUserInfos([message.from ?? ""]) { (infos, error) in
                if let user = infos?.first {
                    self.user = user
                }
            }
        }
        
        func fetchUser(userId: String) {
            NIMSDK.shared().userManager.fetchUserInfos([userId]) { (infos, error) in
                if let user = infos?.first {
                    self.user = user
                }
            }
        }
    }
    
    required init(kind: MessageKind, sender: MessageUser) {
        self.user = sender
        self.kind = kind
        messageId = UUID().uuidString
        sentDate = Date(timeIntervalSinceNow: 0)
        messageContent = kind.messageContent
    }
    
    func encode() -> NIMMessage {
        return NeteaseMessageEncoder.encode(message: self)
    }
}
