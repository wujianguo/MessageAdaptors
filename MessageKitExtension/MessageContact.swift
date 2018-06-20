//
//  MessageContact.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/29.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

protocol MessageContactNotification {
    
}

protocol MessageContact {
    
    var notifications: [MessageContactNotification] { get }
    
    var friends: [MessageUser] { get }
    
    func loadFriends(complete: Completion?)
    
    func isMyFriend(id: String) -> Bool
    
    func fetchUserInfo(id: String, complete: @escaping (MessageUser?, Error?) -> Void)
    
    func requestFriend(id: String, message: String?, complete: @escaping Completion)
    
//    func acceptFriend()
    
//    func denyFriend()
}
