//
//  MessageChartletLayout.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/27.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import Foundation
import MessageKit

class ChartletMessageSizeCalculator: MessageSizeCalculator {
    
    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}

class MessageChartletObject: NSObject, MessageCustomObject {
    
    static var type: Int = 3
    
}

class MessageChartletCollectionViewCell: UICollectionViewCell, MessageCustomLayoutCell {
    
    static var cellReuseIdentifier: String = "MessageChartletCollectionViewCellIdentifier"
    
    static var sizeCalculator: MessageSizeCalculator = ChartletMessageSizeCalculator()
    
    typealias ObjectType = MessageChartletObject
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(object: ObjectType, at indexPath: IndexPath) {
        
    }
    
}
