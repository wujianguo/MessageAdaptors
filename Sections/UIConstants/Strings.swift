//
//  Strings.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/23.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

struct Strings {
    
}

// tab
extension Strings {
    static let Contact = NSLocalizedString("Contact", comment: "contact")
    static let Me      = NSLocalizedString("Me", comment: "me")
}

// status
extension Strings {
    static let Connecting   = NSLocalizedString("Connecting", comment: "Connecting")
    static let Disconnected = NSLocalizedString("Disconnected", comment: "Disconnected")
}

// message
extension Strings {
    static let NotSupportYet = NSLocalizedString("[not support yet.]", comment: "[not support yet.]")
    static let ID            = NSLocalizedString("ID", comment: "ID")
}

// signin & signup
extension Strings {
    static let inputNamePlaceholder     = NSLocalizedString("user name for login", comment: "input your user name")
    static let inputNickPlaceholder     = NSLocalizedString("input your nick name", comment: "input your nick name")
    static let inputPasswordPlaceholder = NSLocalizedString("input your password", comment: "input your password")
    
    static let Signin           = NSLocalizedString("Sign in", comment: "Sign in")
    static let Signup           = NSLocalizedString("Sign up", comment: "Sign up")
    static let Signout          = NSLocalizedString("Sign out", comment: "Sign out")
    static let confirmSignout   = NSLocalizedString("Are you sure?", comment: "Are you sure?")
}

// contact
extension Strings {
    static let inputAccount  = NSLocalizedString("input account", comment: "input account")
    static let requestFriend = NSLocalizedString("Request friend", comment: "Request friend")
    static let startChat     = NSLocalizedString("Start chat", comment: "Start chat")
}

// common
extension Strings{
    static let ok       = NSLocalizedString("OK", comment: "OK")
    static let cancel   = NSLocalizedString("Cancel", comment: "Cancel")
}
