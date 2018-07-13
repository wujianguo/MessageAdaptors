//
//  SignupViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/5.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit


class SignupViewController<AccountType: MessageAccount>: StaticTableViewController, UITextFieldDelegate {
    
    let account: AccountType!
    
    init(account: AccountType) {
        self.account = account
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var accountCell: InputTextFieldTableViewCell!
    var nickCell: InputTextFieldTableViewCell!
    var passwordCell: InputTextFieldTableViewCell!
    var signupButton: ActivityIndicatorTextButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.signup

        let inputSection = StaticTableSection()
        accountCell = InputTextFieldTableViewCell(style: .default, reuseIdentifier: nil)
        accountCell.onConfig = {
            self.accountCell.selectionStyle = .none
            self.accountCell.textField.keyboardType = .asciiCapable
            self.accountCell.textField.returnKeyType = .next
            self.accountCell.textField.delegate = self
            self.accountCell.label.text = Strings.account
        }
        
        nickCell = InputTextFieldTableViewCell(style: .default, reuseIdentifier: nil)
        nickCell.onConfig = {
            self.nickCell.selectionStyle = .none
            self.nickCell.textField.keyboardType = .namePhonePad
            self.nickCell.textField.returnKeyType = .next
            self.nickCell.textField.delegate = self
            self.nickCell.label.text = Strings.nickName
        }

        passwordCell = InputTextFieldTableViewCell(style: .default, reuseIdentifier: nil)
        passwordCell.onConfig = {
            self.passwordCell.selectionStyle = .none
            self.passwordCell.label.text = Strings.password
            self.passwordCell.textField.isSecureTextEntry = true
            self.passwordCell.textField.returnKeyType = .join
            self.passwordCell.textField.delegate = self
        }
        inputSection.cells = [accountCell, nickCell, passwordCell]
        
        sections = [inputSection]
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        signupButton = ActivityIndicatorTextButton(title: Strings.signup, loadingTitle: Strings.signup)
        signupButton.addTarget(self, action: #selector(signupClick(sender:)), for: .touchUpInside)
        
        footer.addSubview(signupButton)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        footer.addConstraint(NSLayoutConstraint(item: signupButton, attribute: .top, relatedBy: .equal, toItem: footer, attribute: .top, multiplier: 1, constant: 0))
        footer.addConstraint(NSLayoutConstraint(item: signupButton, attribute: .bottom, relatedBy: .equal, toItem: footer, attribute: .bottom, multiplier: 1, constant: 0))
        footer.addConstraint(NSLayoutConstraint(item: signupButton, attribute: .leading, relatedBy: .equal, toItem: footer, attribute: .leadingMargin, multiplier: 1, constant: 0))
        footer.addConstraint(NSLayoutConstraint(item: signupButton, attribute: .trailing, relatedBy: .equal, toItem: footer, attribute: .trailingMargin, multiplier: 1, constant: 0))
        
        tableView.tableFooterView = footer
        
        accountCell.textField.becomeFirstResponder()
    }
    
    func signup(name: String, nick: String, password: String, complete: (() -> Void)? = nil) {
        let data = AccountSignupData(username: name, password: password, nickname: nick)
        account.signup(data: data) { (error) in
            MessageHUD.stopLoading(error: error)
            complete?()
            guard error == nil else {
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func signupClick(sender: ActivityIndicatorTextButton) {
        guard let name = accountCell.textField.text?.trimmingCharacters(in: .whitespaces), let nick = nickCell.textField.text?.trimmingCharacters(in: .whitespaces), let password = passwordCell.textField.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        guard name.count > 0 && password.count > 0 && nick.count > 0 else {
            return
        }
        accountCell.textField.isEnabled = false
        nickCell.textField.isEnabled = false
        passwordCell.textField.isEnabled = false
        sender.startLoading()
        
        signup(name: name, nick: nick, password: password) {
            sender.stopLoading()
            self.accountCell.textField.isEnabled = true
            self.nickCell.textField.isEnabled = true
            self.passwordCell.textField.isEnabled = true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountCell.textField {
            nickCell.textField.becomeFirstResponder()
        } else if textField == nickCell.textField {
            passwordCell.textField.becomeFirstResponder()
        } else if textField == passwordCell.textField {
            if signupButton.isEnabled {
                signupClick(sender: signupButton)
            }
        }
        return true
    }
}

/*
class Signup2ViewController<AccountType: MessageAccount>: SettingsTableViewController {

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
        MessageHUD.startLoading()
        account.signup(data: data) { (error) in
            MessageHUD.stopLoading(error: error)
            guard error == nil else {
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
*/
