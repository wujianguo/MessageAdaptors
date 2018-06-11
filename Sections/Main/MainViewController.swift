//
//  MainViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/23.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit


class PlaceholderViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
}

class SplitViewController<AccountType: MessageAccount>: UISplitViewController, UISplitViewControllerDelegate {
    
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
        
        if account.status != .Connected {
            account.autoSignin { (error) in
                guard error == nil else {
                    print("login:\(String(describing: error))")
                    return
                }
            }
        }


        let master = MasterViewController<AccountType>(account: account)
        let detail = BaseNavigationController(rootViewController: PlaceholderViewController())
        viewControllers = [
            master,
            detail
        ]
        
        delegate = self

    }
    
    /*
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
        
    }
    
    func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        return displayMode
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, show vc: UIViewController, sender: Any?) -> Bool {
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        return true
    }
    
    func primaryViewController(forExpanding splitViewController: UISplitViewController) -> UIViewController? {
        return nil
    }
    
    override func separateSecondaryViewController(for splitViewController: UISplitViewController) -> UIViewController? {
        return nil
    }
    */
}
