//
//  FutureSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 15/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class FutureSection: ListSectionController, ASSectionController {
    
    // MARK: - Variables
    var shareAction: (() -> Void)?
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 1
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        return {
            let node = FutureNode(style: Themes.manager.evaluateStyle)
            node.shareButton.addTarget(self, action: #selector(self.shareButtonAction(sender:)), forControlEvents: .touchUpInside)
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
        
        let max = CGSize(width: width - collectionViewOffset, height: CGFloat.greatestFiniteMagnitude)
        let min = CGSize(width: width - collectionViewOffset, height: 0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .zero
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext!.dequeueReusableCell(of: _ASCollectionViewCell.self, for: self, at: index)
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
    // MARK: - Actions
    @objc private func shareButtonAction(sender: ASButtonNode) {
        self.shareAction?()
    }
}
