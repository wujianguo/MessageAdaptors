//
//  SessionsTableViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/7.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class SessionsTableViewController<AccountType: MessageAccount>: UITableViewController {

    let account: AccountType

    init(account: AccountType) {
        self.account = account
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        var manager = account.sessionManager
        manager.remove(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = AccountType.name
        
        tableView.rowHeight = 70
        tableView.register(SessionTableViewCell<AccountType.SessionType>.self, forCellReuseIdentifier: SessionTableViewCell<AccountType.SessionType>.identifier())
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusChanged(notification:)), name: AccountStatusChangedNotificationName, object: nil)
        
        var manager = account.sessionManager
        manager.add(delegate: self)
    }
    
    // MARK: - Notification
    @objc func statusChanged(notification: Notification) {
        if let status = notification.userInfo?["status"] as? AccountStatus {
            switch status {
            case .Connecting:
                title = Strings.connecting
            case .Disconnected:
                title = Strings.disconnected
            default:
                title = AccountType.name
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return account.sessionManager.recentSessions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SessionTableViewCell<AccountType.SessionType>.identifier(), for: indexPath) as! SessionTableViewCell<AccountType.SessionType>
        cell.session = account.sessionManager.recentSessions[indexPath.row] as! AccountType.SessionType
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SessionViewController<AccountType>(account: account, session: account.sessionManager.recentSessions[indexPath.row] as! AccountType.SessionType)
        let nav = BaseNavigationController(rootViewController: vc)
        splitViewController?.showDetailViewController(nav, sender: self)
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            account.sessionManager.delete(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

}


// MARK: - MessageSessionManagerDelegate

extension SessionsTableViewController: MessageSessionManagerDelegate {

    func on(sessionId: String, lastMessage: MessageObject, from: Int, to: Int) {
        if from > 0 && from != to {
            tableView.moveRow(at: IndexPath(row: from, section: 0), to: IndexPath(row: to, section: 0))
        }
        if let cell = tableView.cellForRow(at: IndexPath(row: to, section: 0)) as? SessionTableViewCell<AccountType.SessionType> {
            if cell.session.id == sessionId {
                cell.update()
            }
        }
    }
    
    func onNewSession(count: Int) {
        var indexPaths = [IndexPath]()
        for i in 0..<count {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        if indexPaths.count > 0 {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func reload() {
        tableView.reloadData()
    }
    
}

