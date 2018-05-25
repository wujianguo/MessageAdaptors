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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = AccountType.name
        tableView.register(SessionTableViewCell<AccountType.SessionType>.self, forCellReuseIdentifier: SessionTableViewCell<AccountType.SessionType>.identifier())
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusChanged(notification:)), name: AccountStatusChangedNotificationName, object: nil)
    }
        
    // MARK: - Notification
    @objc func statusChanged(notification: Notification) {
        if let status = notification.userInfo?["status"] as? AccountStatus {
            switch status {
            case .Connecting:
                title = Strings.Connecting
            case .Disconnected:
                title = Strings.Disconnected
            default:
                title = AccountType.name
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return account.sessions.count
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? SessionTableViewCell<AccountType.SessionType> {
            cell.session.add(consumer: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? SessionTableViewCell<AccountType.SessionType> {
            cell.session.remove(consumer: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SessionTableViewCell<AccountType.SessionType>.identifier(), for: indexPath) as! SessionTableViewCell<AccountType.SessionType>
        cell.session = account.sessions[indexPath.row]        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SessionViewController<AccountType>(account: account, session: account.sessions[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - MessageConsumer

extension SessionsTableViewController: MessageConsumer {
    
    func on(sessionId: String, recv messages: [MessageObject]) {
        for cell in tableView.visibleCells {
            if let cell = cell as? SessionTableViewCell<AccountType.SessionType> {
                if cell.session.id == sessionId {
                    cell.update()
                    break
                }
            }
        }
    }
    
    
}

