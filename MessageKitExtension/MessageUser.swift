//
//  MessageUser.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/30.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

protocol MessageUser {
    
    var id: String { get }
    
    var displayName: String { get }
    
    var avatarURL: URL { get }
}
