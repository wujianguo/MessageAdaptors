//
//  MessageVoteObject.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/21.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit

class MessageVoteObject: MessageCustomObject {
    
}

class MessageVoteCollectionViewCell: UICollectionViewCell, MessageCustomLayout {

    func identifier() -> String {
        return "MessageVoteCellIdentifier"
    }
    
    func classType() -> AnyClass {
        return MessageVoteCollectionViewCell.self
    }

    var object: MessageCustomObject!
}
