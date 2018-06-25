//
//  SettingsTableViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/19.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit


class SettingsGroup {
    
    var name: String? = nil
    
    var settings: [SettingsType] = []
    
    init(settings: [SettingsType], name: String? = nil) {
        self.name = name
        self.settings = settings
    }
}

class SettingsTableViewController: UITableViewController {

    var groups: [SettingsGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for group in groups {
            for type in group.settings {
                type.delegate.register(tableView: tableView)
            }
        }
        tableView.rowHeight = 40
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groups[section].name
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = groups[indexPath.section].settings[indexPath.row]
        let cell = type.delegate.dequeueReusableCell(for: indexPath, at: tableView)
        cell.type = type
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = groups[indexPath.section].settings[indexPath.row]
        type.delegate.didSelect(type: type)
    }
    
}
