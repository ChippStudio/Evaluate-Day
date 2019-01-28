//
//  EvaluateEmptyCardSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 06/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

enum CardsEmptyType {
    case collection
    case type
    case all
}

class EvaluateEmptyCardSection: ListSectionController, ASSectionController {
    
    // MARK: - Variables
    var type: CardsEmptyType!
    
    // MARK: - Init
    init(type: CardsEmptyType) {
        super.init()
        
        self.type = type
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 1
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        var title: String
        var subtitle: String
        var image: UIImage
        switch self.type! {
        case .collection:
            title = Localizations.Collection.Empty.title
            subtitle = Localizations.Collection.Empty.subtitle
            image = Images.Media.collections.image
        case .type:
            title = Localizations.List.Card.EmptyType.title
            subtitle = Localizations.List.Card.EmptyType.subtitle
            if let controller = self.viewController as? EvaluateViewController {
                image = Sources.image(forType: controller.cardType)
            } else {
                image = Images.Media.cards.image
            }
        case .all:
            title = Localizations.List.Card.Empty.title
            subtitle = Localizations.List.Card.Empty.description
            image = Images.Media.cards.image
        }
        return {
            let node = EvaluateEmptyCardNode(title: title, subtitle: subtitle, image: image)
            node.newCardButton.addTarget(self, action: #selector(self.addNewCard(sender:)), forControlEvents: .touchUpInside)
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
        
    }
    
    // MARK: - Actions
    @objc func addNewCard(sender: UIButton) {
        if let controller = self.viewController as? EvaluateViewController {
            controller.newCardButtonAction(sender: UIBarButtonItem())
        }
    }
}
