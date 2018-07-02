//
//  MessageHUD.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/7/2.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import PKHUD

struct MessageHUD {
    
    static func startLoading() {
        HUD.show(.systemActivity)
    }
    
    static func stopLoading(error: Error?) {
        if let error = error {
            HUD.hide(animated: false)
            HUD.flash(.label("\(error)"))
        } else {
            HUD.hide()
        }
    }
    
}
