//
//  UpdateEvaluateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class UpdateEvaluateSection: ListSectionController, ASSectionController, EvaluableSection {
    
    // MARK: - Variable
    var card: Card!
    var date: Date!
    
    // MARK: - Actions
    var didSelectItem: ((Int, Card) -> Void)?
    
    // MARK: - Init
    init(card: Card) {
        super.init()
        self.card = card
    }
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 1
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let style = Themes.manager.evaluateStyle
        
        let title = self.card.title
        let subtitle = self.card.subtitle
        let image = Sources.image(forType: self.card.type)
        
        return {
            let node = UpdateCardNode(title: title, subtitle: subtitle, image: image, style: style)
            node.visual(withStyle: style)
            node.title.shareButton.alpha = 0.0
            node.title.shareButton.isEnabled = false
            
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
}

class UpdateCardNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var update: UpdateNode!
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
        self.update = UpdateNode(style: style)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title, self.update]
        
        return stack
    }
}
