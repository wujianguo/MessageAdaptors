//
//  MessageCustomLayout.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/21.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit
import MessageKit

/*
protocol MessageCustomObject2: Codable {
    
    static var type: Int { get }

}

protocol MessageCustomLayoutCell2: NSObjectProtocol {
    
    static var reuseIdentifier: String { get }

}

extension MessageCustomLayoutCell2 {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}


class MessageCellAdaptor2<ObjectType: MessageCustomObject2, CellType: MessageCustomLayoutCell2> {
    
    init(collectionView: UICollectionView) {
        collectionView.register(CellType.self, forCellWithReuseIdentifier: CellType.reuseIdentifier)
    }
    
}

struct MessageCustomLayoutManager2 {
    
    static func register(at collectionView: UICollectionView) {
        let vote = MessageCellAdaptor2<MessageVoteObject2, MessageVoteCollectionViewCell2>(collectionView: collectionView)
    }
}
*/
/*
typedef NS_ENUM(NSInteger,NTESCustomMessageType){
    CustomMessageTypeJanKenPon  = 1, //剪子石头布
    CustomMessageTypeSnapchat   = 2, //阅后即焚
    CustomMessageTypeChartlet   = 3, //贴图表情
    CustomMessageTypeWhiteboard = 4, //白板会话
    CustomMessageTypeRedPacket  = 5, //红包消息
    CustomMessageTypeRedPacketTip = 6, //红包提示消息
};
*/
protocol MessageCustomObject: Codable {
        
    static var type: Int { get }
    
    func kind() -> MessageKind
}


extension MessageCustomObject {
    
    func kind() -> MessageKind {
        return .custom(self)
    }
}


protocol MessageCustomLayoutCell {
    
    associatedtype ObjectType: MessageCustomObject
    
    static var reuseIdentifier: String { get }
    
    static var sizeCalculator: MessageSizeCalculator { get }
 
    func config(object: ObjectType, at indexPath: IndexPath)

}

extension MessageCustomLayoutCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

class MessageCellAdaptor<CellType: MessageCustomLayoutCell> {
    
    let objectType  = CellType.ObjectType.self
    let cellType    = CellType.self
    
}


struct MessageCustomLayoutManager {

    static let cellAdaptors = [
        MessageCellAdaptor<MessageJanKenPonCollectionViewCell>(),
//        MessageCellAdaptor<MessageChartletCollectionViewCell>(),
    ]

    static func register(at collectionView: UICollectionView) {
        for adapt in cellAdaptors {
            collectionView.register(adapt.cellType, forCellWithReuseIdentifier: adapt.cellType.reuseIdentifier)
        }
    }
    
    static func dequeueReusableCell(at collectionView: UICollectionView, for indexPath: IndexPath, with object: MessageCustomObject) -> UICollectionViewCell? {
        for adapt in cellAdaptors {
            if adapt.objectType == type(of: object) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adapt.cellType.reuseIdentifier, for: indexPath)
                return cell
            }
        }
        return nil
    }
    
    static func cellSizeCalculator(for object: MessageCustomObject) -> MessageSizeCalculator? {
        for adapt in cellAdaptors {
            if adapt.objectType == type(of: object) {
                return adapt.cellType.sizeCalculator
            }
        }
        return nil
    }
    
}

