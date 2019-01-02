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
        
        let cardType = Sources.title(forType: self.card.type)
        let board = self.card.dashboardValue
        
        return {
            let node = JournalNode(title: title, subtitle: subtitle, image: image, date: self.date, entries: entries, cardType: cardType, dashboard: board, style: style)
            node.visual(withStyle: style)
        
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
            shareContrroller.canonicalIdentifier = "journalShare"
            shareContrroller.channel = "Evaluate"
            shareContrroller.shareHandler = { () in
                sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
            }
            
            self.viewController?.present(shareContrroller, animated: true, completion: nil)
        }
    }
}

class JournalNode: ASCellNode, CardNode {
    // MARK: - UI
    var title: TitleNode!
    var entries = [JournalEntryNode]()
    var new: JournalNewEntryActionNode!
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, date: Date, entries: [(text: String, metadata: [String], photo: UIImage?)], cardType: String, dashboard: (title: String, image: UIImage)?, style: EvaluableStyle) {
        super.init()
        
        self.title = TitleNode(title: title, subtitle: subtitle, image: image)
        self.new = JournalNewEntryActionNode(date: date, style: style)
        for (i, entry) in entries.enumerated() {
            let newEntry = JournalEntryNode(text: entry.text, metadata: entry.metadata, photo: entry.photo, index: i, truncation: true, style: style)
            self.entries.append(newEntry)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        // Accessibility
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = "\(title), \(subtitle), \(cardType)"
        self.accessibilityNode.accessibilityValue = Localizations.accessibility.evaluate.journal.value(value1: formatter.string(from: date), entries.count)
        self.accessibilityNode.accessibilityTraits = UIAccessibilityTraitButton
        
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
        
        let cell = ASBackgroundLayoutSpec(child: stack, background: self.accessibilityNode)
        return cell
    }
}
