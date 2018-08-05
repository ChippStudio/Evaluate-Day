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
        
        let listCard = self.card.data as! ListCard
        let done = listCard.values.filter("(doneDate >= %@) AND (doneDate <= %@) AND (done=%@)", self.date.start, self.date.end, true).count
        let allDone = listCard.values.filter("done=%@", true).count
        let all = listCard.values.count
        
        return {
            let node = ListNode(title: title, subtitle: subtitle, image: image, all: all, allDone: allDone, inDay: done, style: style)
            node.visual(withStyle: style)
            
            OperationQueue.main.addOperation {
                node.title.shareButton.view.tag = index
            }
            node.title.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
            
            if !lock {
                node.list.openListButton.addTarget(self, action: #selector(self.openListAction(sender:)), forControlEvents: .touchUpInside)
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
    
    // MARK: - Actions
    @objc private func openListAction(sender: ASButtonNode) {
        if let nav = self.viewController?.parent as? UINavigationController {
            let controller = UIStoryboard(name: Storyboards.list.rawValue, bundle: nil).instantiateInitialViewController() as! ListViewController
            controller.card = self.card
            controller.date = self.date
            nav.pushViewController(controller, animated: true)
        }
    }
    @objc private func shareAction(sender: ASButtonNode) {
        let indexPath = IndexPath(row: sender.view.tag, section: self.section)
        let listCard = self.card.data as! ListCard
        let done = listCard.values.filter("(doneDate >= %@) AND (doneDate <= %@) AND (done=%@)", self.date.start, self.date.end, true).count
        let allDone = listCard.values.filter("done=%@", true).count
        let all = listCard.values.count
        
        let sv = ShareView(view: EvaluateListShareView(all: all, inDayDone: done, allDone: allDone, title: self.card.title, subtitle: self.card.subtitle, date: self.date))
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
        let linkObject = BranchUniversalObject(canonicalIdentifier: "listShare")
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

class ListNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var list: ListEvaluateNode!
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, all: Int, allDone: Int, inDay: Int, style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
        self.list = ListEvaluateNode(all: all, allDone: allDone, inDay: inDay, style: style)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title, self.list]
        
        return stack
    }
}
