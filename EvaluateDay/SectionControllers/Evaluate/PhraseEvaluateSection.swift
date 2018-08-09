//
//  PhraseEvaluateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit
import Branch
import RealmSwift

class PhraseEvaluateSection: ListSectionController, ASSectionController, EvaluableSection, TextTopViewControllerDelegate {
    // MARK: - Variable
    var card: Card!
    var date: Date!
    
    // MARK: - Actions
    var didSelectItem: ((Int, Card) -> Void)?
    
    // MARK: - Init
    init(card: Card) {
        super.init()
        if let realmCard = Database.manager.data.objects(Card.self).filter("id=%@", card.id).first {
            self.card = realmCard
        } else {
            self.card = card
        }
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 1
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let style = Themes.manager.evaluateStyle
        var lock = false
        if self.date.start.days(to: Date().start) > pastDaysLimit && !Store.current.isPro {
            lock = true
        }
        
        if self.card.archived {
            lock = true
        }
        
        let title = self.card.title
        let subtitle = self.card.subtitle
        let image = Sources.image(forType: self.card.type)
        let archived = self.card.archived
        
        let phraseCard = self.card.data as! PhraseCard
        var text = ""
        if let value = phraseCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).first {
            text = value.text
        }
        
        return {
            let node = PhraseNode(title: title, subtitle: subtitle, image: image, text: text, date: self.date, style: style)
            
            node.visual(withStyle: style)
            
            OperationQueue.main.addOperation {
                node.title.shareButton.view.tag = index
            }
            node.title.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
            
            if !lock {
                node.phrase.editButton.addTarget(self, action: #selector(self.editTextAction(sender:)), forControlEvents: .touchUpInside)
            }
            
            if archived {
                node.backgroundColor = style.cardArchiveColor
            }
            
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
        if index != 0 {
            return
        }
        
        self.didSelectItem?(self.section, self.card)
    }
    
    // MARK: - TextTopViewControllerDelegate
    func textTopController(controller: TextTopViewController, willCloseWith text: String, forProperty property: String) {
        let phraseCard = self.card.data as! PhraseCard
        if phraseCard.realm != nil {
            if let value = phraseCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).sorted(byKeyPath: "edited", ascending: false).first {
                try! Database.manager.data.write {
                    value.text = text
                    value.edited = Date()
                }
            } else {
                let newValue = TextValue()
                newValue.text = text
                newValue.owner = self.card.id
                newValue.created = self.date
                try! Database.manager.data.write {
                    Database.manager.data.add(newValue)
                }
            }
            
            collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
        }
    }
    
    // MARK: - Actions
    @objc private func editTextAction(sender: ASButtonNode) {
        let controller = TextTopViewController()
        controller.delegate = self
        if let value = (self.card.data as! PhraseCard).values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).first {
            controller.textView.text = value.text
        }
        self.viewController?.present(controller, animated: true, completion: nil)
    }
    
    @objc private func shareAction(sender: ASButtonNode) {
        // FIXME: - Need share sction
        print("Share action not implemented")
    }
}

class PhraseNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var phrase: PhraseEvaluateNode!
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, text: String, date: Date, style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
        self.phrase = PhraseEvaluateNode(text: text, date: date, style: style)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title, self.phrase]
        
        return stack
    }
}
