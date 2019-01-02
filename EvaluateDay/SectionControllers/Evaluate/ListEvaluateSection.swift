//
//  ListEvaluateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit
import Branch

class ListEvaluateSection: ListSectionController, ASSectionController, EvaluableSection {
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
        
        let listCard = self.card.data as! ListCard
        let done = listCard.values.filter("(doneDate >= %@) AND (doneDate <= %@) AND (done=%@)", self.date.start, self.date.end, true).count
        let allDone = listCard.values.filter("done=%@", true).count
        let all = listCard.values.count
        
        let cardType = Sources.title(forType: self.card.type)
        let board = self.card.dashboardValue
        
        return {
            let node = ListNode(title: title, subtitle: subtitle, image: image, all: all, allDone: allDone, inDay: done, date: self.date, cardType: cardType, dashboard: board, style: style)
            node.visual(withStyle: style)
            
            if !lock {
                node.list.openListButton.addTarget(self, action: #selector(self.openListAction(sender:)), forControlEvents: .touchUpInside)
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
    @objc private func openListAction(sender: ASButtonNode) {
        let controller = UIStoryboard(name: Storyboards.list.rawValue, bundle: nil).instantiateInitialViewController() as! ListViewController
        controller.card = self.card
        controller.date = self.date
        
        if let nav = self.viewController?.parent as? UINavigationController {
            nav.pushViewController(controller, animated: true)
        } else {
            let nav = UINavigationController(rootViewController: controller)
            self.viewController?.present(nav, animated: true, completion: nil)
        }
        
        //Feedback
        Feedback.player.play(sound: nil, hapticFeedback: true, impact: false, feedbackType: nil)
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
            shareContrroller.canonicalIdentifier = "listShare"
            shareContrroller.channel = "Evaluate"
            shareContrroller.shareHandler = { () in
                sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
            }
            
            self.viewController?.present(shareContrroller, animated: true, completion: nil)
        }
    }
}

class ListNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var list: ListEvaluateNode!
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, all: Int, allDone: Int, inDay: Int, date: Date, cardType: String, dashboard: (title: String, image: UIImage)?, style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image)
        self.list = ListEvaluateNode(all: all, allDone: allDone, inDay: inDay, date: date, style: style)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        // Accessibility
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = "\(title), \(subtitle), \(cardType)"
        self.accessibilityNode.accessibilityValue = Localizations.accessibility.evaluate.list.done(value1: formatter.string(from: date), "\(inDay)")
        self.accessibilityNode.accessibilityTraits = UIAccessibilityTraitButton
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title, self.list]
        
        let cell = ASBackgroundLayoutSpec(child: stack, background: self.accessibilityNode)
        return cell
    }
}
