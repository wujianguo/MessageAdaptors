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
        tableView.register(SettingsTextFieldTableViewCell.self, forCellReuseIdentifier: SettingsTextFieldTableViewCell.identifier())
    }
    
    func dequeueReusableCell(for indexPath: IndexPath, at tableView: UITableView) -> SettingsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTextFieldTableViewCell.identifier(), for: indexPath) as! SettingsTextFieldTableViewCell
        textField = cell.textField
        configurationBlock?(textField!)
        return cell
    }

    func didSelect(type: SettingsType) {
        
    }
    
    var textValue: String? {
        return textField?.text
    }
    
    var textField: UITextField?

    var configurationBlock: ((UITextField) -> Void)? = nil
    
    init(configuration: @escaping (UITextField) -> Void) {
        self.configurationBlock = configuration
    }
    
    init() {
        
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
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leadingMargin, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    override var type: SettingsType! {
        didSet {
            switch type.kind {
            case .textField(let placeholder):
                textField.placeholder = placeholder
            default:
                break
            }
        }
    }
}
