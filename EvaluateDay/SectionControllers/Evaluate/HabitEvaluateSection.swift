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
        
        var counter = [Int]()
        for i in 1...7 {
            var components = DateComponents()
            components.day = i * -1
            let date = Calendar.current.date(byAdding: components, to: self.date)!
            let c = habitCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).count
            counter.insert(c, at: 0)
        }
        
        let board = self.card.dashboardValue?.1
        
        return {
            let node = HabitNode(title: title, subtitle: subtitle, image: image, negative: negative, marks: valuesCount, previousMarks: previousValueCount, date: self.date, comments: commetsStack, dashboard: board, values: counter)
            
            node.analytics.button.addTarget(self, action: #selector(self.analyticsButton(sender:)), forControlEvents: .touchUpInside)
            node.share.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
        
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
    @objc private func analyticsButton(sender: ASButtonNode) {
        self.didSelectItem?(self.section, self.card)
    }
    
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
        
        //Feedback
        Feedback.player.play(sound: nil, hapticFeedback: true, impact: false, feedbackType: nil)
        
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
        
        //Feedback
        Feedback.player.play(sound: nil, hapticFeedback: true, impact: false, feedbackType: nil)
    }
    @objc private func removeLastAction(sender: ASButtonNode) {
        let habitCard = self.card.data as! HabitCard
        if let value = habitCard.values.filter("(created >= %@) AND (created <= %@) AND (isDeleted=%@)", self.date.start, self.date.end, false).last {
            try! Database.manager.data.write {
                value.isDeleted = true
            }
        }
        
        //Feedback
        Feedback.player.play(sound: nil, hapticFeedback: false, impact: false, feedbackType: UINotificationFeedbackType.error)
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
        let node: ASCellNode!
        
        if let controller = self.viewController as? EvaluateViewController {
            node = controller.collectionNode.nodeForItem(at: IndexPath(row: 0, section: self.section))
        } else if let controller = self.viewController as? TimeViewController {
            node = controller.collectionNode.nodeForItem(at: IndexPath(row: 0, section: self.section))
        } else {
            return
        }
        
        if let nodeImage = node.view.snapshot {
            let sv = ShareView(image: nodeImage)
            UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(sv)
            sv.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
            }
            sv.layoutIfNeeded()
            let im = sv.snapshot
            sv.removeFromSuperview()
            
            let shareContrroller = UIStoryboard(name: Storyboards.share.rawValue, bundle: nil).instantiateInitialViewController() as! ShareViewController
            shareContrroller.image = im
            shareContrroller.canonicalIdentifier = "habitShare"
            shareContrroller.channel = "Evaluate"
            shareContrroller.shareHandler = { () in
                sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
            }
            
            self.viewController?.present(shareContrroller, animated: true, completion: nil)
        }
    }
}

class HabitNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var negative: HabitNegativeNode!
    var mark: HabitEvaluateNode!
    var comments = [HabitEvaluateCommentNode]()
    var separator: SeparatorNode!
    var analytics: EvaluateDashedLineAnalyticsNode!
    var share: ShareNode!
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, negative: Bool, marks: Int, previousMarks: Int, date: Date, comments: [String], dashboard: UIImage?, values: [Int]) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image)
        self.mark = HabitEvaluateNode(marks: marks, previousMarks: previousMarks, date: date)
        
        if negative {
            self.negative = HabitNegativeNode()
        }
        
        for (i, comment) in comments.enumerated() {
            let newComment = HabitEvaluateCommentNode(comment: comment, index: i + 1)
            OperationQueue.main.addOperation {
                newComment.editButton.view.tag = i
            }
            self.comments.append(newComment)
        }
        
        self.analytics = EvaluateDashedLineAnalyticsNode(values: values)
        
        self.separator = SeparatorNode()
        self.separator.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        
        self.share = ShareNode(dashboardImage: dashboard)
        
        // Accessibility
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = "\(title), \(subtitle), \(Sources.title(forType: .habit))"
        if negative {
            self.accessibilityNode.accessibilityLabel! += ", \(Localizations.Accessibility.Evaluate.Criterion.negative)"
        }
        self.accessibilityNode.accessibilityValue = Localizations.Accessibility.current("\(marks)")
        self.accessibilityNode.accessibilityTraits = UIAccessibilityTraitButton
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title]
        
        for (i, comment) in self.comments.enumerated() {
            if i == 0 {
                stack.children?.append(SpaceNode(space: 30.0))
            }
            stack.children!.append(comment)
        }
        
        if self.negative != nil {
            stack.children!.append(self.negative)
        }
        
        stack.children!.append(self.mark)
        stack.children!.append(self.analytics)
        stack.children!.append(self.share)
        stack.children!.append(self.self.separator)
        
        let cell = ASBackgroundLayoutSpec(child: stack, background: self.accessibilityNode)
        return cell
    }
}
