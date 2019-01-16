//
//  CollectionListSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CollectionListSection: ListSectionController, ASSectionController {
    // MARK: - Variables
    var collection: Dashboard!
    var date: Date = Date()
    
    // MARK: - Init
    init(collection: Dashboard) {
        super.init()
        self.collection = collection
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 1
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        
        let title = self.collection.title
        let image = UIImage(named: self.collection.image)!
        
        return {
            let node = CollectionListNode(title: title, image: image)
            return node
        }
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        let width: CGFloat = self.collectionContext!.containerSize.width
        
        if  width >= maxCollectionWidth {
            let max = CGSize(width: width * collectionViewWidthDevider, height: CGFloat.greatestFiniteMagnitude)
            let min = CGSize(width: width * collectionViewWidthDevider, height: 0)
            return ASSizeRange(min: min, max: max)
        }
        
        let max = CGSize(width: width - 20.0, height: CGFloat.greatestFiniteMagnitude)
        let min = CGSize(width: width - 20.0, height: 0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .zero
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext!.dequeueReusableCell(of: _ASCollectionViewCell.self, for: self, at: index)
    }
    
    override func didSelectItem(at index: Int) {
        if let nav = self.viewController?.navigationController {
            if let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController() as? EvaluateViewController {
                controller.collection = self.collection.id
                nav.pushViewController(controller, animated: true)
            }
        }
    }
}
