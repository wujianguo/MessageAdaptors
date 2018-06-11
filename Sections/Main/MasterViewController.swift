//
//  MasterViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/31.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class MasterViewController<AccountType: MessageAccount>: UITabBarController {
    
    var sessions: SessionsTableViewController<AccountType>!
    var contact:  ContactTableViewController<AccountType>!
    var more:     AccountTableViewController<AccountType>!
    
    let account: AccountType!

    init(account: AccountType) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        sessions = SessionsTableViewController<AccountType>(account: account)
        contact  = ContactTableViewController<AccountType>(account: account)
        more     = AccountTableViewController<AccountType>(account: account)
        
        viewControllers = [
            createTab(vc: sessions, item: .recents,  tag: 0),
            createTab(vc: contact,  item: .contacts, tag: 1),
            createTab(vc: more,     item: .more,     tag: 2),
        ]
        
        tabBar.tintColor = UIConstants.themeColor
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
    
    /*
    override func collapseSecondaryViewController(_ secondaryViewController: UIViewController, for splitViewController: UISplitViewController) {
        
    }
    
    override func separateSecondaryViewController(for splitViewController: UISplitViewController) -> UIViewController? {
        return nil
    }
    */
}
