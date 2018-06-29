//
//  CalendarNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CalendarNode: ASCellNode {
    // MARK: - UI
    var collectionNode: ASCollectionNode!
    
    // MARK: - Init
    override init() {
        super.init()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80.0, height: 80.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.collectionNode.backgroundColor = UIColor.clear
        self.collectionNode.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        OperationQueue.main.addOperation {
            self.collectionNode.view.showsHorizontalScrollIndicator = false
            self.collectionNode.view.showsVerticalScrollIndicator = false
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func didLoad() {
        OperationQueue.main.addOperation {
            let indexPath = IndexPath(row: self.collectionNode.numberOfItems(inSection: 0) - 2, section: 0)
            self.collectionNode.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.collectionNode.style.preferredSize.height = 80.0
        let cellInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: self.collectionNode)
        return cellInset
    }
}
