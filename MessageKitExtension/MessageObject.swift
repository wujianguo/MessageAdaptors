//
//  MessageObject.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/7.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit

extension MessageKind {
    
//    var typeValue: Int {
//        switch self {
//        case .text:
//            return 1
//        case .attributedText:
//            return 2
//        case .photo:
//            return 3
//        case .video:
//            return 4
//        case .location:
//            return 5
//        case .emoji:
//            return 6
//        case .custom:
//            return 7
//        }
//    }
    
    var messageContent: String {
        switch self {
        case .text(let text):
            return text
        default:
            break
        }
        return Strings.notSupportYet
    }
    
    var text: String? {
        switch self {
        case .text(let text):
            return text
        default:
            return nil
        }
    }
    
    var attributedText: NSAttributedString? {
        switch self {
        case .attributedText(let attributedText):
            return attributedText
        default:
            return nil
        }
    }
    
    var photo: MediaItem? {
        switch self {
        case .photo(let item):
            return item
        default:
            return nil
        }
    }
    
    var video: MediaItem? {
        switch self {
        case .video(let item):
            return item
        default:
            return nil
        }
    }
    
    var location: LocationItem? {
        switch self {
        case .location(let item):
            return item
        default:
            return nil
        }
    }
    
    var emoji: String? {
        switch self {
        case .emoji(let emoji):
            return emoji
        default:
            return nil
        }
    }
    
    var custom: Any? {
        switch self {
        case .custom(let item):
            return item
        default:
            return nil
        }
    }
}

class MessageMediaItem: MediaItem {
    
    var url: URL? = nil
    
    var image: UIImage? = nil
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init(placeholderImage: UIImage, size: CGSize) {
        self.placeholderImage = placeholderImage
        self.size = size
    }
    
}

import class CoreLocation.CLLocation

class MessageLocationItem: LocationItem {
    
    var location: CLLocation
    
    var size: CGSize
    
    init(location: CLLocation, size: CGSize) {
        self.location = location
        self.size = size
    }
}

protocol MessageObject: MessageType {
        
    init(kind: MessageKind, sender: MessageUser)
    
    var messageContent: String { get }
    
    var user: MessageUser { get }
}

extension MessageObject {
    
    var sender: Sender {
        return Sender(id: user.id, displayName: user.displayName)
    }

}


protocol MessageEncoder {
    
}

protocol MessageDecoder {
    
}

typealias MessageCoding = MessageDecoder & MessageEncoder

