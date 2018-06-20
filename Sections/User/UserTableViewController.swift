//
//  UserTableViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/23.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class UserTableViewController<AccountType: MessageAccount>: UITableViewController {

    let account: AccountType
    let user: MessageUser
    
    var settings: [SettingsType] = []
    
    init(account: AccountType, user: MessageUser) {
        self.account = account
        self.user = user
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UserHeadTableViewCell.self, forCellReuseIdentifier: UserHeadTableViewCell.identifier())
        
        if account.contact.isMyFriend(id: user.id) {
            let startChat = SettingsType(kind: SettingsKind.button(Strings.startChat, nil), delegate: SettingsButtonTableViewCellTypeInfo(selection: { (type) in
                let session = AccountType.SessionType(id: self.user.id, type: .P2P)
                let vc = SessionViewController<AccountType>(account: self.account, session: session)
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            settings = [
                startChat,
            ]
        } else {
            let addFriend = SettingsType(kind: SettingsKind.button(Strings.requestFriend, nil), delegate: SettingsButtonTableViewCellTypeInfo(selection: { (type) in
                self.account.contact.requestFriend(id: self.user.id, message: nil, complete: { (error) in

                })
            }))
            settings = [
                addFriend,
            ]
        }
        
        for type in settings {
            type.delegate.register(tableView: tableView)
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else {
            return 40
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return settings.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserHeadTableViewCell.identifier(), for: indexPath) as! UserHeadTableViewCell
            cell.user = user
            return cell
        } else {
            let cell = settings[indexPath.row].delegate.dequeueReusableCell(for: indexPath, at: tableView)
            cell.type = settings[indexPath.row]
            return cell;
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            settings[indexPath.row].delegate.didSelect(type: settings[indexPath.row])
        }
    }
}
