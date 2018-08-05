//
//  ColorEvaluateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 08/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit
import Branch

class ColorEvaluateSection: ListSectionController, ASSectionController, EvaluableSection {
    // MARK: - Variable
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
        
        let colorCard = self.card.data as! ColorCard
        var color = "FFFFF"
        if let value = colorCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).sorted(byKeyPath: "edited", ascending: false).first {
            color = value.text
        }
        
        return {
            let node = ColorNode(title: title, subtitle: subtitle, image: image, selectedColor: color, lock: lock, style: style)
            node.visual(withStyle: style)
            
            OperationQueue.main.addOperation {
                node.title.shareButton.view.tag = index
            }
            node.title.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
            
            node.colors.didSelectColor = { (color) in
                if colorCard.realm != nil {
                    if let value = colorCard.values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).sorted(byKeyPath: "edited", ascending: false).first {
                        try! Database.manager.data.write {
                            value.text = color
                            value.edited = Date()
                        }
                    } else {
                        let newValue = TextValue()
                        newValue.text = color
                        newValue.owner = self.card.id
                        newValue.created = self.date
                        try! Database.manager.data.write {
                            Database.manager.data.add(newValue)
                        }
                    }
                }
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
    @objc private func shareAction(sender: ASButtonNode) {
        let indexPath = IndexPath(row: sender.view.tag, section: self.section)
        
        // Make shareble view
        var color: String?
        if let value = (self.card.data as! ColorCard).values.filter("(created >= %@) AND (created <= %@)", self.date.start, self.date.end).first {
            color = value.text
        }
        let inView = EvaluateColorShareView(color: color, title: self.card.title, subtitle: self.card.subtitle, date: self.date)
        
        // Share Image
        let sv = ShareView(view: inView)
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
        let linkObject = BranchUniversalObject(canonicalIdentifier: "colorShare")
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

class ColorNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var colors: ColorEvaluateNode!
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, selectedColor: String, lock: Bool, style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
        self.colors = ColorEvaluateNode(selectedColor: selectedColor, lock: lock, style: style)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title, self.colors]
        
        return stack
    }
}
