//
//  UserTableViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/23.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit


class UserTableViewController<AccountType: MessageAccount>: StaticTableViewController {
    
    let account: AccountType
    let user: MessageUser
        
    init(account: AccountType, user: MessageUser) {
        self.account = account
        self.user = user
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var headerCell: UserHeadTableViewCell!
    var footerButton: ActivityIndicatorTextButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerCell = UserHeadTableViewCell(style: .default, reuseIdentifier: nil)
        headerCell.onConfig = {
            self.headerCell.user = self.user
        }
        let headerSection = StaticTableSection()
        headerSection.cells = [headerCell]

        sections = [headerSection]
        
        if account.contact.isMyFriend(id: user.id) {
            footerButton = ActivityIndicatorTextButton(title: Strings.startChat, loadingTitle: Strings.startChat)
            footerButton.addTarget(self, action: #selector(startChat(sender:)), for: .touchUpInside)
        } else {
            footerButton = ActivityIndicatorTextButton(title: Strings.requestFriend, loadingTitle: Strings.requestFriend)
            footerButton.addTarget(self, action: #selector(requestFriend(sender:)), for: .touchUpInside)
        }
        layoutFooterButton(button: footerButton)
    }

    @objc func requestFriend(sender: ActivityIndicatorTextButton) {
        let alert = UIAlertController(title: Strings.postscript, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        alert.addAction(UIAlertAction(title: Strings.cancel, style: .cancel, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default, handler: { (action) in
            let message = alert.textFields?.first?.text
            self.footerButton.startLoading()
            self.account.contact.requestFriend(id: self.user.id, message: message, complete: { (error) in
                self.footerButton.stopLoading()
                MessageHUD.tipSuccessOrFailure(error: error)
            })
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func startChat(sender: ActivityIndicatorTextButton) {
        if let vcs = self.navigationController?.viewControllers {
            if vcs.count > 1 {
                if let last = vcs[vcs.count-2] as? SessionViewController<AccountType> {
                    if last.session.id == user.id {
                        navigationController?.popViewController(animated: true)
                        return
                    }
                }
            }
        }
        let session = AccountType.SessionType(id: user.id, type: .P2P)
        let vc = SessionViewController<AccountType>(account: account, session: session)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].cells[indexPath.row].height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

