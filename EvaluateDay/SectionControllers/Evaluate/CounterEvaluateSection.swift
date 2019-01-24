//
//  CounterEvaluateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 20/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit
import Branch

class CounterEvaluateSection: ListSectionController, ASSectionController, EvaluableSection, TextTopViewControllerDelegate {
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
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
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
        
        let counterCard = self.card.data as! CounterCard
        var value: Double = 0.0
        var previousValue: Double = 0.0
        var sumValue: Double?
        if let currentValue = counterCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).first {
            value = currentValue.value
        }
        
        let step = counterCard.step
        
        var components = DateComponents()
        components.day = -1
        let previousDate = Calendar.current.date(byAdding: components, to: self.date)!
        if let currentValue = counterCard.values.filter("(created >= %@) AND (created <= %@)", previousDate.start, previousDate.end).first {
            previousValue = currentValue.value
        }
        if counterCard.isSum {
            sumValue = counterCard.startValue
            for v in counterCard.values {
                sumValue! += v.value
            }
        }
        var counter = [Float]()
        for i in 1...7 {
            var components = DateComponents()
            components.day = i * -1
            let date = Calendar.current.date(byAdding: components, to: self.date)!
            if let c = counterCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first {
                counter.insert(Float(c.value), at: 0)
            } else {
                counter.insert(0, at: 0)
            }
        }
        let board = self.card.dashboardValue
        
        return {
            let node = CounterNode(title: title, subtitle: subtitle, image: image, value: value, sumValue: sumValue, previousValue: previousValue, date: self.date, step: step, dashboard: board, values: counter)
            
            node.analytics.button.addTarget(self, action: #selector(self.analyticsButton(sender:)), forControlEvents: .touchUpInside)
            node.share.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
            
            if !lock {
                node.counter.plus.addTarget(self, action: #selector(self.plusButtonAction(sender:)), forControlEvents: .touchUpInside)
                node.counter.minus.addTarget(self, action: #selector(self.minusButtonAction(sender:)), forControlEvents: .touchUpInside)
                node.counter.customValueButton.addTarget(self, action: #selector(self.customValueButtonAction(sender:)), forControlEvents: .touchUpInside)
            }
            
            if archived {
                node.backgroundColor = UIColor.background
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
        if let value = Double(text) {
            let counterCard = self.card.data as! CounterCard
            if let currentValue = counterCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).first {
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
        let counterCard = self.card.data as! CounterCard
        if let currentValue = counterCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).first {
            try! Database.manager.data.write {
                currentValue.value += counterCard.step
                currentValue.edited = Date()
            }
        } else {
            let newValue = NumberValue()
            newValue.owner = self.card.id
            newValue.created = self.date
            newValue.value += counterCard.step
            
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
        let counterCard = self.card.data as! CounterCard
        if let currentValue = counterCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).first {
            try! Database.manager.data.write {
                currentValue.value -= counterCard.step
                currentValue.edited = Date()
            }
        } else {
            let newValue = NumberValue()
            newValue.owner = self.card.id
            newValue.created = self.date
            newValue.value -= counterCard.step
            
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
        let controller = TextTopViewController()
        controller.onlyNumbers = true
        controller.delegate = self
        //Feedback
        Feedback.player.play(sound: nil, hapticFeedback: true, impact: false, feedbackType: nil)
        self.viewController?.present(controller, animated: true, completion: nil)
    }
    @objc private func shareAction(sender: ASButtonNode) {
        let node: ASCellNode!
        
        if let controller = self.viewController as? EvaluateViewController {
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
            shareContrroller.canonicalIdentifier = "counterShare"
            shareContrroller.channel = "Evaluate"
            shareContrroller.shareHandler = { () in
                sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
            }
            
            self.viewController?.present(shareContrroller, animated: true, completion: nil)
        }
    }
}

class CounterNode: ASCellNode {
    // MARK: - UI
    var title: TitleNode!
    var counter: CounterEvaluateNode!
    var separator: SeparatorNode!
    var analytics: EvaluateLineAnalyticsNode!
    var share: ShareNode!
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, value: Double, sumValue: Double?, previousValue: Double, date: Date, step: Double, dashboard: (String, UIImage)?, values: [Float]) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image)
        self.counter = CounterEvaluateNode(value: value, sumValue: sumValue, previousValue: previousValue, date: date, step: step)
        
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
        self.accessibilityNode.accessibilityLabel = "\(title), \(subtitle), \(Sources.title(forType: .counter))"
        self.accessibilityNode.accessibilityValue = Localizations.Accessibility.current("\(value)")
        self.accessibilityNode.accessibilityTraits = UIAccessibilityTraitButton
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title, self.counter, self.analytics, self.share, self.separator]
        
        let cell = ASBackgroundLayoutSpec(child: stack, background: self.accessibilityNode)
        return cell
    }
}
