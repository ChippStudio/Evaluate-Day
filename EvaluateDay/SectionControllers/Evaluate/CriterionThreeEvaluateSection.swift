//
//  CriterionThreeEvaluateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 17/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit
import Branch

class CriterionThreeEvaluateSection: ListSectionController, ASSectionController, EvaluableSection {
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
        let archived = self.card.archived
        
        let criterionCard = self.card.data as! CriterionThreeCard
        var value: Double?
        var previousValue: Double?
        let isPositive = criterionCard.positive
        if let saveValue = criterionCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).sorted(byKeyPath: "edited", ascending: false).first {
            value = saveValue.value
        }
        
        var components = DateComponents()
        components.day = -1
        
        let previousDate = Calendar.current.date(byAdding: components, to: self.date)!
        if let saveValue = criterionCard.values.filter("(created >= %@) AND (created <= %@)", previousDate.start, previousDate.end).sorted(byKeyPath: "edited", ascending: false).first {
            previousValue = saveValue.value
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
            let node = ThreeNode(title: title, subtitle: subtitle, current: value, previousValue: previousValue, date: self.date, isPositive: isPositive, lock: lock, values: values, dashboard: board)
            node.analytics.button.addTarget(self, action: #selector(self.analyticsButton(sender:)), forControlEvents: .touchUpInside)
            node.share.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
            
            node.buttons.didChangeValue = { newCurrentValue in
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
                    
                    //Feedback
                    Feedback.player.play(sound: nil, hapticFeedback: true, impact: false, feedbackType: nil)
                    
                    self.collectionContext?.performBatch(animated: false, updates: { (batchContext) in
                        batchContext.reload(self)
                    }, completion: nil)
                }
            }
            
            if archived {
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
            shareContrroller.canonicalIdentifier = "criterionThreeShare"
            shareContrroller.channel = "Evaluate"
            shareContrroller.shareHandler = { () in
                sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
            }
            
            self.viewController?.present(shareContrroller, animated: true, completion: nil)
        }
    }
}

class ThreeNode: ASCellNode {
    // MARK: - UI
    var title: TitleNode!
    var buttons: CriterionThreeEvaluateNode!
    var separator: SeparatorNode!
    var analytics: EvaluateLineAnalyticsNode!
    var share: ShareNode!
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, current: Double?, previousValue: Double?, date: Date, isPositive: Bool, lock: Bool, values: [Float], dashboard: (String, UIImage)?) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: Sources.image(forType: .criterionThree))
        self.buttons = CriterionThreeEvaluateNode(value: current, previousValue: previousValue, date: date, lock: lock, positive: isPositive)
        self.separator = SeparatorNode()
        self.separator.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        self.analytics = EvaluateLineAnalyticsNode(values: values, maxValue: 3.0)
        self.share = ShareNode(dashboardImage: dashboard?.1, collectionTitle: dashboard?.0, cardTitle: title)
        
        // Accessibility
        self.accessibilityNode.isAccessibilityElement = true
        var criterionType = Localizations.Accessibility.Evaluate.Criterion.negative
        if isPositive {
            criterionType = Localizations.Accessibility.Evaluate.Criterion.positive
        }
        self.accessibilityNode.accessibilityLabel = "\(title), \(subtitle), \(Sources.title(forType: .criterionThree)), \(criterionType)"
        var currentValueString = Localizations.General.none
        if current != nil {
            if current! == 0 {
                currentValueString = Localizations.Accessibility.Evaluate.Criterion.Three.bad
                if !isPositive {
                    currentValueString = Localizations.Accessibility.Evaluate.Criterion.Three.good
                }
            } else if current == 1 {
                currentValueString = Localizations.Accessibility.Evaluate.Criterion.Three.neutral
            } else {
                currentValueString = Localizations.Accessibility.Evaluate.Criterion.Three.good
                if !isPositive {
                    currentValueString = Localizations.Accessibility.Evaluate.Criterion.Three.bad
                }
            }
        }
        
        self.accessibilityNode.accessibilityValue = Localizations.Accessibility.current(currentValueString)
        self.accessibilityNode.accessibilityTraits = UIAccessibilityTraitButton
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title, self.buttons, self.analytics, self.share, self.separator]
        
        let cell = ASBackgroundLayoutSpec(child: stack, background: self.accessibilityNode)
        return cell
    }
}
