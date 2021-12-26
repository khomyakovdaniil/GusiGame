//
//  DragInfo.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 25.12.2021.
//

import Foundation
import UIKit

struct DragInfo {
    var collection: UICollectionView
    var indexPath: IndexPath
    init(collection: UICollectionView, indexPath: IndexPath){
    self.collection = collection
        self.indexPath = indexPath
    }
}
