//
//  MessageCustomLayout.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/21.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit
import MessageKit

protocol MessageCustomObject: Codable {
        
    static var type: Int { get }
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
        MessageCellAdaptor<MessageVoteCollectionViewCell>()
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

