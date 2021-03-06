//
//  CollectionCardsSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CollectionCardsSection: ListSectionController, ASSectionController, ASCollectionDelegate {
    // MARK: - Variables
    var date: Date = Date()
    
    // MARK: - Init
    init(date: Date) {
        super.init()
        
        self.date = date
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 2
    }
    
    func nodeForItem(at index: Int) -> ASCellNode {
        return ASCellNode()
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        
        if index == 0 {
            return {
                let node = CardsListNode()
                node.cardsCollection.delegate = self
                return node
            }
        }
        
        return {
            let node = AllCardsNode()
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
        
        let max = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let min = CGSize(width: width, height: 0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .zero
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext!.dequeueReusableCell(of: _ASCollectionViewCell.self, for: self, at: index)
    }
    
    override func didSelectItem(at index: Int) {
        if index == 1 {
            if let nav = self.viewController?.navigationController {
                let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController() as! EvaluateViewController
                Feedback.player.select()
                nav.pushViewController(controller, animated: true)
            }
        }
    }
    
    // MARK: - ASCollectionDelegate
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let item = Sources().cards[indexPath.row]
        if let nav = self.viewController?.navigationController {
            let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController() as! EvaluateViewController
            controller.cardType = item.type
            Feedback.player.select()
            nav.pushViewController(controller, animated: true)
        }
    }
}
