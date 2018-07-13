//
//  MessageHUD.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/7/2.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import PKHUD

extension Error {
    
    var hudDescription: String {
        if let error = self as? NSError {
            if error.code == 302 {
                return Strings.accountPasswordError
            }
            if let des = error.localizedFailureReason {
                return des
            }
            return error.localizedDescription
        }
        return "\(self)"
    }
    
}

struct MessageHUD {
    
    static func startLoading() {
        HUD.show(.systemActivity)
    }
    
    static func stopLoading(error: Error?) {
        if let error = error {
            HUD.hide(animated: false)
            HUD.flash(.label(error.hudDescription), delay: 2)
        } else {
            HUD.hide()
        }
    }
    
}
