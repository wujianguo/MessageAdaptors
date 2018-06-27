//
//  MessageVoteObject.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/21.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit
import MessageKit

class VoteMessageSizeCalculator: MessageSizeCalculator {
    
    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}

class MessageVoteObject: NSObject, MessageCustomObject {
    
    static var type: Int = 1
    
}

class MessageVoteCollectionViewCell: UICollectionViewCell, MessageCustomLayoutCell {
    
    static var sizeCalculator: MessageSizeCalculator = VoteMessageSizeCalculator()
    
    typealias ObjectType = MessageVoteObject
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(object: ObjectType, at indexPath: IndexPath) {
        
    }

}
