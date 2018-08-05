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
            
            if !lock {
                node.counter.plus.addTarget(self, action: #selector(self.plusButtonAction(sender:)), forControlEvents: .touchUpInside)
                node.counter.minus.addTarget(self, action: #selector(self.minusButtonAction(sender:)), forControlEvents: .touchUpInside)
                node.counter.customValueButton.addTarget(self, action: #selector(self.customValueButtonAction(sender:)), forControlEvents: .touchUpInside)
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
}

class CounterNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var counter: CounterEvaluateNode!
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, value: Double, sumValue: Double?, style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
        self.counter = CounterEvaluateNode(value: value, sumValue: sumValue, style: style)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title, self.counter]
        
        return stack
    }
}
