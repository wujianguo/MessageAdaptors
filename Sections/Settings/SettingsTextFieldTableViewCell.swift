//
//  SettingsTextFieldTableViewCell.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/19.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class SettingsTextFieldTableViewCellTypeInfo: SettingsTypeProtocol {
    
    func register(tableView: UITableView) {
        tableView.register(SettingsTextFieldTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier())
    }
    
    func dequeueReusableCell(for indexPath: IndexPath, at tableView: UITableView) -> SettingsTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: SettingsTextFieldTableViewCell.identifier(), for: indexPath) as! SettingsTextFieldTableViewCell
    }

    func didSelect(type: SettingsType) {
        
    }

}

class SettingsTextFieldTableViewCell: SettingsTableViewCell {

    override class func identifier() -> String {
        return "SettingsTextFieldTableViewCellIdentifier"
    }

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()

    override func setup() {
        contentView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView.snp.leadingMargin)
            make.trailing.equalTo(self.contentView.snp.trailingMargin)
            make.top.bottom.equalTo(self.contentView)
        }
    }
}
