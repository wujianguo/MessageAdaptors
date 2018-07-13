//
//  RequestFriendViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/29.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class RequestFriendViewController<AccountType: MessageAccount>: StaticTableViewController, UITextFieldDelegate {
    
    let account: AccountType
    
    init(account: AccountType) {
        self.account = account
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var useridCell: InputTextFieldTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inputSection = StaticTableSection()
        useridCell = InputTextFieldTableViewCell(style: .default, reuseIdentifier: nil)
        useridCell.onConfig = {
            self.useridCell.selectionStyle = .none
            self.useridCell.textField.keyboardType = .asciiCapable
            self.useridCell.textField.returnKeyType = .continue
            self.useridCell.textField.delegate = self
            self.useridCell.label.text = Strings.account
        }

        inputSection.cells = [useridCell]
        
        sections = [inputSection]

        useridCell.textField.becomeFirstResponder()
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return sections[indexPath.section].cells[indexPath.row].height
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    var loading = false
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard loading == false else {
            return true
        }
        if let text = textField.text {
            loading = true
            MessageHUD.startLoading()
            account.contact.fetchUserInfo(id: text, complete: { (user, error) in
                MessageHUD.stopLoading(error: error)
                self.loading = false
                guard let user = user else {
                    return
                }
                let vc = UserTableViewController<AccountType>(account: self.account, user: user)
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }

        return false
    }

}
