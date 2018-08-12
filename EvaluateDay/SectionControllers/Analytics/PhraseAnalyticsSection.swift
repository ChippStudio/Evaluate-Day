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
    case time
    case calendar
    case more
    case export
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
        if Store.current.isPro {
            self.nodes.append(.statistics)
        }
        self.nodes.append(.time)
        self.nodes.append(.calendar)
        self.nodes.append(.more)
        if Store.current.isPro {
            self.nodes.append(.export)
        }
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return self.nodes.count
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let style = Themes.manager.analyticalStyle
        let nodeType = self.nodes[index]
        switch nodeType {
        case .title:
            let title = self.card.title
            let subtitle = self.card.subtitle
            let image = Sources.image(forType: self.card.type)
            let isPro = Store.current.isPro
            return {
                let node = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
                node.topInset = 10.0
                if isPro {
                    node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                } else {
                    node.shareButton.alpha = 0.0
                }
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                return node
            }
        case .statistics:
            self.data = [(title: String, data: String)]()
            // Set statistics information
            var max: Int = 0
            var min: Int = 100000000
            var average: Double = 0.0
            var sum = 0
            let phraseCard = self.card.data as! PhraseCard
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
            self.data!.append((title: Localizations.analytics.statistics.days + ":", data: "\(phraseCard.values.count)"))
            self.data!.append((title: Localizations.analytics.statistics.maximum + ":", data: "\(max)"))
            self.data!.append((title: Localizations.analytics.statistics.minimum + ":", data: "\(min)"))
            self.data!.append((title: Localizations.analytics.statistics.average + ":", data: "\(average)"))
            self.data!.append((title: Localizations.analytics.statistics.sum + ":", data: "\(sum)"))
            return {
                let node = AnalyticsStatisticNode(title: Localizations.analytics.statistics.title, data: self.data!, style: style)
                return node
            }
        case .time:
            return {
                let node = AnalyticsTimeTravelNode(style: style)
                return node
            }
        case .calendar:
            return {
                let node = AnalyticsCalendarNode(title: Localizations.analytics.phrase.calendar.title.uppercased(), style: style)
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                node.topInset = 20.0
                node.didLoadCalendar = { () in
                    node.calendar.delegate = self
                }
                return node
            }
        case .export:
            return {
                let node = AnalyticsExportNode(types: [.csv, .json, .txt], title: Localizations.analytics.export.title.uppercased(), action: Localizations.analytics.export.action.uppercased(), style: style)
                node.topOffset = 50.0
                node.didSelectType = { (type, cellIndexPath, index) in
                    self.export(withType: type, indexPath: cellIndexPath, index: index)
                }
                return node
            }
        case .more:
            return {
                let node = SettingsMoreNode(title: Localizations.analytics.phrase.viewAll, subtitle: nil, image: nil, style: style)
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
        if nodes[index] == .more {
            if let parent = self.viewController?.parent as? UINavigationController {
                let controller = UIStoryboard(name: Storyboards.phrases.rawValue, bundle: nil).instantiateInitialViewController() as! PhrasesViewController
                controller.card = self.card
                parent.pushViewController(controller, animated: true)
            }
        } else if self.nodes[index] == .time {
            let controller = UIStoryboard(name: Storyboards.time.rawValue, bundle: nil).instantiateInitialViewController() as! TimeViewController
            controller.card = self.card
            self.viewController!.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let style = Themes.manager.analyticalStyle
        let phraseCard = self.card.data as! PhraseCard
        if phraseCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first != nil {
            return style.calendarSetColor
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
        imageBackgroundView.backgroundColor = Themes.manager.analyticalStyle.background
        
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
