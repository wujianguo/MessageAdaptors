//
//  SessionDetailTableViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/28.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class SessionDetailTableViewController<AccountType: MessageAccount>: StaticTableViewController {

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
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].cells[indexPath.row].height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

//class TeamSessionDetailTableViewController: SessionDetailTableViewController<<#AccountType: MessageAccount#>> {
//
//}
//
//class UserSessionDetailTableViewController: SessionDetailTableViewController<<#AccountType: MessageAccount#>> {
//
//}
