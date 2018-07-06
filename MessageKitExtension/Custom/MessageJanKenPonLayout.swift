//
//  MessageJanKenPonLayout.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/27.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit

class JanKenPonMessageSizeCalculator: MessageSizeCalculator {
    
    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}

class MessageJanKenPonObject: NSObject, MessageCustomObject {
    
    static var type: Int = 1
    
    func kind() -> MessageKind {
        return .custom(self)
//        return .text("JanKenPon")
    }
    
    var value: Int = 0
}

class MessageJanKenPonCollectionViewCell: UICollectionViewCell, MessageCustomLayoutCell {
    
    static var cellReuseIdentifier: String = "MessageJanKenPonCollectionViewCellIdentifier"
    
    static var sizeCalculator: MessageSizeCalculator = JanKenPonMessageSizeCalculator()
    
    typealias ObjectType = MessageJanKenPonObject
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(object: MessageJanKenPonObject, at indexPath: IndexPath) {
        if object.value == 1 {
            contentView.backgroundColor = UIColor.gray
        } else if object.value == 2 {
            contentView.backgroundColor = UIColor.brown
        } else if object.value == 3 {
            contentView.backgroundColor = UIColor.yellow
        }
    }
    
}
