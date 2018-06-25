//
//  MessageCustomLayout.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/6/21.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit
import MessageKit

protocol MessageCustomObject {
        
    
}

protocol MessageCustomLayout {
    
    func identifier() -> String
    
    func classType() -> Swift.AnyClass

    var object: MessageCustomObject! { get set }
}

extension MessageCustomLayout {
    
    func register(at collectionView: UICollectionView) {
        collectionView.register(classType(), forCellWithReuseIdentifier: identifier())
    }
    
    func dequeueReusableCell(at collectionView: UICollectionView, for indexPath: IndexPath, object: MessageCustomObject) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier(), for: indexPath)
    }

}

//extension Swift.AnyClass {
//    
//    
//}

struct MessageCustomLayoutManager {
    
    static func register(at collectionView: UICollectionView) {
        let cellTypes = [Swift.AnyClass]()
        for type in cellTypes {
            collectionView.register(type, forCellWithReuseIdentifier: "")
        }
    }
    
    static func dequeueReusableCell(at collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
    }
    
}

