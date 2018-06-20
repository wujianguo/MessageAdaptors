//
//  NeteaseMessageContact.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/30.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

class NeteaseMessageContact: MessageContact {

    var friends: [MessageUser] {
        return NIMSDK.shared().userManager.myFriends() ?? []
    }
    
    func loadFriends(complete: Completion?) {
        complete?(nil)
    }
    
    func isMyFriend(id: String) -> Bool {
        return NIMSDK.shared().userManager.isMyFriend(id)
    }
    
    func fetchUserInfo(id: String, complete: @escaping (MessageUser?, Error?) -> Void) {
        NIMSDK.shared().userManager.fetchUserInfos([id]) { (users, error) in
            complete(users?.first, error)
        }
    }
    
    func requestFriend(id: String, message: String?, complete: @escaping (Error?) -> Void) {
        let request = NIMUserRequest()
        request.userId = id
        request.operation = .request
        request.message = message
        NIMSDK.shared().userManager.requestFriend(request) { (error) in
            complete(error)
        }
    }
}
