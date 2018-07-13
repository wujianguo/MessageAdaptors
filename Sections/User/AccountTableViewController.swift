//
//  AccountTableViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/28.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class AccountTableViewController<AccountType: MessageAccount>: StaticTableViewController {
    
    let account: AccountType
    
    init(account: AccountType) {
        self.account = account
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var headerCell: UserHeadTableViewCell!
    var signoutCell: CenterTextButtonTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.me

        headerCell = UserHeadTableViewCell(style: .default, reuseIdentifier: nil)
        headerCell.onConfig = {
            self.headerCell.user = self.account
        }
        let headerSection = StaticTableSection()
        headerSection.cells = [headerCell]
        
        signoutCell = CenterTextButtonTableViewCell(style: .default, reuseIdentifier: nil)
        signoutCell.onConfig = {
            self.signoutCell.nameLabel.text = Strings.signout
            self.signoutCell.nameLabel.textColor = UIConstants.destructiveColor
        }
        signoutCell.onSelect = {
            self.signout()
        }
        let buttonSection = StaticTableSection()
        buttonSection.cells = [signoutCell]
        
        sections = [headerSection, buttonSection]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].cells[indexPath.row].height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    func signout() {
        let alert = UIAlertController(title: Strings.signout, message: Strings.confirmSignout, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.cancel, style: .cancel, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: Strings.ok, style: .destructive, handler: { (action) in
            self.account.signout(complete: nil)
            
            let naccount = AccountType()
            let vc = SigninViewController<AccountType>(account: naccount)
            let nav = BaseNavigationController(rootViewController: vc)
            let app = UIApplication.shared.delegate as! AppDelegate
            app.window?.rootViewController = nav
        }))
        present(alert, animated: true, completion: nil)
    }

}

