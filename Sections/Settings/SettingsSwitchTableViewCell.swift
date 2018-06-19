//
//  SettingsSwitchTableViewCell.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/19.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class SettingsSwitchTableViewCellTypeInfo: SettingsTypeProtocol {
    
    func register(tableView: UITableView) {
        tableView.register(SettingsSwitchTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier())
    }
    
    func dequeueReusableCell(for indexPath: IndexPath, at tableView: UITableView) -> SettingsTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: SettingsSwitchTableViewCell.identifier(), for: indexPath) as! SettingsSwitchTableViewCell
    }

    func didSelect(type: SettingsType) {
        
    }

}
class SettingsSwitchTableViewCell: SettingsTableViewCell {

    override class func identifier() -> String {
        return "SettingsSwitchTableViewCellIdentifier"
    }

    lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        return switcher
    }()

    override func setup() {
        accessoryView = switcher
    }

}
