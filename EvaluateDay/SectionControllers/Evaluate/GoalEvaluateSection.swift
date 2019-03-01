//
//  GoalEvaluateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit
import Branch

class GoalEvaluateSection: ListSectionController, ASSectionController, EvaluableSection, TextViewControllerDelegate {
    // MARK: - Variables
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
        
        let goalCard = self.card.data as! GoalCard
        var value: Double = 0.0
        var previousValue: Double = 0.0
        let goalValue = goalCard.goalValue
        let measurement = goalCard.measurement
        var sumValue: Double?
        if let currentValue = goalCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).first {
            value = currentValue.value
        }
        if goalCard.isSum {
            sumValue = goalCard.startValue
            for v in goalCard.values {
                sumValue! += v.value
            }
        }
        
        var components = DateComponents()
        components.day = -1
        
        let previousDate = Calendar.current.date(byAdding: components, to: self.date)!
        if let currentValue = goalCard.values.filter("(created >= %@) AND (created <= %@)", previousDate.start, previousDate.end).first {
            previousValue = currentValue.value
        }
        var counter = [Float]()
        for i in 1...7 {
            var components = DateComponents()
            components.day = i * -1
            let date = Calendar.current.date(byAdding: components, to: self.date)!
            if let c = goalCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first {
                counter.insert(Float(c.value), at: 0)
            } else {
                counter.insert(0, at: 0)
            }
        }
        let step = goalCard.step
        let board = self.card.dashboardValue
        
        return {
            let node = GoalNode(title: title, subtitle: subtitle, image: image, value: value, measurement: measurement, previousValue: previousValue, date: self.date, goalValue: goalValue, sumValue: sumValue, step: step, dashboard: board, values: counter)
            
            node.analytics.button.addTarget(self, action: #selector(self.analyticsButton(sender:)), forControlEvents: .touchUpInside)
            node.share.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
            
            if !lock {
                node.goal.plus.addTarget(self, action: #selector(self.plusButtonAction(sender:)), forControlEvents: .touchUpInside)
                node.goal.minus.addTarget(self, action: #selector(self.minusButtonAction(sender:)), forControlEvents: .touchUpInside)
                node.goal.customValueButton.addTarget(self, action: #selector(self.customValueButtonAction(sender:)), forControlEvents: .touchUpInside)
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
        if let value = Double(text) {
            let goalCard = self.card.data as! GoalCard
            if let currentValue = goalCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).first {
                try! Database.manager.data.write {
                    currentValue.value = value
                    currentValue.edited = Date()
                }
            } else {
                let newValue = NumberValue()
                newValue.owner = self.card.id
                newValue.created = self.date
                newValue.value = value
                
                try! Database.manager.data.write {
                    Database.manager.data.add(newValue)
                }
            }
            
            collectionContext?.performBatch(animated: false, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
        }
    }
    
    // MARK: - Actions
    @objc private func analyticsButton(sender: ASButtonNode) {
        self.didSelectItem?(self.section, self.card)
    }
    @objc private func plusButtonAction(sender: ASButtonNode) {
        let goalCard = self.card.data as! GoalCard
        if let currentValue = goalCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).first {
            try! Database.manager.data.write {
                currentValue.value += goalCard.step
                currentValue.edited = Date()
            }
        } else {
            let newValue = NumberValue()
            newValue.owner = self.card.id
            newValue.created = self.date
            newValue.value += goalCard.step
            
            try! Database.manager.data.write {
                Database.manager.data.add(newValue)
            }
        }
        
        //Feedback
        Feedback.player.play(sound: nil, hapticFeedback: true, impact: false, feedbackType: nil)
        
        collectionContext?.performBatch(animated: false, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    @objc private func minusButtonAction(sender: ASButtonNode) {
        let goalCard = self.card.data as! GoalCard
        if let currentValue = goalCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).first {
            try! Database.manager.data.write {
                currentValue.value -= goalCard.step
                currentValue.edited = Date()
            }
        } else {
            let newValue = NumberValue()
            newValue.owner = self.card.id
            newValue.created = self.date
            newValue.value -= goalCard.step
            
            try! Database.manager.data.write {
                Database.manager.data.add(newValue)
            }
        }
        
        //Feedback
        Feedback.player.play(sound: nil, hapticFeedback: false, impact: true, feedbackType: nil)
        
        collectionContext?.performBatch(animated: false, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    @objc private func customValueButtonAction(sender: ASButtonNode) {
        let controller = UIStoryboard(name: Storyboards.text.rawValue, bundle: nil).instantiateInitialViewController() as! TextViewController
        controller.onlyNumbers = true
        controller.delegate = self
        
        //Feedback
        Feedback.player.play(sound: nil, hapticFeedback: true, impact: false, feedbackType: nil)
        
        self.viewController?.present(controller, animated: true, completion: nil)
    }
    @objc private func shareAction(sender: ASButtonNode) {
        let node: GoalNode!
        
        if let controller = self.viewController as? EvaluateViewController {
            if let tNode = controller.collectionNode.nodeForItem(at: IndexPath(row: 0, section: self.section)) as? GoalNode {
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
            shareContrroller.canonicalIdentifier = "goalShare"
            shareContrroller.channel = "Evaluate"
            shareContrroller.shareHandler = { () in
                sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
            }
            
            self.viewController?.present(shareContrroller, animated: true, completion: nil)
        }
        
        node.share.shareCover.alpha = 1.0
        node.share.shareImage.alpha = 1.0
    }
}

class GoalNode: ASCellNode {
    // MARK: - UI
    var title: TitleNode!
    var goal: GoalEvaluateNode!
    var separator: SeparatorNode!
    var analytics: EvaluateLineAnalyticsNode!
    var share: ShareNode!
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, value: Double, measurement: String, previousValue: Double, date: Date, goalValue: Double, sumValue: Double?, step: Double, dashboard: (String, UIImage)?, values: [Float]) {
        super.init()
        
        self.backgroundColor = UIColor.background
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image)
        self.goal = GoalEvaluateNode(value: value, previousValue: previousValue, date: date, goalValue: goalValue, sumValue: sumValue, step: step, measurement: measurement)
        
        var max: Float = 0.0
        for v in values {
            if v > max {
                max = v
            }
        }
        self.analytics = EvaluateLineAnalyticsNode(values: values, maxValue: max)
        
        self.separator = SeparatorNode()
        self.separator.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        
        self.share = ShareNode(dashboardImage: dashboard?.1, collectionTitle: dashboard?.0, cardTitle: title)
        
        // Accessibility
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = "\(title), \(subtitle), \(Sources.title(forType: .goal))"
        self.accessibilityNode.accessibilityValue = Localizations.Accessibility.current("\(value)")
        self.accessibilityNode.accessibilityTraits = UIAccessibilityTraits.button
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title, self.goal, self.analytics, self.share, self.separator]
        
        let cell = ASBackgroundLayoutSpec(child: stack, background: self.accessibilityNode)
        return cell
    }
}
