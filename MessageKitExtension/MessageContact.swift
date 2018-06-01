//
//  MessageContact.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/29.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

protocol MessageContact {
    
    var friends: [MessageUser] { get }
    
    func loadFriends(complete: Completion?)
    
//    func requestFriend()
    
//    func acceptFriend()
    
//    func denyFriend()
}
