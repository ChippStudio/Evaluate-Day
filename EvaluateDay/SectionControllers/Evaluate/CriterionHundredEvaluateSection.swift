//
//  CriterionHundredEvaluateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 08/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit
import Branch

class CriterionHundredEvaluateSection: ListSectionController, ASSectionController, EvaluableSection {
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
//        let archived = self.card.archived
        
        let criterionCard = self.card.data as! CriterionHundredCard
        var value: Float = 0.0
        var previousValue: Float = 0.0
        let isPositive = criterionCard.positive
        if let saveValue = criterionCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).sorted(byKeyPath: "edited", ascending: false).first {
            value = Float(saveValue.value)
        }
        
        var components = DateComponents()
        components.day = -1
        let previousDate = Calendar.current.date(byAdding: components, to: self.date)!
        if let saveValue = criterionCard.values.filter("(created >= %@) AND (created <= %@)", previousDate.start, previousDate.end).sorted(byKeyPath: "edited", ascending: false).first {
            previousValue = Float(saveValue.value)
        }
        
        var values = [Float]()
        for i in 1...7 {
            components.day = i * -1
            let date = Calendar.current.date(byAdding: components, to: self.date)!
            if let saveValue = criterionCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).sorted(byKeyPath: "edited", ascending: false).first {
                values.insert(Float(saveValue.value), at: 0)
            } else {
                values.insert(0.0, at: 0)
            }
        }
        
        let board = self.card.dashboardValue
        
        return {
            let node = HundredNode(title: title, subtitle: subtitle, current: value, previous: previousValue, date: self.date, isPositive: isPositive, lock: lock, values: values, dashboard: board)
            node.analytics.button.addTarget(self, action: #selector(self.analyticsButton(sender:)), forControlEvents: .touchUpInside)
            node.share.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
            node.slider.didChangeValue = { newCurrentValue in
                if criterionCard.realm != nil {
                    if let value = criterionCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).sorted(byKeyPath: "edited", ascending: false).first {
                        try! Database.manager.data.write {
                            value.value = Double(newCurrentValue)
                            value.edited = Date()
                        }
                    } else {
                        let newValue = NumberValue()
                        newValue.value = Double(newCurrentValue)
                        newValue.created = self.date
                        newValue.owner = self.card.id
                        try! Database.manager.data.write {
                            Database.manager.data.add(newValue)
                        }
                    }
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
    
    // MARK: - Actions
    @objc private func analyticsButton(sender: ASButtonNode) {
        self.didSelectItem?(self.section, self.card)
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
            shareContrroller.canonicalIdentifier = "criterionHundredShare"
            shareContrroller.channel = "Evaluate"
            shareContrroller.shareHandler = { () in
                sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
            }
            
            self.viewController?.present(shareContrroller, animated: true, completion: nil)
        }
    }
}

class HundredNode: ASCellNode {
    // MARK: - UI
    var title: TitleNode!
    var slider: CriterionEvaluateNode!
    var separator: SeparatorNode!
    var analytics: EvaluateLineAnalyticsNode!
    var share: ShareNode!
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, current: Float, previous: Float, date: Date, isPositive: Bool, lock: Bool, values: [Float], dashboard: (String, UIImage)?) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: Sources.image(forType: .criterionHundred))
        self.slider = CriterionEvaluateNode(current: current, previous: previous, date: date, maxValue: 100.0, isPositive: isPositive, lock: lock)
        self.separator = SeparatorNode()
        self.separator.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        self.analytics = EvaluateLineAnalyticsNode(values: values, maxValue: 100.0)
        self.share = ShareNode(dashboardImage: dashboard?.1, collectionTitle: dashboard?.0, cardTitle: title)
        
        // Accessibility
        self.accessibilityNode.isAccessibilityElement = true
        var criterionType = Localizations.Accessibility.Evaluate.Criterion.negative
        if isPositive {
            criterionType = Localizations.Accessibility.Evaluate.Criterion.positive
        }
        self.accessibilityNode.accessibilityLabel = "\(title), \(subtitle), \(Sources.title(forType: .criterionHundred)), \(criterionType)"
        self.accessibilityNode.accessibilityValue = Localizations.Accessibility.current("\(Int(current))")
        self.accessibilityNode.accessibilityTraits = UIAccessibilityTraitButton
        
        self.slider.didSliderLoad = { () in
            self.slider.slider.accessibilityLabel = title
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title, self.slider, self.analytics, self.share, self.separator]
        
        let cell = ASBackgroundLayoutSpec(child: stack, background: self.accessibilityNode)
        return cell
    }
}
