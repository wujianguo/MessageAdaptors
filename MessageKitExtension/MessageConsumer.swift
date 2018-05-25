//
//  MessageConsumer.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/7.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation


protocol MessageConsumer {
    
    func on(sessionId: String, recv messages: [MessageObject])
    
    var hashValue: Int { get }
    
}
