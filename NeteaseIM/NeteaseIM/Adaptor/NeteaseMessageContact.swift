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
}
