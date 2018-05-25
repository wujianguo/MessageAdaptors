//
//  MessageSessionManager.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/25.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

protocol MessageSessionManagerDelegate {
    
}

protocol MessageSessionManager {
    
    var recentSessions: [MessageRecentSession] { get }
    
    
}
