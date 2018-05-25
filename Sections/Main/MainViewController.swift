//
//  MainViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/23.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class MainViewController<AccountType: MessageAccount>: UITabBarController {

    var sessions: SessionsTableViewController<AccountType>!
    var contact:  ContactTableViewController<AccountType>!
    var more:     UserTableViewController<AccountType>!
    
    var account: AccountType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        account = AccountType()
        account.autoLogin { (error) in
            guard error == nil else {
                print("login:\(String(describing: error))")
                return
            }
        }

        sessions = SessionsTableViewController<AccountType>(account: account)
        contact  = ContactTableViewController<AccountType>(account: account)
        more     = UserTableViewController<AccountType>(account: account)
        
        viewControllers = [
            createTab(vc: sessions, item: .recents,  tag: 0),
            createTab(vc: contact,  item: .contacts, tag: 1),
            createTab(vc: more,     item: .more,     tag: 2),
        ]

    }
    
    func createTab(vc: UIViewController, name: String, image: UIImage?, tag: Int) -> UINavigationController {
        let navigationController = BaseNavigationController(rootViewController: vc)
        navigationController.tabBarItem.title = name
        navigationController.tabBarItem.image = image
        return navigationController;
    }
    
    func createTab(vc: UIViewController, item: UITabBarSystemItem, tag: Int) -> UINavigationController {
        let navigationController = BaseNavigationController(rootViewController: vc)
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: item, tag: tag)
        return navigationController;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
