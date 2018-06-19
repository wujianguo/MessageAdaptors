//
//  SettingsButtonTableViewCell.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/19.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class SettingsButtonTableViewCellTypeInfo: SettingsTypeProtocol {
    
    func register(tableView: UITableView) {
        tableView.register(SettingsButtonTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier())
    }
    
    func dequeueReusableCell(for indexPath: IndexPath, at tableView: UITableView) -> SettingsTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: SettingsButtonTableViewCell.identifier(), for: indexPath) as! SettingsButtonTableViewCell
    }

    func didSelect(type: SettingsType) {
        
    }

}

class SettingsButtonTableViewCell: SettingsTableViewCell {
    
    override class func identifier() -> String {
        return "SettingsButtonTableViewCellIdentifier"
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    override func setup() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.contentView)
        }
    }

    override var type: SettingsType! {
        didSet {
//            switch type {
//            case .button(let title, let color):
//                self.nameLabel.text = title
//                self.nameLabel.textColor = color
//            default:
//                break
//            }
        }
    }

}
