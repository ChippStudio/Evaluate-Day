//
//  CounterAnalyticsSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Charts
import SwiftyJSON
import Branch

private enum AnalyticsNodeType {
    case title
    case information
    case lineChart
    case barChart
    case export
    case average
    case total
    case more
}

class CounterAnalyticsSection: ListSectionController, ASSectionController, AnalyticalSection {
    // MARK: - Variable
    var card: Card!
    
    private var nodes = [AnalyticsNodeType]()
    private var data: [(title: String, data: String)]?
    
    // MARK: - Action
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
        self.nodes.append(.lineChart)
        self.nodes.append(.average)
        if (self.card.data as! CounterCard).isSum {
            self.nodes.append(.total)
        }
        self.nodes.append(.barChart)
        self.nodes.append(.more)
        self.nodes.append(.export)
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return self.nodes.count
    }
    
    func nodeForItem(at index: Int) -> ASCellNode {
        return ASCellNode()
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
            let counterCard = self.card.data as! CounterCard
            self.data = [(title: String, data: String)]()
            self.data!.append((title: Localizations.General.createDate, data: DateFormatter.localizedString(from: self.card.created, dateStyle: .medium, timeStyle: .none)))
            if card.archived {
                self.data!.append((title: Localizations.Activity.Analytics.Stat.archived, data: DateFormatter.localizedString(from: self.card.archivedDate!, dateStyle: .medium, timeStyle: .none)))
            }
            self.data!.append((title: Localizations.Analytics.Statistics.days, data: "\(counterCard.values.count)"))
            
            var minimum: Double = 3
            var maximum: Double = 0
            var sum: Double = 0
            for v in counterCard.values {
                if v.value > maximum {
                    maximum = v.value
                }
                if v.value < minimum {
                    minimum = v.value
                }
                
                sum += v.value
            }
            if counterCard.isSum {
                self.data!.append((title: Localizations.Analytics.Statistics.sum, data: "\(sum + counterCard.startValue)"))
            }
            self.data!.append((title: Localizations.Analytics.Statistics.maximum, data: "\(maximum)"))
            self.data!.append((title: Localizations.Analytics.Statistics.minimum, data: "\(minimum)"))
            self.data!.append((title: Localizations.Analytics.Statistics.average, data: "\(Float(sum)/Float(counterCard.values.count))"))

            return {
                let node = AnalyticsStatisticNode(data: self.data!)
                return node
            }
        case .lineChart:
            var data = [ChartDataEntry]()
            let counterCard = self.card.data as! CounterCard
            let sortedValues = counterCard.values.sorted(byKeyPath: "created")
            for v in sortedValues {
                let chartDataEntry = ChartDataEntry(x: Double(v.created.start.timeIntervalSince1970), y: Double(v.value), data: v.created.start as AnyObject)
                data.append(chartDataEntry)
            }
            
            var opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            opt?[.yLineNumber] = 5
            
            return {
                let node = AnalyticsLineChartNode(title: Localizations.Analytics.Chart.Line.Criterion.title, data: data, options: opt)
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                return node
            }
        case .average:
            var data = [BarChartDataEntry]()
            var opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            let counterCard = self.card.data as! CounterCard
            let sortedValues = counterCard.values.sorted(byKeyPath: "created")
            if let first = sortedValues.first {
                var runDate = first.created
                var barIndex: Double = 0.0
                let currentMonthEnd = Calendar.current.dateInterval(of: .month, for: Date())!.end
                while currentMonthEnd.timeIntervalSince1970 > runDate.timeIntervalSince1970 {
                    let monthInterval = Calendar.current.dateInterval(of: .month, for: runDate)!
                    let monthValues = counterCard.values.filter("(created >= %@) AND (created <= %@)", monthInterval.start, monthInterval.end)
                    if monthValues.count != 0 {
                        var total = 0.0
                        for v in monthValues {
                            total += v.value
                        }
                        let barEntry = BarChartDataEntry(x: barIndex, y:  total / Double(monthValues.count), data: monthInterval.start as AnyObject)
                        data.append(barEntry)
                        barIndex += 1
                    }
                    
                    var components = DateComponents()
                    components.month = 1
                    
                    let newRunDate = Calendar.current.date(byAdding: components, to: runDate)!
                    runDate = newRunDate
                }
            }
            
            opt?[.yLineNumber] = data.count
            return {
                let node = AnalyticsHorizontalBarChartNode(title: Localizations.Analytics.Chart.HorizontalBar.Criterion.averageTitle, data: data, options: opt)
                node.format = "%.1f"
                node.chartStringForValue = { (_, value, _) in
                    if Int(value) >= data.count {
                        return "WTF"
                    }
                    let entry = data[Int(value)]
                    if let date = entry.data as? Date {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMM YYYY"
                        return dateFormatter.string(from: date)
                    }
                    return ""
                }
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                return node
            }
        case .total:
            var data = [BarChartDataEntry]()
            var opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            let counterCard = self.card.data as! CounterCard
            let sortedValues = counterCard.values.sorted(byKeyPath: "created")
            if let first = sortedValues.first {
                var runDate = first.created
                var barIndex: Double = 0.0
                let currentMonthEnd = Calendar.current.dateInterval(of: .month, for: Date())!.end
                while currentMonthEnd.timeIntervalSince1970 > runDate.timeIntervalSince1970 {
                    let monthInterval = Calendar.current.dateInterval(of: .month, for: runDate)!
                    let monthValues = counterCard.values.filter("(created >= %@) AND (created <= %@)", monthInterval.start, monthInterval.end)
                    if monthValues.count != 0 {
                        var total = 0.0
                        for v in monthValues {
                            total += v.value
                        }
                        let barEntry = BarChartDataEntry(x: barIndex, y:  total, data: monthInterval.start as AnyObject)
                        data.append(barEntry)
                        barIndex += 1
                    }
                    
                    var components = DateComponents()
                    components.month = 1
                    
                    let newRunDate = Calendar.current.date(byAdding: components, to: runDate)!
                    runDate = newRunDate
                }
            }
            
            opt?[.yLineNumber] = data.count
            return {
                let node = AnalyticsHorizontalBarChartNode(title: Localizations.Analytics.Chart.HorizontalBar.Goal.totalTitle, data: data, options: opt)
                node.format = "%.1f"
                node.chartStringForValue = { (_, value, _) in
                    if Int(value) >= data.count {
                        return "WTF"
                    }
                    let entry = data[Int(value)]
                    if let date = entry.data as? Date {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMM YYYY"
                        return dateFormatter.string(from: date)
                    }
                    return ""
                }
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                return node
            }
        case .barChart:
            var data = [BarChartDataEntry]()
            let counterCard = self.card.data as! CounterCard
            let sortedValues = counterCard.values.sorted(byKeyPath: "created")
            for (i, v) in sortedValues.enumerated() {
                //let chartDataEntry = ChartDataEntry(x: Double(v.created.start.timeIntervalSince1970), y: Double(v.value))
                let chartDataEntry = BarChartDataEntry(x: Double(i), y: Double(v.value), data: v.created.start as AnyObject)
                data.append(chartDataEntry)
            }
            
            var opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            opt?[.yLineNumber] = 5
            
            return {
                let node = AnalyticsBarChartNode(title: Localizations.Analytics.Chart.Bar.Criterion.title, data: data, options: opt)
                node.chartStringForXValue = { (node, value, axis) in
                    let index = Int(value)
                    if index >= data.count {
                        return ""
                    }
                    
                    if let date = data[index].data as? Date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd MMM"
                        
                        return formatter.string(from: date)
                    }
                    
                    return ""
                }
                node.chartStringForYValue = { (node, value, axis) in
                    let index = Int(value)
                    return "\(index)"
                }
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
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
            let controller = UIStoryboard(name: Storyboards.numbersList.rawValue, bundle: nil).instantiateInitialViewController() as! NumbersListViewController
            controller.card = self.card
            controller.values = (self.card.data as! CounterCard).values.sorted(byKeyPath: "created", ascending: false)
            self.viewController?.navigationController?.pushViewController(controller, animated: true)
        }
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
        
        var csvText = "Title,Subtitle,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Value,'Start Value',Step\n"
        
        let counterCard = self.card.data as! CounterCard
        let sortedValues = counterCard.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title),\(self.card.subtitle),\(date),\(c.created.timeIntervalSince1970),\(edited),\(c.edited.timeIntervalSince1970),\(c.value), \(counterCard.startValue), \(counterCard.step)\n"
            
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
        
        var txtText = "Title,Subtitle,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Value, 'Start Value', Step\n"
        
        let counterCard = self.card.data as! CounterCard
        let sortedValues = counterCard.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title), \(self.card.subtitle), \(date), \(c.created.timeIntervalSince1970), \(edited), \(c.edited.timeIntervalSince1970), \(c.value), \(counterCard.startValue), \(counterCard.step)\n"
            
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
        
        let counterCard = self.card.data as! CounterCard
        let sortedValues = counterCard.values.sorted(byKeyPath: "created")
        
        var json = JSON()
        json["title"].string = self.card.title
        json["subtitle"].string = self.card.subtitle
        json["created"].double = self.card.created.timeIntervalSince1970
        if self.card.archived {
            json["archived"].double = self.card.archivedDate?.timeIntervalSince1970
        }
        json["step"].double = counterCard.step
        json["start"].double = counterCard.startValue
        
        for (i, c) in sortedValues.enumerated() {
            var valueJSON = JSON()
            valueJSON["created"].double = c.created.timeIntervalSince1970
            valueJSON["edited"].double = c.edited.timeIntervalSince1970
            valueJSON["value"].double = c.value
            
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
        shareContrroller.canonicalIdentifier = "cunterShare"
        shareContrroller.channel = "Analytics"
        shareContrroller.shareHandler = { () in
            sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
        }
        
        self.viewController?.present(shareContrroller, animated: true, completion: nil)
    }
}
