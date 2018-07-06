//
//  MessageNotificationLayout.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/27.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation

import MessageKit

class NotificationMessageSizeCalculator: MessageSizeCalculator {
    
    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}

class MessageCustomNotificationObject: MessageCustomObject {
    
    static var type: Int = 100
    
    var content: String
    
    init(content: String) {
        self.content = content
    }
}

class MessageNotificationCollectionViewCell: UICollectionViewCell, MessageCustomLayoutCell {
    
    static var cellReuseIdentifier: String = "MessageNotificationCollectionViewCellIdentifier"
    
    static var sizeCalculator: MessageSizeCalculator = NotificationMessageSizeCalculator()
    
    typealias ObjectType = MessageCustomNotificationObject
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(object: ObjectType, at indexPath: IndexPath) {
        
    }
    
}
