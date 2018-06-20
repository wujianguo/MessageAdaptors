//
//  SettingsTableViewCell.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/19.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

protocol SettingsTypeProtocol {
    
    func register(tableView: UITableView)
    
    func dequeueReusableCell(for indexPath: IndexPath, at tableView: UITableView) -> SettingsTableViewCell
    
    func didSelect(type: SettingsType)
//    var type: SettingsType! { get set }
}

enum SettingsKind {
    
    case title(String)
    
    case button(String, UIColor?)
    
    case textField(String?)
    
    case `switch`(Bool)
    
    case custom(Any?)    
}

struct SettingsType {
    
    var kind: SettingsKind
    
    var delegate: SettingsTypeProtocol
    
}

class SettingsTableViewCellTypeInfo: SettingsTypeProtocol {
    
    func register(tableView: UITableView) {
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier())
    }
    
    func dequeueReusableCell(for indexPath: IndexPath, at tableView: UITableView) -> SettingsTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier(), for: indexPath) as! SettingsTableViewCell
    }
    
    func didSelect(type: SettingsType) {
        
    }

}

class SettingsTableViewCell: UITableViewCell {

    class func identifier() -> String {
        return "SettingsTableViewCellIdentifier"
    }
        
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {

    }
    
    var type: SettingsType!
}
