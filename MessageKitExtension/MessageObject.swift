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
    
    var messageContent: String {
        switch self {
        case .text(let text):
            return text
        default:
            break
        }
        return Strings.NotSupportYet
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
/*
protocol MessageDecodable {

    init(from decoder: MessageDecoder) throws

}

protocol MessageEncodable {
    
    func encode(to encoder: MessageEncoder) throws

}

typealias MessageCodable = MessageDecodable & MessageEncodable
*/
