//
//  RequestFriendViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/29.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit
import SnapKit

class RequestFriendViewController<AccountType: MessageAccount>: SettingsTableViewController {

    let account: AccountType
    
    init(account: AccountType) {
        self.account = account
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let inputId = SettingsType(kind: .textField(Strings.inputAccount), delegate: SettingsTextFieldTableViewCellTypeInfo())
        let confirm = SettingsType(kind: .button(Strings.ok, nil), delegate: SettingsButtonTableViewCellTypeInfo(selection: { (type) in
            if let text = inputId.delegate.textValue {
                self.account.contact.fetchUserInfo(id: text, complete: { (user, error) in
                    guard let user = user else {
                        return
                    }
                    let vc = UserTableViewController<AccountType>(account: self.account, user: user)
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }))
        
        settings = [
            inputId,
            confirm
        ]

        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
