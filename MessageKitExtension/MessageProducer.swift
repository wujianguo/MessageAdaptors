//
//  MessageProducer.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/7.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

protocol MessageProducer {
    
    associatedtype SessionType: MessageSession
    
    func send(message: SessionType.ObjectType, to session: SessionType)

}


