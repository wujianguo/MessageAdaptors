//
//  SettingsTitleTableViewCell.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/19.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class SettingsTitleTableViewCellTypeInfo: SettingsTypeProtocol {
    
    func register(tableView: UITableView) {
        tableView.register(SettingsTitleTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier())
    }
    
    func dequeueReusableCell(for indexPath: IndexPath, at tableView: UITableView) -> SettingsTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: SettingsTitleTableViewCell.identifier(), for: indexPath) as! SettingsTitleTableViewCell
    }

    func didSelect(type: SettingsType) {
        
    }

}

class SettingsTitleTableViewCell: SettingsTableViewCell {

    override class func identifier() -> String {
        return "SettingsTitleTableViewCellIdentifier"
    }

    override var type: SettingsType! {
        didSet {
//            switch type {
//            case .title(let title):
//                textLabel?.text = title
//            default:
//                break
//            }
        }
    }

}
