//
//  MainViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/23.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

protocol SplitDetailProtocol {

}

extension SplitDetailProtocol {

    var isDetail: Bool {
        return false
    }
    
}

class PlaceholderViewController: UIViewController, SplitDetailProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    var isDetail: Bool {
        return true
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

    var master: MasterViewController<AccountType>!
    
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
        preferredDisplayMode = .allVisible
        master = MasterViewController<AccountType>(account: account)
        let detail = BaseNavigationController(rootViewController: PlaceholderViewController())
        viewControllers = [
            master,
            detail
        ]
        
        delegate = self

    }
    
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        if splitViewController.isCollapsed {
            if let tabBarController = splitViewController.viewControllers.first as? UITabBarController {
                if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                    var viewControllerToPush = vc
                    if let vc = viewControllerToPush as? UINavigationController {
                        viewControllerToPush = vc.topViewController!
                    }
                    navigationController.pushViewController(viewControllerToPush, animated: true)
                    return true
                }
            }
        }
        return false
    }
    
    /*
    func primaryViewController(forExpanding splitViewController: UISplitViewController) -> UIViewController? {
        return master
    }
    
    func primaryViewController(forCollapsing splitViewController: UISplitViewController) -> UIViewController? {
        return master
    }
    */
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        return false
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
