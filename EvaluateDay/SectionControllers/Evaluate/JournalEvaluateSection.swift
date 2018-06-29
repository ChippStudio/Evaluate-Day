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
    var shareHandler: ((IndexPath, Card, [Any]) -> Void)?
    var deleteHandler: ((IndexPath, Card) -> Void)?
    var editHandler: ((IndexPath, Card) -> Void)?
    var mergeHandler: ((IndexPath, Card) -> Void)?
    var unarchiveHandler: ((IndexPath, Card) -> Void)?
    var didSelectItem: ((Int, Card) -> Void)?
    
    // MARK: - Flags
    var isOpenEdit: Bool = false
    
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
        var base: Int = 1
        if self.isOpenEdit {
            base += 1
        }
        if self.card.archived {
            base += 1
        }
        return base
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let style = Themes.manager.evaluateStyle
        
        if index == 0 {
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
            
            var entries = [(text: String, metadata: [String], photo: UIImage?)]()
            
            for entry in self.values {
                var metadata = [String]()
                metadata.append(DateFormatter.localizedString(from: entry.created, dateStyle: .none, timeStyle: .short))
                if let loc = entry.location {
                    if !loc.streetString.isEmpty {
                        metadata.append(loc.streetString)
                    }
                }
                if let w = entry.weather {
                    if w.pressure != 0.0 && w.humidity != 0.0 {
                        var temperature = "\(String(format: "%.0f", w.temperarure)) ℃"
                        //                    var apparentTemperature = "\(String(format: "%.0f", w.apparentTemperature)) ℃"
                        if !Database.manager.application.settings.celsius {
                            temperature = "\(String(format: "%.0f", (w.temperarure * (9/5) + 32))) ℉"
                            //                        apparentTemperature = "\(String(format: "%.0f", (w.apparentTemperature * (9/5) + 32))) ℉"
                        }
                        
                        metadata.append(temperature)
                    }
                }
                var photo: UIImage?
                if let p = entry.photos.first {
                    photo = p.image
                }
                
                entries.append((text: entry.text, metadata: metadata, photo: photo))
            }
            
            return {
                let node = JournalNode(title: title, subtitle: subtitle, image: image, entries: entries, style: style)
                node.visual(withStyle: style)
                
                OperationQueue.main.addOperation {
                    node.title.shareButton.view.tag = index
                }
                node.title.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                node.analytics.button.addTarget(self, action: #selector(self.analyticsNodeAction(sender:)), forControlEvents: .touchUpInside)
                
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
                        }
                    }
                }
                
                return node
            }
        }
        if index == 1 {
            if self.isOpenEdit {
                var actions = [ActionsNodeAction.settings, ActionsNodeAction.delete]
                if Database.manager.data.objects(Card.self).filter("typeRaw=%@ AND isDeleted=%@", self.card.typeRaw, false).count > 1 {
                    actions.insert(.merge, at: 0)
                }
                var isBottomDivider = false
                if self.card.archived {
                    isBottomDivider = true
                }
                return {
                    let node = ActionsNode(actions: actions, isDividers: true, isBottomDivider: isBottomDivider, style: style)
                    if !isBottomDivider {
                        node.bottomOffset = 50.0
                    }
                    for action in node.actions {
                        action.addTarget(self, action: #selector(self.actionHandler(sender:)), forControlEvents: .touchUpInside)
                    }
                    return node
                }
            } else {
                return {
                    let node = UnarchiveNode(style: style)
                    node.unarchiveButton.addTarget(self, action: #selector(self.unarchiveButtonAction(sender:)), forControlEvents: .touchUpInside)
                    return node
                }
            }
        } else {
            return {
                let node = UnarchiveNode(style: style)
                node.unarchiveButton.addTarget(self, action: #selector(self.unarchiveButtonAction(sender:)), forControlEvents: .touchUpInside)
                return node
            }
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
        
        self.isOpenEdit = !self.isOpenEdit
        collectionContext?.performBatch(animated: true, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    
    // MARK: - Actions
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
        
        controller.textValue = textValue
        if let nav = self.viewController?.parent as? UINavigationController {
            nav.pushViewController(controller, animated: true)
        }
    }
    @objc private func shareAction(sender: ASButtonNode) {
        let indexPath = IndexPath(row: sender.view.tag, section: self.section)
        
        // Make shareble view
        var entries = [TextValue]()
        let values = (self.card.data as! JournalCard).values.filter("created >= %@ AND created <= %@", self.date.start, self.date.end)
        for v in values {
            entries.append(v)
        }
        
        let inView = EvaluateJournalShareView(entries: entries, title: self.card.title, subtitle: self.card.subtitle, date: self.date)
        
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
        let linkObject = BranchUniversalObject(canonicalIdentifier: "journalShare")
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
    
    @objc private func actionHandler(sender: ASButtonNode) {
        let indexPath = IndexPath(row: 1, section: self.section)
        if let action = ActionsNodeAction(rawValue: sender.view.tag) {
            if action == .delete {
                self.deleteHandler?(indexPath, self.card)
            } else if action == .settings {
                self.editHandler?(indexPath, self.card)
            } else if action == .merge {
                self.mergeHandler?(indexPath, self.card)
            }
        }
    }
    
    @objc private func unarchiveButtonAction(sender: ASButtonNode) {
        var indexPath = IndexPath(row: 1, section: self.section)
        if self.isOpenEdit {
            indexPath = IndexPath(row: 2, section: self.section)
        }
        self.unarchiveHandler?(indexPath, self.card)
    }
    
    @objc private func analyticsNodeAction(sender: ASButtonNode) {
        self.didSelectItem?(self.section, self.card)
    }
}

class JournalNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var entries = [JournalEntryNode]()
    var new: JournalNewEntryActionNode!
    var analytics: AnalyticsNode!
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, entries: [(text: String, metadata: [String], photo: UIImage?)], style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
        self.new = JournalNewEntryActionNode(style: style)
        self.analytics = AnalyticsNode(style: style)
        for (i, entry) in entries.enumerated() {
            let newEntry = JournalEntryNode(text: entry.text, metadata: entry.metadata, photo: entry.photo, index: i, style: style)
            self.entries.append(newEntry)
        }
        
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
        
        return stack
    }
}
