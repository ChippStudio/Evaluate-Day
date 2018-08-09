//
//  HabitEvaluateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit
import RealmSwift
import Branch

class HabitEvaluateSection: ListSectionController, ASSectionController, EvaluableSection, TextTopViewControllerDelegate {
    // MARK: - Variables
    var card: Card!
    var date: Date! {
        didSet {
            // set comments
            let habitCard = self.card.data as! HabitCard
            self.comments = habitCard.values.filter("(created >= %@) AND (created <= %@) AND (isDeleted=%@)", self.date.start, self.date.end, false)
            collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
        }
    }
    
    private var comments: Results<MarkValue>!
    
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
        
        let habitCard = self.card.data as! HabitCard
        let valuesCount = habitCard.values.filter("(created >= %@) AND (created <= %@) AND (isDeleted=%@)", self.date.start, self.date.end, false).count
        let negative = habitCard.negative
        var commetsStack = [String]()
        for comment in self.comments {
            if !comment.text.isEmpty {
                commetsStack.append(comment.text)
            }
        }
        
        var components = DateComponents()
        components.day = -1
        
        let previousDate = Calendar.current.date(byAdding: components, to: self.date)!
        let previousValueCount = habitCard.values.filter("(created >= %@) AND (created <= %@) AND (isDeleted=%@)", previousDate.start, previousDate.end, false).count
        
        return {
            let node = HabitNode(title: title, subtitle: subtitle, image: image, negative: negative, marks: valuesCount, previousMarks: previousValueCount, date: self.date, comments: commetsStack, style: style)
            node.visual(withStyle: style)
            
            OperationQueue.main.addOperation {
                node.title.shareButton.view.tag = index
            }
            node.title.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
            
            if !lock {
                node.mark.markButton.addTarget(self, action: #selector(self.markAction(sender:)), forControlEvents: .touchUpInside)
                node.mark.markAndCommentButton.addTarget(self, action: #selector(self.markAndCommentAction(sender:)), forControlEvents: .touchUpInside)
                if node.mark.deleteButton != nil {
                    node.mark.deleteButton!.addTarget(self, action: #selector(self.removeLastAction(sender:)), forControlEvents: .touchUpInside)
                }
            }
            
            if !lock {
                for comment in node.comments {
                    comment.editButton.addTarget(self, action: #selector(self.editCommentAction(sender:)), forControlEvents: .touchUpInside)
                }
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
        if property == "" {
            let value = MarkValue()
            value.owner = self.card.id
            value.created = self.date
            value.text = text
            
            try! Database.manager.data.write {
                Database.manager.data.add(value)
            }
        } else {
            if let value = Database.manager.data.objects(MarkValue.self).filter("id=%@", property).first {
                try! Database.manager.data.write {
                    value.text = text
                }
            }
        }
        
        collectionContext?.performBatch(animated: true, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func markAction(sender: ASButtonNode) {
        let habitCard = self.card.data as! HabitCard
        if !habitCard.multiple && habitCard.values.filter("(created >= %@) AND (created <= %@) AND (isDeleted=%@)", self.date.start, self.date.end, false).count > 0 {
            return
        }
        let value = MarkValue()
        value.owner = self.card.id
        value.created = self.date
        
        try! Database.manager.data.write {
            Database.manager.data.add(value)
        }
        
        collectionContext?.performBatch(animated: true, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    @objc private func markAndCommentAction(sender: ASButtonNode) {
        let habitCard = self.card.data as! HabitCard
        if !habitCard.multiple && habitCard.values.filter("(created >= %@) AND (created <= %@) AND (isDeleted=%@)", self.date.start, self.date.end, false).count > 0 {
            return
        }
        let controller = TextTopViewController()
        controller.property = ""
        controller.delegate = self
        self.viewController?.present(controller, animated: true, completion: nil)
    }
    @objc private func removeLastAction(sender: ASButtonNode) {
        let habitCard = self.card.data as! HabitCard
        if let value = habitCard.values.filter("(created >= %@) AND (created <= %@) AND (isDeleted=%@)", self.date.start, self.date.end, false).last {
            try! Database.manager.data.write {
                value.isDeleted = true
            }
        }
        collectionContext?.performBatch(animated: true, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    @objc private func editCommentAction(sender: ASButtonNode) {
        let item = self.comments[sender.view.tag]
        let controller = TextTopViewController()
        controller.delegate = self
        controller.textView.text = item.text
        controller.property = item.id
        self.viewController?.present(controller, animated: true, completion: nil)
    }
    
    @objc private func shareAction(sender: ASButtonNode) {
        // FIXME: - Need share sction
        print("Share action not implemented")
    }
}

class HabitNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var negative: HabitNegativeNode!
    var mark: HabitEvaluateNode!
    var comments = [HabitEvaluateCommentNode]()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, negative: Bool, marks: Int, previousMarks: Int, date: Date, comments: [String], style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
        self.mark = HabitEvaluateNode(marks: marks, previousMarks: previousMarks, date: date, style: style)
        
        if negative {
            self.negative = HabitNegativeNode(style: style)
        }
        
        for (i, comment) in comments.enumerated() {
            let newComment = HabitEvaluateCommentNode(comment: comment, style: style)
            OperationQueue.main.addOperation {
                newComment.editButton.view.tag = i
            }
            self.comments.append(newComment)
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title]
        
        if self.negative != nil {
            stack.children!.append(self.negative)
        }
        
        for comment in self.comments {
            stack.children!.append(comment)
        }
        
        stack.children!.append(self.mark)
        
        return stack
    }
}
