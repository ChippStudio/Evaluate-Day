//
//  ColorAnalyticsSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 09/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import FSCalendar
import SwiftyJSON
import Branch
import Charts

private enum AnalyticsNodeType {
    case title
    case colorInformation
    case information
    case calendar
    case pieChart
    case export
    case proReview
    case more
}

class ColorAnalyticsSection: ListSectionController, ASSectionController, AnalyticalSection, FSCalendarDelegate, FSCalendarDelegateAppearance {
    // MARK: - Variable
    var card: Card!
    
    private var data: [(color: String, data: String)]?
    
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
        self.nodes.append(.information)
        if !Store.current.isPro {
            self.nodes.append(.proReview)
        }
        self.nodes.append(.calendar)
        self.nodes.append(.colorInformation)
        if Store.current.isPro {
            self.nodes.append(.pieChart)
        }
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
        case .information:
            let color = self.card.data as! ColorCard
            var data = [(title: String, data: String)]()
            data.append((title: Localizations.General.createDate, data: DateFormatter.localizedString(from: self.card.created, dateStyle: .medium, timeStyle: .none)))
            if card.archived {
                data.append((title: Localizations.Activity.Analytics.Stat.archived, data: DateFormatter.localizedString(from: self.card.archivedDate!, dateStyle: .medium, timeStyle: .none)))
            }
            data.append((title: Localizations.Analytics.Statistics.days, data: "\(color.values.count)"))
            
            return {
                let node = AnalyticsStatisticNode(data: data)
                return node
            }
        case .colorInformation:
            self.data = [(color: String, data: String)]()
            let colorCard = self.card.data as! ColorCard
            for color in colorsForSelection {
                let colorsCount = colorCard.values.filter("text=%@", color.color)
                if colorsCount.count != 0 {
                    if isPro {
                        data!.append((color: color.color, data: "\(colorsCount.count)"))
                    } else {
                        data!.append((color: color.color, data: proPlaceholder))
                    }
                }
            }
            return {
                let node = AnalyticsColorStatisticNode(data: self.data!)
                return node
            }
        case .pieChart:
            var data = [PieChartDataEntry]()
            var total: Int = 0
            let colorCard = self.card.data as! ColorCard
            for color in colorsForSelection {
                let colorsCount = colorCard.values.filter("text=%@", color.color)
                if colorsCount.count != 0 {
                    total += colorsCount.count
                    let d = PieChartDataEntry(value: Double(colorsCount.count), data: color.color.color as AnyObject)
                    data.append(d)
                }
            }
            let opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            return {
                let node = AnalyticsPieChartNode(title: Localizations.Analytics.Chart.Pie.Color.title, data: data, options: opt)
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                node.chartStringForValue = { (value, _, _, _) in
                    let percent = (Int(value) * 100) / total
                    return "\(percent) %"
                }
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                return node
            }
        case .calendar:
            return {
                let node = AnalyticsCalendarNode(title: Localizations.Analytics.Color.Calendar.title.uppercased())
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
        case .more:
            return {
                let node = SettingsMoreNode(title: Localizations.Analytics.allData, subtitle: nil, image: nil)
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
        if self.nodes[index] == .more {
            let controller = UIStoryboard(name: Storyboards.colorsList.rawValue, bundle: nil).instantiateInitialViewController() as! ColorsListViewController
            controller.card = self.card
            controller.values = (self.card.data as! ColorCard).values.sorted(byKeyPath: "created", ascending: false)
            self.viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let colorCard = self.card.data as! ColorCard
        if let value = colorCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first {
            let color = value.text
            return color.color
        }
        
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let colorCard = self.card.data as! ColorCard
        if let value = colorCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first {
            let color = value.text
            if color == "FFFFFF" {
                return UIColor.main
            } else {
                return UIColor.white
            }
        }
        
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        let colorCard = self.card.data as! ColorCard
        if let value = colorCard.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first {
            let color = value.text
            if color == "FFFFFF" {
                return UIColor.black
            }
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
        
        var csvText = "Title,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Value\n"
        
        let colorCard = self.card.data as! ColorCard
        let sortedValues = colorCard.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title),\(date),\(c.created.timeIntervalSince1970),\(edited),\(c.edited.timeIntervalSince1970),#\(c.text)\n"
            
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
        
        var txtText = "Title,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Value\n"
        
        let colorCard = self.card.data as! ColorCard
        let sortedValues = colorCard.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title), \(date), \(c.created.timeIntervalSince1970), \(edited), \(c.edited.timeIntervalSince1970), #\(c.text)\n"
            
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
        
        let colorCard = self.card.data as! ColorCard
        let sortedValues = colorCard.values.sorted(byKeyPath: "created")
        
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
            valueJSON["color"].string = c.text
            
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
            if let statNode = controller.collectionNode.nodeForItem(at: IndexPath(row: sender.view.tag + 1, section: self.section)) as? AnalyticsColorStatisticNode {
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
        shareContrroller.canonicalIdentifier = "colorShare"
        shareContrroller.channel = "Analytics"
        shareContrroller.shareHandler = { () in
            sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
        }
        
        self.viewController?.present(shareContrroller, animated: true, completion: nil)
    }
}
