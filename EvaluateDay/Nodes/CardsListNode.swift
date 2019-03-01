//
//  CardsListNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CardsListNode: ASCellNode, ASCollectionDataSource, ASCollectionDelegate {
    
    // MARK: - UI
    var cardsCollection: ASCollectionNode!
    
    // MARK: - Variable
    let sources = Sources()
    
    // MARK: - Init
    override init() {
        super.init()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10.0
        
        self.cardsCollection = ASCollectionNode(collectionViewLayout: layout)
        self.cardsCollection.dataSource = self
        self.cardsCollection.delegate = self
        self.cardsCollection.backgroundColor = UIColor.clear
        self.cardsCollection.contentInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        OperationQueue.main.addOperation {
            self.cardsCollection.view.showsHorizontalScrollIndicator = false
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.cardsCollection.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 70.0)
        
        let cell = ASStackLayoutSpec.vertical()
        
        cell.children = [self.cardsCollection]
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 25.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - ASCollectionDataSource
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.sources.cards.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        let item = self.sources.cards[indexPath.row]
        
        return {
            let node = CardsListDotNode(image: item.image)
            node.isAccessibilityElement = true
            node.accessibilityLabel = item.title
            node.accessibilityTraits = UIAccessibilityTraits.button
            return node
        }
    }
}
