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

class TrackerEvaluateSection: ListSectionController, ASSectionController, EvaluableSection, TextViewControllerDelegate {
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
    
    func nodeForItem(at index: Int) -> ASCellNode {
        return ASCellNode()
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        var lock = false
        if self.date.start.days(to: Date().start) > pastDaysLimit && !Store.current.isPro {
            lock = true
        }
        
        if self.card.archived {
            lock = true
        }
        
        let title: String
        if self.card.archived {
            title = cardArchivedMark + self.card.title
        } else {
            title = self.card.title
        }
        let subtitle = self.card.subtitle
        let image = Sources.image(forType: self.card.type)
        
        let trackerCard = self.card.data as! TrackerCard
        let valuesCount = trackerCard.values.filter("(created >= %@) AND (created <= %@) AND (isDeleted=%@)", self.date.start, self.date.end, false).count
        
        var commetsStack = [String]()
        for comment in self.comments {
            if !comment.text.isEmpty {
                commetsStack.append(comment.text)
            }
        }
        
        var components = DateComponents()
        components.day = -1
        
        let previousDate = Calendar.current.date(byAdding: components, to: self.date)!
        let previousValueCount = trackerCard.values.filter("(created >= %@) AND (created <= %@) AND (isDeleted=%@)", previousDate.start, previousDate.end, false).count
        
        var counter = [Int]()
        for i in 1...7 {
            var components = DateComponents()
            components.day = i * -1
            let date = Calendar.current.date(byAdding: components, to: self.date)!
            let c = trackerCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).count
            counter.insert(c, at: 0)
        }
        let board = self.card.dashboardValue
        
        return {
            let node = TrackerNode(title: title, subtitle: subtitle, image: image, marks: valuesCount, previousMarks: previousValueCount, date: self.date, comments: commetsStack, dashboard: board, values: counter)
            
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
    
    // MARK: - TextViewControllerDelegate
    func textTopController(controller: TextViewController, willCloseWith text: String, forProperty property: String) {
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
        
        self.viewController?.userActivity = self.card.data.shortcut(for: .evaluate)
        self.viewController?.userActivity?.becomeCurrent()
        
        collectionContext?.performBatch(animated: true, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func analyticsButton(sender: ASButtonNode) {
        self.didSelectItem?(self.section, self.card)
    }
    
    @objc private func markAction(sender: ASButtonNode) {
        let value = MarkValue()
        value.owner = self.card.id
        value.created = self.date
        
        try! Database.manager.data.write {
            Database.manager.data.add(value)
        }
        
        self.viewController?.userActivity = self.card.data.shortcut(for: .evaluate)
        self.viewController?.userActivity?.becomeCurrent()
        
        //Feedback
        Feedback.player.play(sound: nil, hapticFeedback: true, impact: false, feedbackType: nil)
        
        collectionContext?.performBatch(animated: true, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    @objc private func markAndCommentAction(sender: ASButtonNode) {
        let controller = UIStoryboard(name: Storyboards.text.rawValue, bundle: nil).instantiateInitialViewController() as! TextViewController
        controller.property = ""
        controller.delegate = self
        
        //Feedback
        Feedback.player.play(sound: nil, hapticFeedback: true, impact: false, feedbackType: nil)
        
        self.viewController?.present(controller, animated: true, completion: nil)
    }
    @objc private func removeLastAction(sender: ASButtonNode) {
        let trackerCard = self.card.data as! TrackerCard
        if let value = trackerCard.values.filter("(created >= %@) AND (created <= %@) AND (isDeleted=%@)", self.date.start, self.date.end, false).last {
            try! Database.manager.data.write {
                value.isDeleted = true
            }
        }
        //Feedback
        Feedback.player.play(sound: nil, hapticFeedback: false, impact: false, feedbackType: UINotificationFeedbackGenerator.FeedbackType.error)
        
        collectionContext?.performBatch(animated: true, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    @objc private func editCommentAction(sender: ASButtonNode) {
        let item = self.comments[sender.view.tag]
        let controller = UIStoryboard(name: Storyboards.text.rawValue, bundle: nil).instantiateInitialViewController() as! TextViewController
        controller.delegate = self
        controller.text = item.text
        controller.property = item.id
        self.viewController?.present(controller, animated: true, completion: nil)
    }
    
    @objc private func shareAction(sender: ASButtonNode) {
        let node: TrackerNode!
        
        if let controller = self.viewController as? EvaluateViewController {
            if let tNode = controller.collectionNode.nodeForItem(at: IndexPath(row: 0, section: self.section)) as? TrackerNode {
                node = tNode
            } else {
                return
            }
            
        } else {
            return
        }
        
        node.share.shareCover.alpha = 0.0
        node.share.shareImage.alpha = 0.0
        
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
            shareContrroller.canonicalIdentifier = "trackerShare"
            shareContrroller.channel = "Evaluate"
            shareContrroller.shareHandler = { () in
                sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
            }
            
            self.viewController?.present(shareContrroller, animated: true, completion: nil)
        }
        
        node.share.shareCover.alpha = 1.0
        node.share.shareImage.alpha = 1.0
    }
    
    func performAction(for shortcut: SiriShortcutItem) {
        switch shortcut {
        case .trackerMark:
            self.markAction(sender: ASButtonNode())
        case .trackerMarkAndComment:
            self.markAndCommentAction(sender: ASButtonNode())
        default: ()
        }
    }
}

class TrackerNode: ASCellNode {
    // MARK: - UI
    var title: TitleNode!
    var mark: HabitEvaluateNode!
    var comments = [HabitEvaluateCommentNode]()
    var separator: SeparatorNode!
    var analytics: EvaluateDashedLineAnalyticsNode!
    var share: ShareNode!
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, marks: Int, previousMarks: Int, date: Date, comments: [String], dashboard: (String, UIImage)?, values: [Int]) {
        super.init()
        
        self.backgroundColor = UIColor.background
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image)
        self.mark = HabitEvaluateNode(marks: marks, previousMarks: previousMarks, date: date)
        
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
        
        self.share = ShareNode(dashboardImage: dashboard?.1, collectionTitle: dashboard?.0, cardTitle: title)
        
        // Accessibility
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = "\(title), \(subtitle), \(Sources.title(forType: .tracker))"
        self.accessibilityNode.accessibilityValue = Localizations.Accessibility.current("\(marks)")
        self.accessibilityNode.accessibilityTraits = UIAccessibilityTraits.button
        
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
        
        stack.children!.append(self.mark)
        stack.children!.append(self.analytics)
        stack.children!.append(self.share)
        stack.children!.append(self.self.separator)
        
        let cell = ASBackgroundLayoutSpec(child: stack, background: self.accessibilityNode)
        return cell
    }
}
