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
        tableView.register(SettingsButtonTableViewCell.self, forCellReuseIdentifier: SettingsButtonTableViewCell.identifier())
    }
    
    func dequeueReusableCell(for indexPath: IndexPath, at tableView: UITableView) -> SettingsTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: SettingsButtonTableViewCell.identifier(), for: indexPath) as! SettingsButtonTableViewCell
    }

    func didSelect(type: SettingsType) {
        selectionBlock?(type)
    }

    var selectionBlock: ((SettingsType) -> Void)? = nil
    
    init(selection: @escaping (SettingsType) -> Void) {
        self.selectionBlock = selection
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
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false;
        contentView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0))
    }

    override var type: SettingsType! {
        didSet {
            switch type.kind {
            case .button(let title, let color):
                nameLabel.text = title
                if color != nil {
                    nameLabel.textColor = color
                } else {
                    nameLabel.textColor = UIConstants.themeColor
                }
            default:
                break
            }
        }
    }

}
