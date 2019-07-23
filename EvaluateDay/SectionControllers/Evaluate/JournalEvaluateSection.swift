//
//  JournalEvaluateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 31/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit
import Branch
import RealmSwift

class JournalEvaluateSection: ListSectionController, ASSectionController, EvaluableSection {
    // MARK: - Variable
    var card: Card!
    var date: Date! {
        didSet {
            let journalCard = self.card.data as! JournalCard
            self.values = journalCard.values.filter("created >= %@ AND created <= %@", self.date.start, self.date.end).sorted(byKeyPath: "created", ascending: false)
        }
    }
    
    private var values: Results<TextValue>!
    
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
    
    func nodeForItem(at index: Int) -> ASCellNode {
        return ASCellNode()
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        var lock = false
        if self.date.start.days(to: Date().start) > pastDaysLimit && !Store.current.isPro {
            lock = true
        }
        
        if self.card.archived {
            lock = true
        }
        
        let title: String
        if self.card.archived {
            title = cardArchivedMark + self.card.title
        } else {
            title = self.card.title
        }
        let subtitle = self.card.subtitle
        let image = Sources.image(forType: self.card.type)
        
        var entries = [(preview: String, images: [UIImage?], date: Date, weatherImage: UIImage?, weatherText: String, locationText: String)]()
        
        for entry in self.values {
            let text = entry.text
            let date = entry.created
            var weatherImage: UIImage?
            var locationText = ""
            var weatherText = ""
            if let w = entry.weather {
                weatherImage = UIImage(named: w.icon)
                var temperature = "\(String(format: "%.0f", w.temperarure)) ℃"
                if !Database.manager.application.settings.celsius {
                    temperature = "\(String(format: "%.0f", (w.temperarure * (9/5) + 32))) ℉"
                }
                weatherText = temperature
            }
            if let loc = entry.location {
                locationText.append(loc.streetString)
                locationText.append(", \(loc.cityString)")
            }
            var photos = [UIImage?]()
            for p in entry.photos {
                photos.append(p.image)
            }
            if photos.isEmpty {
                photos.append(nil)
            }
            
            entries.append((preview: text, images: photos, date: date, weatherImage: weatherImage, weatherText: weatherText, locationText: locationText))
        }
        
        var entriesCount = [Int]()
        for i in 1...7 {
            var components = DateComponents()
            components.day = i * -1
            let date = Calendar.current.date(byAdding: components, to: self.date)!
            let c = (self.card.data as! JournalCard).values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).count
            entriesCount.insert(c, at: 0)
        }
        let board = self.card.dashboardValue
        
        return {
            let node = JournalNode(title: title, subtitle: subtitle, image: image, date: self.date, entries: entries, values: entriesCount, dashboard: board)
            
            node.analytics.button.addTarget(self, action: #selector(self.analyticsButton(sender:)), forControlEvents: .touchUpInside)
            node.share.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
            
            if !lock {
                node.new.actionButton.addTarget(self, action: #selector(self.makeNewEntry(sender:)), forControlEvents: .touchUpInside)
            }
            
            for entry in node.entries {
                entry.didSelectItem = { (i) in
                    let entry = self.values[i]
                    let controller = UIStoryboard(name: Storyboards.entry.rawValue, bundle: nil).instantiateInitialViewController() as! EntryViewController
                    controller.card = self.card
                    controller.textValue = entry
                    if let nav = self.viewController?.parent as? UINavigationController {
                        nav.pushViewController(controller, animated: true)
                    } else {
                        let nav = UINavigationController(rootViewController: controller)
                        self.viewController?.present(nav, animated: true, completion: nil)
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
    
    @objc private func makeNewEntry(sender: ASButtonNode) {
        let controller = UIStoryboard(name: Storyboards.entry.rawValue, bundle: nil).instantiateInitialViewController() as! EntryViewController
        controller.card = self.card
        controller.new = true
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let testComponents = Calendar.current.dateComponents([.hour, .minute], from: self.date)

        let textValue = TextValue()
        textValue.owner = self.card.id
        if testComponents.hour == 0 {
            textValue.created = Calendar.current.date(byAdding: components, to: self.date)!
        }
        try! Database.manager.data.write {
            Database.manager.data.add(textValue, update: true)
        }
        
        self.viewController?.userActivity = self.card.data.shortcut(for: .journalNewEntry)
        self.viewController?.userActivity?.becomeCurrent()
        
        //Feedback
        Feedback.player.play(sound: nil, hapticFeedback: true, impact: false, feedbackType: nil)
        
        controller.textValue = textValue
        if let nav = self.viewController?.parent as? UINavigationController {
            nav.pushViewController(controller, animated: true)
        } else {
            let nav = UINavigationController(rootViewController: controller)
            self.viewController?.present(nav, animated: true, completion: nil)
        }
    }
    @objc private func shareAction(sender: ASButtonNode) {
        let node: JournalNode!
        
        if let controller = self.viewController as? EvaluateViewController {
            if let tNode = controller.collectionNode.nodeForItem(at: IndexPath(row: 0, section: self.section)) as? JournalNode {
                node = tNode
            } else {
                return
            }
            
        } else {
            return
        }
        
        node.share.shareCover.alpha = 0.0
        node.share.shareImage.alpha = 0.0
        
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
            shareContrroller.canonicalIdentifier = "journalShare"
            shareContrroller.channel = "Evaluate"
            shareContrroller.shareHandler = { () in
                sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
            }
            
            self.viewController?.present(shareContrroller, animated: true, completion: nil)
        }
        
        node.share.shareCover.alpha = 1.0
        node.share.shareImage.alpha = 1.0
    }
}

class JournalNode: ASCellNode {
    // MARK: - UI
    var title: TitleNode!
    var entries = [JournalEntryNode]()
    var new: JournalNewEntryActionNode!
    var separator: SeparatorNode!
    var analytics: EvaluateDashedLineAnalyticsNode!
    var share: ShareNode!
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, date: Date, entries: [(preview: String, images: [UIImage?], date: Date, weatherImage: UIImage?, weatherText: String, locationText: String)], values: [Int], dashboard: (String, UIImage)?) {
        super.init()
        
        self.backgroundColor = UIColor.background
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image)
        self.new = JournalNewEntryActionNode(date: date)
        for (i, entry) in entries.enumerated() {
            let newEntry = JournalEntryNode(preview: entry.preview, images: entry.images, date: entry.date, weatherImage: entry.weatherImage, weatherText: entry.weatherText, locationText: entry.locationText, index: i)
            self.entries.append(newEntry)
        }
        
        self.analytics = EvaluateDashedLineAnalyticsNode(values: values)
        
        self.separator = SeparatorNode()
        self.separator.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        
        self.share = ShareNode(dashboardImage: dashboard?.1, collectionTitle: dashboard?.0, cardTitle: title)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        // Accessibility
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = "\(title), \(subtitle), \(Sources.title(forType: .journal))"
        self.accessibilityNode.accessibilityValue = Localizations.Accessibility.Evaluate.Journal.value(formatter.string(from: date), entries.count)
        self.accessibilityNode.accessibilityTraits = UIAccessibilityTraits.button
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.title]
        
        for entry in self.entries {
            stack.children!.append(entry)
        }
        
        stack.children!.append(new)
        stack.children!.append(self.analytics)
        stack.children!.append(self.share)
        stack.children!.append(self.separator)
        
        let cell = ASBackgroundLayoutSpec(child: stack, background: self.accessibilityNode)
        return cell
    }
}
