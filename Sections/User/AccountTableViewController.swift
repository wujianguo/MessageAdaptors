//
//  AccountTableViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/28.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class AccountTableViewController<AccountType: MessageAccount>: UITableViewController {

    let account: AccountType
    
    init(account: AccountType) {
        self.account = account
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var settings: [SettingsType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Strings.Me
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.Signout, style: .plain, target: self, action: #selector(signoutClick(sender:)))
        
        settings = [
        ]
        
        for type in settings {
            type.delegate.register(tableView: tableView)
        }

    }

    @objc func signoutClick(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: Strings.Signout, message: Strings.confirmSignout, preferredStyle: .alert)
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settings[indexPath.row].delegate.dequeueReusableCell(for: indexPath, at: tableView)
        cell.type = settings[indexPath.row]
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settings[indexPath.row].delegate.didSelect(type: settings[indexPath.row])
    }

}
