//
//  NeteaseNotificationManager.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/21.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

class NeteaseNotificationManager: NSObject, MessageNotificationManager, NIMSystemNotificationManagerDelegate {
 
    func load() {
        autoAcceptFriend()
        NIMSDK.shared().systemNotificationManager.add(self)
    }
    
    deinit {
        NIMSDK.shared().systemNotificationManager.remove(self)
    }
    
    
    func autoAcceptFriend() {
        let filter = NIMSystemNotificationFilter()
        filter.notificationTypes = [NSNumber(value: NIMSystemNotificationType.friendAdd.rawValue)]
        if let notifications = NIMSDK.shared().systemNotificationManager.fetchSystemNotifications(nil, limit: 20, filter: filter) {
            for notify in notifications {
                accept(notify: notify)
            }
        }
    }
    
    func accept(notify: NIMSystemNotification) {
        let request = NIMUserRequest()
        request.userId = notify.sourceID!
        request.operation = .verify
        NIMSDK.shared().userManager.requestFriend(request) { (error) in
            
        }
    }
    
    func onReceive(_ notification: NIMSystemNotification) {
        accept(notify: notification)
    }

}
