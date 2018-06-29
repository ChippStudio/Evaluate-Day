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
    var shareHandler: ((IndexPath, Card, [Any]) -> Void)?
    var deleteHandler: ((IndexPath, Card) -> Void)?
    var editHandler: ((IndexPath, Card) -> Void)?
    var mergeHandler: ((IndexPath, Card) -> Void)?
    var unarchiveHandler: ((IndexPath, Card) -> Void)?
    var didSelectItem: ((Int, Card) -> Void)?
    
    // MARK: - Flags
    var isOpenEdit: Bool = false
    
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
        var base: Int = 1
        if self.isOpenEdit {
            base += 1
        }
        if self.card.archived {
            base += 1
        }
        return base
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let style = Themes.manager.evaluateStyle
        if index == 0 {
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
            
            let counterCard = self.card.data as! CounterCard
            var value: Double = 0.0
            var sumValue: Double?
            if let currentValue = counterCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).first {
                value = currentValue.value
            }
            if counterCard.isSum {
                sumValue = counterCard.startValue
                for v in counterCard.values {
                    sumValue! += v.value
                }
            }
            
            return {
                let node = CounterNode(title: title, subtitle: subtitle, image: image, value: value, sumValue: sumValue, style: style)
                node.visual(withStyle: style)
                OperationQueue.main.addOperation {
                    node.title.shareButton.view.tag = index
                }
                node.title.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                node.analytics.button.addTarget(self, action: #selector(self.analyticsNodeAction(sender:)), forControlEvents: .touchUpInside)
                
                if !lock {
                    node.counter.plus.addTarget(self, action: #selector(self.plusButtonAction(sender:)), forControlEvents: .touchUpInside)
                    node.counter.minus.addTarget(self, action: #selector(self.minusButtonAction(sender:)), forControlEvents: .touchUpInside)
                    node.counter.customValueButton.addTarget(self, action: #selector(self.customValueButtonAction(sender:)), forControlEvents: .touchUpInside)
                }
                return node
            }
        }
        
        if index == 1 {
            if self.isOpenEdit {
                var actions = [ActionsNodeAction.settings, ActionsNodeAction.delete]
                if Database.manager.data.objects(Card.self).filter("typeRaw=%@ AND isDeleted=%@", self.card.typeRaw, false).count > 1 {
                    actions.insert(.merge, at: 0)
                }
                var isBottomDivider = false
                if self.card.archived {
                    isBottomDivider = true
                }
                return {
                    let node = ActionsNode(actions: actions, isDividers: true, isBottomDivider: isBottomDivider, style: style)
                    if !isBottomDivider {
                        node.bottomOffset = 50.0
                    }
                    for action in node.actions {
                        action.addTarget(self, action: #selector(self.actionHandler(sender:)), forControlEvents: .touchUpInside)
                    }
                    return node
                }
            } else {
                return {
                    let node = UnarchiveNode(style: style)
                    node.unarchiveButton.addTarget(self, action: #selector(self.unarchiveButtonAction(sender:)), forControlEvents: .touchUpInside)
                    return node
                }
            }
        } else {
            return {
                let node = UnarchiveNode(style: style)
                node.unarchiveButton.addTarget(self, action: #selector(self.unarchiveButtonAction(sender:)), forControlEvents: .touchUpInside)
                return node
            }
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
        
        self.isOpenEdit = !self.isOpenEdit
        collectionContext?.performBatch(animated: true, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
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
        
        collectionContext?.performBatch(animated: false, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    @objc private func customValueButtonAction(sender: ASButtonNode) {
        let controller = TextTopViewController()
        controller.onlyNumbers = true
        controller.delegate = self
        self.viewController?.present(controller, animated: true, completion: nil)
    }
    @objc private func shareAction(sender: ASButtonNode) {
        let indexPath = IndexPath(row: sender.view.tag, section: self.section)
        let counterCard = self.card.data as! CounterCard
        var value: Double = 0.0
        var sumValue: Double?
        if let currentValue = counterCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).first {
            value = currentValue.value
        }
        if counterCard.isSum {
            sumValue = counterCard.startValue
            for v in counterCard.values {
                sumValue! += v.value
            }
        }
        let sv = ShareView(view: EvaluateCounterShareView(value: value, sumValue: sumValue, title: self.card.title, subtitle: self.card.subtitle, date: self.date))
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
        let linkObject = BranchUniversalObject(canonicalIdentifier: "counterShare")
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
    
    @objc private func actionHandler(sender: ASButtonNode) {
        let indexPath = IndexPath(row: 1, section: self.section)
        if let action = ActionsNodeAction(rawValue: sender.view.tag) {
            if action == .delete {
                self.deleteHandler?(indexPath, self.card)
            } else if action == .settings {
                self.editHandler?(indexPath, self.card)
            } else if action == .merge {
                self.mergeHandler?(indexPath, self.card)
            }
        }
    }
    
    @objc private func unarchiveButtonAction(sender: ASButtonNode) {
        var indexPath = IndexPath(row: 1, section: self.section)
        if self.isOpenEdit {
            indexPath = IndexPath(row: 2, section: self.section)
        }
        self.unarchiveHandler?(indexPath, self.card)
    }
    
    @objc private func analyticsNodeAction(sender: ASButtonNode) {
        self.didSelectItem?(self.section, self.card)
    }
}

class CounterNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var counter: CounterEvaluateNode!
    var analytics: AnalyticsNode!
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, value: Double, sumValue: Double?, style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
        self.counter = CounterEvaluateNode(value: value, sumValue: sumValue, style: style)
        self.analytics = AnalyticsNode(style: style)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title, self.counter, self.analytics]
        
        return stack
    }
}
