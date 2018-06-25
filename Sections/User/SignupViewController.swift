//
//  SignupViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/5.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class SignupViewController<AccountType: MessageAccount>: SettingsTableViewController {

    let account: AccountType!
    
    init(account: AccountType) {
        self.account = account
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        
        let inputAccount = SettingsType(kind: .textField(Strings.inputNamePlaceholder), delegate: SettingsTextFieldTableViewCellTypeInfo(configuration: { (textField) in
            textField.keyboardType = .asciiCapable
        }))
        
        let inputNick = SettingsType(kind: .textField(Strings.inputNickPlaceholder), delegate: SettingsTextFieldTableViewCellTypeInfo(configuration: { (textField) in
            textField.borderStyle = .roundedRect
        }))

        let inputPassword = SettingsType(kind: .textField(Strings.inputPasswordPlaceholder), delegate: SettingsTextFieldTableViewCellTypeInfo(configuration: { (textField) in
            textField.isSecureTextEntry = true
            textField.returnKeyType = .done
        }))
        
        let confirm = SettingsType(kind: .button(Strings.signup, nil), delegate: SettingsButtonTableViewCellTypeInfo(selection: { (type) in
            guard let name = inputAccount.delegate.textValue?.trimmingCharacters(in: .whitespaces), let nick = inputNick.delegate.textValue?.trimmingCharacters(in: .whitespaces), let password = inputPassword.delegate.textValue?.trimmingCharacters(in: .whitespaces) else {
                return
            }
            self.signup(name: name, nick: nick, password: password)
        }))

        groups = [
            SettingsGroup(settings: [inputAccount, inputNick, inputPassword]),
            SettingsGroup(settings: [confirm])
        ]
        
        super.viewDidLoad()
        
        title = Strings.signup
    }
    
    func signup(name: String, nick: String, password: String) {
        let data = AccountSignupData(username: name, password: password, nickname: nick)
        account.signup(data: data) { (error) in
            guard error == nil else {
                print(error!)
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
