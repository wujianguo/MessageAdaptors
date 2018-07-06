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


protocol MessageCustomLayoutCell: NSObjectProtocol {
    
    associatedtype ObjectType: MessageCustomObject
    
    static var cellReuseIdentifier: String { get }
    
    static var sizeCalculator: MessageSizeCalculator { get }
 
    func config(object: ObjectType, at indexPath: IndexPath)

}

protocol MessageCellAdaptorProtocol {

    var type: Int { get }

    var sizeCalculator: MessageSizeCalculator { get }
    
    func register(at collectionView: UICollectionView)
    
    func decode(data: Dictionary<String, Any>) -> MessageCustomObject?
    
    func dequeueReusableCell(at collectionView: UICollectionView, for indexPath: IndexPath, with object: MessageCustomObject) -> UICollectionViewCell
}

class MessageCellAdaptor<CellType: MessageCustomLayoutCell>: MessageCellAdaptorProtocol {
    
    var type: Int {
        return CellType.ObjectType.type
    }

    var sizeCalculator: MessageSizeCalculator {
        return CellType.sizeCalculator
    }
    
    func register(at collectionView: UICollectionView) {
        collectionView.register(CellType.self, forCellWithReuseIdentifier: CellType.cellReuseIdentifier)
    }
    
    func decode(data: Dictionary<String, Any>) -> MessageCustomObject? {
        do {
            let ret = try DictionaryDecoder().decode(CellType.ObjectType.self, from: data)
//            let ret = try JSONDecoder().decode(CellType.ObjectType.self, from: data)
            return ret
        } catch {
            print(error)
            return nil
        }
//        return try? JSONDecoder().decode(CellType.ObjectType.self, from: data)
    }
    
    func dequeueReusableCell(at collectionView: UICollectionView, for indexPath: IndexPath, with object: MessageCustomObject) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.cellReuseIdentifier, for: indexPath)
        if let cell = cell as? CellType {
            cell.config(object: object as! CellType.ObjectType, at: indexPath)
        }
        return cell
    }
}


struct MessageCustomLayoutManager {

    static let cellAdaptors: [MessageCellAdaptorProtocol] = [
        MessageCellAdaptor<MessageJanKenPonCollectionViewCell>(),
        MessageCellAdaptor<MessageChartletCollectionViewCell>(),
    ]

    static func register(at collectionView: UICollectionView) {
        for adapt in cellAdaptors {
            adapt.register(at: collectionView)
        }
    }
    
    static func dequeueReusableCell(at collectionView: UICollectionView, for indexPath: IndexPath, with object: MessageCustomObject) -> UICollectionViewCell? {
        for adapt in cellAdaptors {
            if adapt.type == type(of: object).type {
                return adapt.dequeueReusableCell(at: collectionView, for: indexPath, with: object)
            }
        }
        return nil
    }
    
    static func cellSizeCalculator(for object: MessageCustomObject) -> MessageSizeCalculator? {
        for adapt in cellAdaptors {
            if adapt.type == type(of: object).type {
                return adapt.sizeCalculator
            }
        }
        return nil
    }
    
}

