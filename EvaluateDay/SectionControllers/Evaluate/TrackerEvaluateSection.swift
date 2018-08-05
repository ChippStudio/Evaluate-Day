//
//  TrackerEvaluateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/04/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit
import RealmSwift
import Branch

class TrackerEvaluateSection: ListSectionController, ASSectionController, EvaluableSection, TextTopViewControllerDelegate {
    // MARK: - Variables
    var card: Card!
    var date: Date! {
        didSet {
            // set comments
            let trackerCard = self.card.data as! TrackerCard
            self.comments = trackerCard.values.filter("(created >= %@) AND (created <= %@) AND (isDeleted=%@)", self.date.start, self.date.end, false)
            collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
        }
    }
    
    private var comments: Results<MarkValue>!
    
    // MARK: - Actions
    var shareHandler: ((IndexPath, Card, [Any]) -> Void)?
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
        
        let trackerCard = self.card.data as! TrackerCard
        let valuesCount = trackerCard.values.filter("(created >= %@) AND (created <= %@) AND (isDeleted=%@)", self.date.start, self.date.end, false).count
        
        var commetsStack = [String]()
        for comment in self.comments {
            if !comment.text.isEmpty {
                commetsStack.append(comment.text)
            }
        }
        
        return {
            let node = TrackerNode(title: title, subtitle: subtitle, image: image, marks: valuesCount, comments: commetsStack, style: style)
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
                node.backgroundColor = style.background
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
        let controller = TextTopViewController()
        controller.property = ""
        controller.delegate = self
        self.viewController?.present(controller, animated: true, completion: nil)
    }
    @objc private func removeLastAction(sender: ASButtonNode) {
        let trackerCard = self.card.data as! TrackerCard
        if let value = trackerCard.values.filter("(created >= %@) AND (created <= %@) AND (isDeleted=%@)", self.date.start, self.date.end, false).last {
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
        let indexPath = IndexPath(row: sender.view.tag, section: self.section)
        let trackerCard = self.card.data as! TrackerCard
        var comments = [String]()
        for c in trackerCard.values {
            if c .text != "" {
                comments.append(c.text)
            }
        }
        
        let sv = ShareView(view: EvaluateHabitShareView(marks: trackerCard.values.count, comments: comments, title: self.card.title, subtitle: self.card.subtitle, date: self.date))
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(sv)
        sv.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        sv.layoutIfNeeded()
        var items = [Any]()
        if let im = sv.snapshot {
            items.append(im)
        }
        
        sv.removeFromSuperview()
        
        // Make universal Branch Link
        let linkObject = BranchUniversalObject(canonicalIdentifier: "trackerShare")
        linkObject.title = Localizations.share.link.title
        linkObject.contentDescription = Localizations.share.description
        
        let linkProperties = BranchLinkProperties()
        linkProperties.feature = "Content share"
        linkProperties.channel = "Evaluate"
        
        linkObject.getShortUrl(with: linkProperties) { (link, error) in
            if error != nil && link == nil {
                print(error!.localizedDescription)
            } else {
                items.append(link!)
            }
            
            self.shareHandler?(indexPath, self.card, items)
        }
    }
}

class TrackerNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var mark: HabitEvaluateNode!
    var comments = [HabitEvaluateCommentNode]()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, marks: Int, comments: [String], style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
        self.mark = HabitEvaluateNode(marks: marks, style: style)
        
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
        
        for comment in self.comments {
            stack.children!.append(comment)
        }
        
        stack.children!.append(self.mark)
        
        return stack
    }
}
