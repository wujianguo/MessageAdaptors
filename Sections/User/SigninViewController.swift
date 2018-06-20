//
//  SigninViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/5.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit
import SnapKit

class SigninViewController<AccountType: MessageAccount>: UIViewController {

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
        title = Strings.signin
        
        view.addSubview(nameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signinButton)
        view.addSubview(signupButton)
        
        nameTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leadingMargin)
            make.top.equalTo(view.snp.topMargin).offset(UIConstants.padding)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leadingMargin)
            make.top.equalTo(nameTextField.snp.bottom).offset(UIConstants.padding/2)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.height.equalTo(40)
        }
        
        signinButton.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leadingMargin)
            make.top.equalTo(passwordTextField.snp.bottom).offset(UIConstants.padding)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.height.equalTo(40)
        }

        signupButton.snp.makeConstraints { (make) in
            make.top.equalTo(signinButton.snp.bottom).offset(UIConstants.padding/2)
            make.trailing.equalTo(view.snp.trailingMargin)
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
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = Strings.inputPasswordPlaceholder
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var signinButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.backgroundColor = UIConstants.themeColor
        button.setTitle(Strings.signin, for: .normal)
        button.addTarget(self, action: #selector(signinClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.themeColor, for: .normal)
        button.setTitle(Strings.signup, for: .normal)
        button.addTarget(self, action: #selector(signupClick(sender:)), for: .touchUpInside)
        return button
    }()

    @objc func signinClick(sender: UIButton) {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespaces), let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        sender.isEnabled = false
        let data = AccountSigninData(name: name, token: password)
        account.signin(data: data) { (error) in
            sender.isEnabled = true
            guard error == nil else {
                return
            }
            let vc = SplitViewController<AccountType>(account: self.account)
//            let vc = MainViewController<AccountType>(account: self.account)
            let app = UIApplication.shared.delegate as! AppDelegate
            app.window?.rootViewController = vc
        }
    }
    
    @objc func signupClick(sender: UIButton) {
        let vc = SignupViewController<AccountType>(account: account)
        navigationController?.pushViewController(vc, animated: true)
    }
}
