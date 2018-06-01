//
//  NeteaseMessageUser.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/30.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

extension NIMUser: MessageUser {
    
    var id: String {
        return userId ?? ""
    }
    
    var displayName: String {
        return userInfo?.nickName ?? id
    }
    
    var avatarURL: URL {
        return URL(string: userInfo?.avatarUrl ?? "") ?? Images.avatarURL(id: id)
    }
    
}

extension NIMTeam: MessageUser {
    
    var id: String {
        return teamId ?? ""
    }
    
    var displayName: String {
        return teamName ?? ""
    }
    
    var avatarURL: URL {
        return URL(string: avatarUrl ?? "") ?? Images.avatarURL(id: id)
    }
    
}
/*
class NeteaseMessageUser: MessageUser {
    
    var id: String
    
    var displayName: String
    
    var avatarURL: URL
    
    var info: NIMUser? = nil {
        didSet {
            if let userId = info?.userId {
                id = userId
            }
            if let name = info?.userInfo?.nickName {
                displayName = name
            }
            if let avatar = URL(string: info?.userInfo?.avatarUrl ?? "") {
                avatarURL = avatar
            }
        }
    }
    
    init(id: String, displayName: String, avatarURL: URL) {
        self.id = id
        self.displayName = displayName
        self.avatarURL = avatarURL
    }
    
}
*/
