//
//  PhraseAnalyticsSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import FSCalendar
import SwiftyJSON
import Branch

private enum AnalyticsNodeType {
    case title
    case statistics
    case calendar
    case more
    case export
    case proReview
}

class PhraseAnalyticsSection: ListSectionController, ASSectionController, AnalyticalSection, FSCalendarDelegate, FSCalendarDelegateAppearance {
    // MARK: - Variable
    var card: Card!
    
    private var data: [(title: String, data: String)]?
    private var nodes = [AnalyticsNodeType]()
    
    // MARK: - Actions
    var exportHandler: ((_ indexPath: IndexPath, _ index: Int, _ item: Any) -> Void)?
    
    // MARK: - Init
    init(card: Card) {
        super.init()
        if let realmCard = Database.manager.data.objects(Card.self).filter("id=%@", card.id).first {
            self.card = realmCard
        } else {
            self.card = card
        }
        
        self.nodes.append(.title)
        self.nodes.append(.statistics)
        if !Store.current.isPro {
            self.nodes.append(.proReview)
        }
        self.nodes.append(.calendar)
        self.nodes.append(.more)
        self.nodes.append(.export)
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return self.nodes.count
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let nodeType = self.nodes[index]
        let isPro = Store.current.isPro
        switch nodeType {
        case .title:
            let title = self.card.title
            let subtitle = self.card.subtitle
            let image = Sources.image(forType: self.card.type)
            return {
                let node = TitleNode(title: title, subtitle: subtitle, image: image)
                return node
            }
        case .statistics:
            let phraseCard = self.card.data as! PhraseCard
            self.data = [(title: String, data: String)]()
            self.data!.append((title: Localizations.General.createDate, data: DateFormatter.localizedString(from: self.card.created, dateStyle: .medium, timeStyle: .none)))
            if card.archived {
                self.data!.append((title: Localizations.Activity.Analytics.Stat.archived, data: DateFormatter.localizedString(from: self.card.archivedDate!, dateStyle: .medium, timeStyle: .none)))
            }
            self.data!.append((title: Localizations.Analytics.Statistics.days, data: "\(phraseCard.values.count)"))
            if isPro {
                // Set statistics information
                var max: Int = 0
                var min: Int = 100000000
                var average: Double = 0.0
                var sum = 0
                for t in phraseCard.values {
                    let c = t.characters
                    if c > max {
                        max = c
                    }
                    if c < min {
                        min = c
                    }
                    sum += c
                }
                average = Double(sum) / Double(phraseCard.values.count)
                self.data!.append((title: Localizations.Analytics.Statistics.maximum, data: "\(max)"))
                self.data!.append((title: Localizations.Analytics.Statistics.minimum, data: "\(min)"))
                self.data!.append((title: Localizations.Analytics.Statistics.average, data: "\(average)"))
                self.data!.append((title: Localizations.Analytics.Statistics.sum, data: "\(sum)"))
            } else {
                // Set statistics information
                self.data!.append((title: Localizations.Analytics.Statistics.maximum, data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.minimum, data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.average, data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.sum, data: proPlaceholder))
            }
            return {
                let node = AnalyticsStatisticNode(data: self.data!)
                return node
            }
        case .calendar:
            return {
                let node = AnalyticsCalendarNode(title: Localizations.Analytics.Phrase.Calendar.title.uppercased(), isPro: true)
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                node.didLoadCalendar = { () in
                    node.calendar.delegate = self
                }
                return node
            }
        case .proReview:
            return {
                let node = AnalyticsProReviewNode()
                node.didLoadProView = { (pro) in
                    node.pro.button.addTarget(self, action: #selector(self.proReviewAction(sender:)), for: .touchUpInside)
                }
                return node
            }
        case .export:
            return {
                let node = AnalyticsExportNode(types: [.csv, .json, .txt], title: Localizations.Analytics.Export.title.uppercased(), action: Localizations.Analytics.Export.action.uppercased())
                node.topOffset = 50.0
                node.didSelectType = { (type, cellIndexPath, index) in
                    if isPro {
                        self.export(withType: type, indexPath: cellIndexPath, index: index)
                    } else {
                        let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
                        if let nav = self.viewController?.parent as? UINavigationController {
                            nav.pushViewController(controller, animated: true)
                        }
                    }
                }
                return node
            }
        case .more:
            return {
                let node = SettingsMoreNode(title: Localizations.Analytics.Phrase.viewAll, subtitle: nil, image: nil)
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
        if nodes[index] == .more {
            if let parent = self.viewController?.parent as? UINavigationController {
                let controller = UIStoryboard(name: Storyboards.phrases.rawValue, bundle: nil).instantiateInitialViewController() as! PhrasesViewController
                controller.card = self.card
                parent.pushViewController(controller, animated: true)
            }
        } else if self.nodes[index] == .calendar {
            if !Store.current.isPro {
                let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
                if let nav = self.viewController?.parent as? UINavigationController {
                    nav.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    // MARK: - FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let phraseCard = self.card.data as! PhraseCard
        if phraseCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first != nil {
            return UIColor.main
        }
        
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let phraseCard = self.card.data as! PhraseCard
        if phraseCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first != nil {
            return UIColor.white
        }
        
        return nil
    }
    
    // MARK: - Actions
    @objc private func proReviewAction(sender: UIButton) {
        if let nav = self.viewController?.navigationController {
            let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
            nav.pushViewController(controller, animated: true)
        }
    }
    
    private func export(withType type: ExportType, indexPath: IndexPath, index: Int) {
        //export data
        switch type {
        case .csv:
            if let file = self.setCSV() {
                self.exportHandler?(indexPath, index, file as Any)
            }
        case .txt:
            if let file = self.setTXT() {
                self.exportHandler?(indexPath, index, file as Any)
            }
        case .json:
            if let file = self.setJson() {
                self.exportHandler?(indexPath, index, file as Any)
            }
        }
    }
    private func setCSV() -> URL? {
        let fileName = "\(self.card.title).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var csvText = "Title,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Text\n"
        
        let phraseCard = self.card.data as! PhraseCard
        let sortedValues = phraseCard.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title),\(date),\(c.created.timeIntervalSince1970),\(edited),\(c.edited.timeIntervalSince1970),\(c.text)\n"
            
            csvText.append(newLine)
        }
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
        
        return path
    }
    
    private func setTXT() -> URL? {
        let fileName = "\(self.card.title).txt"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var txtText = "Title,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Text\n"
        
        let phraseCard = self.card.data as! PhraseCard
        let sortedValues = phraseCard.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title), \(date), \(c.created.timeIntervalSince1970), \(edited), \(c.edited.timeIntervalSince1970), \(c.text)\n"
            
            txtText.append(newLine)
        }
        do {
            try txtText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
        
        return path
    }
    private func setJson() -> URL? {
        let fileName = "\(self.card.title).json"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        let phraseCard = self.card.data as! PhraseCard
        let sortedValues = phraseCard.values.sorted(byKeyPath: "created")
        
        var json = JSON()
        json["title"].string = self.card.title
        json["subtitle"].string = self.card.subtitle
        json["created"].double = self.card.created.timeIntervalSince1970
        if self.card.archived {
            json["archived"].double = self.card.archivedDate?.timeIntervalSince1970
        }
        
        for (i, c) in sortedValues.enumerated() {
            var valueJSON = JSON()
            valueJSON["created"].double = c.created.timeIntervalSince1970
            valueJSON["edited"].double = c.edited.timeIntervalSince1970
            valueJSON["text"].string = c.text
            
            json["\(i)"] = valueJSON
        }
        do {
            try json.rawData().write(to: path!, options: Data.WritingOptions.atomicWrite)
        } catch {
            return nil
        }
        
        return path
    }
    @objc private func shareAction(sender: ASButtonNode) {
        guard let controller = self.viewController as? AnalyticsViewController else {
            return
        }
        
        let node = controller.collectionNode.nodeForItem(at: IndexPath(row: sender.view.tag, section: self.section))!
        
        var nodeImageViews = [UIImageView(image: node.view.snapshot)]
        if self.nodes[sender.view.tag] == .title {
            if let statNode = controller.collectionNode.nodeForItem(at: IndexPath(row: sender.view.tag + 1, section: self.section)) as? AnalyticsStatisticNode {
                nodeImageViews.append(UIImageView(image: statNode.view.snapshot))
            }
        }
        
        let imageBackgroundView = UIView()
        imageBackgroundView.backgroundColor = UIColor.background
        
        let stack = UIStackView(arrangedSubviews: nodeImageViews)
        stack.axis = .vertical
        
        imageBackgroundView.addSubview(stack)
        stack.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(imageBackgroundView)
        imageBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        imageBackgroundView.layoutIfNeeded()
        let imageBackgroundViewImage = imageBackgroundView.snapshot!
        imageBackgroundView.removeFromSuperview()
        
        let sv = ShareView(image: imageBackgroundViewImage)
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
        shareContrroller.canonicalIdentifier = "phraseShare"
        shareContrroller.channel = "Analytics"
        shareContrroller.shareHandler = { () in
            sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
        }
        
        self.viewController?.present(shareContrroller, animated: true, completion: nil)
    }
}
