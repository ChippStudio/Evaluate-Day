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
}

class PhraseAnalyticsSection: ListSectionController, ASSectionController, AnalyticalSection, FSCalendarDelegate, FSCalendarDelegateAppearance {
    // MARK: - Variable
    var card: Card!
    var shareCalendarImage: UIImage?
    
    private var data: [(title: String, data: String)]?
    
    private var nodes = [AnalyticsNodeType]()
    
    // MARK: - Actions
    var shareHandler: ((IndexPath, [Any]) -> Void)?
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
        case .calendar:
            return {
                let node = AnalyticsCalendarNode(title: Localizations.analytics.phrase.calendar.title.uppercased(), style: style)
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                node.topInset = 50.0
                node.didLoadCalendar = { () in
                    node.calendar.delegate = self
                }
                node.preShareAction = { (image) in
                    self.shareCalendarImage = image
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
        let style = Themes.manager.analyticalStyle
        let indexPath = IndexPath(row: sender.view.tag, section: self.section)
        // Make shareble view
        var inView = UIView()
        if self.shareCalendarImage != nil {
            inView = AnalyticsCalendarShareView(image: self.shareCalendarImage!, title: self.card.title, subtitle: self.card.subtitle, type: self.card.type)
            self.shareCalendarImage = nil
        } else {
            // View from title
            if self.data != nil {
                var stack = [UIView]()
                for d in self.data! {
                    let view = UIView()
                    view.backgroundColor = UIColor.clear
                    
                    let leftLabel = UILabel()
                    leftLabel.text = d.title
                    leftLabel.textColor = style.statisticDataTitleColor
                    leftLabel.font = style.statisticDataTitleFont
                    view.addSubview(leftLabel)
                    leftLabel.snp.makeConstraints({ (make) in
                        make.top.equalToSuperview()
                        make.leading.equalToSuperview()
                    })
                    
                    let rightLabel = UILabel()
                    rightLabel.textColor = style.statisticDataColor
                    rightLabel.font = style.statisticDataFont
                    rightLabel.textAlignment = .right
                    rightLabel.text = d.data
                    view.addSubview(rightLabel)
                    rightLabel.snp.makeConstraints({ (make) in
                        make.top.equalToSuperview()
                        make.trailing.equalToSuperview()
                        make.leading.equalTo(leftLabel.snp.trailing).offset(5.0)
                    })
                    
                    let separator = UIView()
                    separator.backgroundColor = style.statisticSeparatorColor
                    
                    view.addSubview(separator)
                    separator.snp.makeConstraints({ (make) in
                        make.trailing.equalToSuperview().offset(-5.0)
                        make.leading.equalToSuperview().offset(5.0)
                        make.bottom.equalToSuperview()
                        make.top.equalTo(rightLabel.snp.bottom).offset(5.0)
                        make.top.equalTo(leftLabel.snp.bottom).offset(5.0)
                        make.height.equalTo(0.5)
                    })
                    
                    stack.append(view)
                }
                
                inView = AnalyticsStackShareView(stack: stack, text: "", title: self.card.title, subtitle: self.card.subtitle, type: self.card.type)
            }
        }
        
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
        let linkObject = BranchUniversalObject(canonicalIdentifier: "phraseShare")
        linkObject.title = Localizations.share.link.title
        linkObject.contentDescription = Localizations.share.description
        
        let linkProperties = BranchLinkProperties()
        linkProperties.feature = "Content share"
        linkProperties.channel = "Analytics"
        
        linkObject.getShortUrl(with: linkProperties) { (link, error) in
            if error != nil && link == nil {
                print(error!.localizedDescription)
            } else {
                items.append(link!)
            }
            
            self.shareHandler?(indexPath, items)
        }
    }
}
