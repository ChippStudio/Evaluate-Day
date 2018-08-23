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
        
        let cardType = Sources.title(forType: self.card.type)
        
        return {
            let node = ThreeNode(title: title, subtitle: subtitle, image: image, current: value, previousValue: previousValue, date: self.date, isPositive: isPositive, lock: lock, cardType: cardType, style: style)
            node.visual(withStyle: style)
            
            OperationQueue.main.addOperation {
                node.title.shareButton.view.tag = index
            }
            node.title.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
            
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
    
    // MARK: - Actions
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
            shareContrroller.canonicalIdentifier = "criterionThreeShare"
            shareContrroller.channel = "Evaluate"
            shareContrroller.shareHandler = { () in
                sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
            }
            
            self.viewController?.present(shareContrroller, animated: true, completion: nil)
        }
    }
}

class ThreeNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var buttons: CriterionThreeEvaluateNode!
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, current: Double?, previousValue: Double?, date: Date, isPositive: Bool, lock: Bool, cardType: String, style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
        self.buttons = CriterionThreeEvaluateNode(value: current, previousValue: previousValue, date: date, lock: lock, positive: isPositive, style: style)
        
        // Accessibility
        self.accessibilityNode.isAccessibilityElement = true
        var criterionType = Localizations.accessibility.evaluate.value.criterion.negative
        if isPositive {
            criterionType = Localizations.accessibility.evaluate.value.criterion.positive
        }
        self.accessibilityNode.accessibilityLabel = "\(title), \(subtitle), \(cardType), \(criterionType)"
        var currentValueString = Localizations.general.none
        if current != nil {
            if current! == 0 {
                currentValueString = Localizations.accessibility.evaluate.value.criterion.three.bad
                if !isPositive {
                    currentValueString = Localizations.accessibility.evaluate.value.criterion.three.good
                }
            } else if current == 1 {
                currentValueString = Localizations.accessibility.evaluate.value.criterion.three.neutral
            } else {
                currentValueString = Localizations.accessibility.evaluate.value.criterion.three.good
                if !isPositive {
                    currentValueString = Localizations.accessibility.evaluate.value.criterion.three.bad
                }
            }
        }
        
        self.accessibilityNode.accessibilityValue = Localizations.accessibility.evaluate.value.current(value1: currentValueString)
        self.accessibilityNode.accessibilityTraits = UIAccessibilityTraitButton
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title, self.buttons]
        
        let cell = ASBackgroundLayoutSpec(child: stack, background: self.accessibilityNode)
        return cell
    }
}
