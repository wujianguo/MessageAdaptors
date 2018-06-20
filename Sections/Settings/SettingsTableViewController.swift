//
//  SettingsTableViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/19.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var settings: [SettingsType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settings = [
//            .title("hello", SettingsTitleTableViewCellTypeInfo())
        ]
        for type in settings {
            type.delegate.register(tableView: tableView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settings[indexPath.row].delegate.dequeueReusableCell(for: indexPath, at: tableView)
        cell.type = settings[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settings[indexPath.row].delegate.didSelect(type: settings[indexPath.row])
    }
    
}
