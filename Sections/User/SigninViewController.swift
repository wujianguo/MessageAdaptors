//
//  SigninViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/5.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit


class SigninViewController<AccountType: MessageAccount>: SettingsTableViewController {

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
        let inputPassword = SettingsType(kind: .textField(Strings.inputPasswordPlaceholder), delegate: SettingsTextFieldTableViewCellTypeInfo(configuration: { (textField) in
            textField.isSecureTextEntry = true
        }))
        let confirm = SettingsType(kind: .button(Strings.signin, nil), delegate: SettingsButtonTableViewCellTypeInfo(selection: { (type) in
            guard let name = inputAccount.delegate.textValue?.trimmingCharacters(in: .whitespaces), let password = inputPassword.delegate.textValue?.trimmingCharacters(in: .whitespaces) else {
                return
            }
            self.signin(name: name, password: password)
        }))
        
        groups = [
            SettingsGroup(settings: [inputAccount, inputPassword]),
            SettingsGroup(settings: [confirm])
        ]
        super.viewDidLoad()
        title = Strings.signin
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.signup, style: .plain, target: self, action: #selector(signupClick(sender:)))
    }
    
    func signin(name: String, password: String) {
        let data = AccountSigninData(name: name, token: password)
        MessageHUD.startLoading()
        account.signin(data: data) { (error) in
            MessageHUD.stopLoading(error: error)
            guard error == nil else {
                return
            }
            let vc = SplitViewController<AccountType>(account: self.account)
            let app = UIApplication.shared.delegate as! AppDelegate
            app.window?.rootViewController = vc
        }
    }
    
    @objc func signupClick(sender: UIBarButtonItem) {
        let vc = SignupViewController<AccountType>(account: account)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
