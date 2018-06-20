//
//  ContactTableViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/23.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class ContactTableViewController<AccountType: MessageAccount>: UITableViewController {

    let account: AccountType
    
    var contact: AccountType.ContactType {
        return account.contact
    }
    
    init(account: AccountType) {
        self.account = account
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.contact
        tableView.rowHeight = 60
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier())
        tableView.tableFooterView = UIView()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(requestFriend(sender:)))
        
        contact.loadFriends { (error) in
            guard error == nil else {
                return
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Action
    @objc func requestFriend(sender: UIBarButtonItem) {
//        let vc = RequestFriendViewController<AccountType>(account: account)
//        navigationController?.pushViewController(vc, animated: true)
        
        let alert = UIAlertController(title: Strings.inputAccount, message: Strings.confirmSignout, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = Strings.inputAccount
        }
        alert.addAction(UIAlertAction(title: Strings.cancel, style: .cancel, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default, handler: { (action) in
            guard let text = alert.textFields?.first?.text else {
                return
            }
            self.account.contact.fetchUserInfo(id: text, complete: { (user, error) in
                guard let user = user else {
                    return
                }
                let vc = UserTableViewController<AccountType>(account: self.account, user: user)
                self.navigationController?.pushViewController(vc, animated: true)
            })

        }))
        present(alert, animated: true, completion: nil)

    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contact.friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier(), for: indexPath) as! ContactTableViewCell
        cell.user = contact.friends[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UserTableViewController<AccountType>(account: account, user: contact.friends[indexPath.row])
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
