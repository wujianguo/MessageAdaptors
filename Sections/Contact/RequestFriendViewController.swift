//
//  RequestFriendViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/29.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit
import SnapKit

class RequestFriendViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leadingMargin)
            make.top.equalTo(view.snp.topMargin).offset(UIConstants.padding)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.height.equalTo(40)
        }
    }
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = Strings.inputAccountPlaceholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .asciiCapable
        textField.returnKeyType = .done
        return textField
    }()

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
