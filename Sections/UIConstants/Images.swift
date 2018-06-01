//
//  Images.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/23.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import UIKit

struct Images {
    
}

// session
extension Images {
    
    static let User    = UIImage(named: "message_user_icon")
    static let Group   = UIImage(named: "message_group_icon")

    static func avatarURL(id: String) -> URL {
        return URL(string: "http://i.pravatar.cc/150?u=\(id)")!
    }
}
