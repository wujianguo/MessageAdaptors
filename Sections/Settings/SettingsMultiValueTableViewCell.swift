//
//  SettingsMultiValueTableViewCell.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/19.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class SettingsMultiValueTableViewCellTypeInfo: SettingsTypeProtocol {
    
    func register(tableView: UITableView) {
        tableView.register(SettingsMultiValueTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier())
    }
    
    func dequeueReusableCell(for indexPath: IndexPath, at tableView: UITableView) -> SettingsTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: SettingsMultiValueTableViewCell.identifier(), for: indexPath) as! SettingsMultiValueTableViewCell
    }

    func didSelect(type: SettingsType) {
        
    }

}


class SettingsMultiValueTableViewCell: SettingsTableViewCell {

    override class func identifier() -> String {
        return "SettingsMultiValueTableViewCellIdentifier"
    }

    override func setup() {
        accessoryType = .disclosureIndicator
    }

}
