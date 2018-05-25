//
//  MessageObject.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/7.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit


protocol MessageObject: MessageType {
        
    init(kind: MessageKind, sender: MessageUser)
    
    var messageContent: String { get }
    
    var user: MessageUser { get }
}

/*
protocol MessageEncoder {
    
}

protocol MessageDecoder {
    
}

protocol MessageDecodable {

    init(from decoder: MessageDecoder) throws

}

protocol MessageEncodable {
    
    func encode(to encoder: MessageEncoder) throws

}

typealias MessageCodable = MessageDecodable & MessageEncodable
*/
