//
//  SignupViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/5.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class SignupViewController<AccountType: MessageAccount>: UIViewController {

    let account: AccountType!
    
    init(account: AccountType) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        title = Strings.Signup
        
        view.addSubview(nameTextField)
        view.addSubview(nickTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signupButton)
        
        nameTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leadingMargin)
            make.top.equalTo(view.snp.topMargin).offset(UIConstants.padding)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.height.equalTo(40)
        }
        
        nickTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leadingMargin)
            make.top.equalTo(nameTextField.snp.bottom).offset(UIConstants.padding/2)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.height.equalTo(40)
        }

        passwordTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leadingMargin)
            make.top.equalTo(nickTextField.snp.bottom).offset(UIConstants.padding/2)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.height.equalTo(40)
        }
        
        signupButton.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leadingMargin)
            make.top.equalTo(passwordTextField.snp.bottom).offset(UIConstants.padding)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.height.equalTo(40)
        }
    
    }
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Strings.inputNamePlaceholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .asciiCapable
        textField.returnKeyType = .next
        return textField
    }()
    
    lazy var nickTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Strings.inputNickPlaceholder
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .next
        return textField
    }()

    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = Strings.inputPasswordPlaceholder
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.backgroundColor = UIConstants.themeColor
        button.setTitle(Strings.Signup, for: .normal)
        button.addTarget(self, action: #selector(signupClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    @objc func signupClick(sender: UIButton) {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespaces), let nick = nickTextField.text?.trimmingCharacters(in: .whitespaces), let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        sender.isEnabled = false
        let data = AccountSignupData(username: name, password: password, nickname: nick)
        account.signup(data: data) { (error) in
            sender.isEnabled = true
            guard error == nil else {
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }

}
