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
        return .text("JanKenPon")
    }
}

class MessageJanKenPonCollectionViewCell: UICollectionViewCell, MessageCustomLayoutCell {
    
    static var sizeCalculator: MessageSizeCalculator = JanKenPonMessageSizeCalculator()
    
    typealias ObjectType = MessageJanKenPonObject
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(object: ObjectType, at indexPath: IndexPath) {
        
    }
    
}
