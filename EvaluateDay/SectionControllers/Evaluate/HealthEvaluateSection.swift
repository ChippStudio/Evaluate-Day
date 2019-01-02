//
//  HealthEvaluateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 19/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit
import Branch
import HealthKit

class HealthEvaluateSection: ListSectionController, ASSectionController, EvaluableSection {
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
        
        self.getHealthData()
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 1
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let style = Themes.manager.evaluateStyle
        
//        var lock = false
//        if self.date.start.days(to: Date().start) > pastDaysLimit && !Store.current.isPro {
//            lock = true
//        }
//
//        if self.card.archived {
//            lock = true
//        }
        
        let title = self.card.title
        let subtitle = self.card.subtitle
        let image = Sources.image(forType: self.card.type)
        let archived = self.card.archived
//        let healthCard = self.card.data as! HealthCard
        let cardType = Sources.title(forType: self.card.type)
        let board = self.card.dashboardValue
        
        return {
            let node = HealthNode(title: title, subtitle: subtitle, image: image, cardType: cardType, dashboard: board, style: style)
            node.visual(withStyle: style)
            
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
            shareContrroller.canonicalIdentifier = "healthShare"
            shareContrroller.channel = "Evaluate"
            shareContrroller.shareHandler = { () in
                sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
            }
            
            self.viewController?.present(shareContrroller, animated: true, completion: nil)
        }
    }
    
    private func getHealthData() {
        let healthCard = self.card.data as! HealthCard
        
        guard let sourceObject = healthCard.source else {
            return
        }
        
        guard let unit = sourceObject.unit,
                let queryType = sourceObject.queryType,
                let sampleType = sourceObject.objectType else {
            return
        }
        
        // Get data from health kit
        let predicate = HKQuery.predicateForSamples(withStart: Date().start, end: Date().end, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let limit = 1
        
        var query: HKQuery!
        
        switch queryType {
        case .sample:
            query = HKSampleQuery(sampleType: sampleType as! HKSampleType, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                OperationQueue.main.addOperation {
                    if samples == nil {
                        return
                    }
                    
                    for sample in samples! {
                        if let s = sample as? HKQuantitySample {
                            print("Sample Start date - \(sample.startDate) : Sample End Date - \(sample.endDate)")
                            if #available(iOS 12.0, *) {
                                print("Quantity Count - \(s.count)")
                            } else {
                                // Fallback on earlier versions
                            }
                            print("Quantity - \(s.quantity.doubleValue(for: HKUnit.count()))")
                        }
                    }
                }
            }
        case .statistics:
            query = HKStatisticsQuery(quantityType: sampleType as! HKQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, stat, error) in
                if stat == nil {
                    return
                }
                if let quantity = stat!.sumQuantity() {
                    print("Sample Start date - \(stat!.startDate) : Sample End Date - \(stat!.endDate)")
                    print("Quantity - \(quantity.doubleValue(for: unit))")
                }
            }
        }
        
        HKHealthStore().execute(query)
    }
}

class HealthNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, cardType: String, dashboard: (title: String, image: UIImage)?, style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image)
        
        // Accessibility
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = "\(title), \(subtitle), \(cardType)"
//        self.accessibilityNode.accessibilityValue = Localizations.accessibility.current(value1: "\(value)")
        self.accessibilityNode.accessibilityTraits = UIAccessibilityTraitButton
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title]
        
        let cell = ASBackgroundLayoutSpec(child: stack, background: self.accessibilityNode)
        return cell
    }
}
