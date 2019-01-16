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
        var colorName = ""
        for c in colorsForSelection {
            if c.color == color {
                colorName = c.name
                break
            }
        }
        var colors = [String]()
        for i in 1...7 {
            var components = DateComponents()
            components.day = i * -1
            let date = Calendar.current.date(byAdding: components, to: self.date)!
            if let color = colorCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first {
                colors.insert(color.text, at: 0)
            } else {
                colors.insert("", at: 0)
            }
        }
        let board = self.card.dashboardValue?.1
        
        return {
            let node = ColorNode(title: title, subtitle: subtitle, image: image, selectedColor: color, colorName: colorName, date: self.date, lock: lock, colors: colors, dashboard: board)
            
            node.analytics.button.addTarget(self, action: #selector(self.analyticsButton(sender:)), forControlEvents: .touchUpInside)
            node.share.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
            
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
                
                //Feedback
                Feedback.player.play(sound: nil, hapticFeedback: true, impact: false, feedbackType: nil)
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
            shareContrroller.canonicalIdentifier = "colorShare"
            shareContrroller.channel = "Evaluate"
            shareContrroller.shareHandler = { () in
                sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
            }
            
            self.viewController?.present(shareContrroller, animated: true, completion: nil)
        }
    }
}

class ColorNode: ASCellNode {
    // MARK: - UI
    var title: TitleNode!
    var colors: ColorEvaluateNode!
    var separator: SeparatorNode!
    var analytics: EvaluateColorDotsAnalyticsNode!
    var share: ShareNode!
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, selectedColor: String, colorName: String, date: Date, lock: Bool, colors: [String], dashboard: UIImage?) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image)
        self.colors = ColorEvaluateNode(selectedColor: selectedColor, date: date, lock: lock)
        self.analytics = EvaluateColorDotsAnalyticsNode(colors: colors)
        self.separator = SeparatorNode()
        self.separator.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        
        self.share = ShareNode(dashboardImage: dashboard)
        
        // Accessibility
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = "\(title), \(subtitle), \(Sources.title(forType: .color))"
        self.accessibilityNode.accessibilityValue = colorName
        self.accessibilityNode.accessibilityTraits = UIAccessibilityTraitButton
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title, self.colors, self.analytics, self.share, self.separator]
        
        let cell = ASBackgroundLayoutSpec(child: stack, background: self.accessibilityNode)
        return cell
    }
}
