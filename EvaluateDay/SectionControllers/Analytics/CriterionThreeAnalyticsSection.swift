//
//  CriterionThreeAnalyticsSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 17/01/2018.
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
    case horizontalBarChart
    case export
    case proReview
    case more
}

class CriterionThreeAnalyticsSection: ListSectionController, ASSectionController, AnalyticalSection {
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
        if !Store.current.isPro {
            self.nodes.append(.proReview)
        }
        self.nodes.append(.lineChart)
        if Store.current.isPro {
            self.nodes.append(.horizontalBarChart)
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
            let criterion = self.card.data as! CriterionThreeCard
            self.data = [(title: String, data: String)]()
            self.data!.append((title: Localizations.General.createDate, data: DateFormatter.localizedString(from: self.card.created, dateStyle: .medium, timeStyle: .none)))
            if card.archived {
                self.data!.append((title: Localizations.Activity.Analytics.Stat.archived, data: DateFormatter.localizedString(from: self.card.archivedDate!, dateStyle: .medium, timeStyle: .none)))
            }
            self.data!.append((title: Localizations.Analytics.Statistics.days, data: "\(criterion.values.count)"))
            
            if isPro {
                var minimum: Double = 3
                var maximum: Double = 0
                var sum: Double = 0
                for v in criterion.values {
                    if v.value > maximum {
                        maximum = v.value
                    }
                    if v.value < minimum {
                        minimum = v.value
                    }
                    
                    sum += v.value
                }
        
                self.data!.append((title: Localizations.Analytics.Statistics.maximum, data: self.emogi(forValue: maximum)))
                self.data!.append((title: Localizations.Analytics.Statistics.minimum, data: self.emogi(forValue: minimum)))
                self.data!.append((title: Localizations.Analytics.Statistics.average, data: self.emogi(forValue: (sum/Double(criterion.values.count).rounded()))))
            } else {
                self.data!.append((title: Localizations.Analytics.Statistics.maximum, data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.minimum, data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.average, data: proPlaceholder))
            }
            
            return {
                let node = AnalyticsStatisticNode(data: self.data!)
                return node
            }
        case .lineChart:
            var data = [ChartDataEntry]()
            let criterionCard = self.card.data as! CriterionThreeCard
            let sortedValues = criterionCard.values.sorted(byKeyPath: "created")
            for v in sortedValues {
                let chartDataEntry = ChartDataEntry(x: Double(v.created.start.timeIntervalSince1970), y: Double(v.value), data: v.created.start as AnyObject)
                data.append(chartDataEntry)
            }
            
            var opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            opt?[.yLineNumber] = 3
            opt?[.positive] = criterionCard.positive
            
            return {
                let node = AnalyticsLineChartNode(title: Localizations.Analytics.Chart.Line.Criterion.title, data: data, options: opt)
                node.chartStringForYValue = { (_, value, _) in
                    return self.emogi(forValue: value)
                }
                node.chartYValueSelected = { (_, value, _) in
                    return self.emogi(forValue: value)
                }
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                return node
            }
            
        case .barChart:
            var data = [BarChartDataEntry]()
            let criterionCard = self.card.data as! CriterionThreeCard
            let sortedValues = criterionCard.values.sorted(byKeyPath: "created")
            for (i, v) in sortedValues.enumerated() {
                //let chartDataEntry = ChartDataEntry(x: Double(v.created.start.timeIntervalSince1970), y: Double(v.value))
                let chartDataEntry = BarChartDataEntry(x: Double(i), y: Double(v.value), data: v.created.start as AnyObject)
                data.append(chartDataEntry)
            }
            
            var opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            opt?[.yLineNumber] = 3
            opt?[.positive] = criterionCard.positive
            
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
                    return self.emogi(forValue: value)
                }
                node.chartYValueSelected = { (_, value, _) in
                    return self.emogi(forValue: value)
                }
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                return node
            }
        case .horizontalBarChart:
            var data = [BarChartDataEntry]()
            let criterionCard = self.card.data as! CriterionThreeCard
            
            let bad = criterionCard.values.filter("value=%@", 0)
            let badChart = BarChartDataEntry(x: 0, y: Double(bad.count))
            
            let neutral = criterionCard.values.filter("value=%@", 1)
            let neutralChart = BarChartDataEntry(x: 1, y: Double(neutral.count))
            
            let good = criterionCard.values.filter("value=%@", 2)
            let goodChart = BarChartDataEntry(x: 2, y: Double(good.count))
            
            data.append(badChart)
            data.append(neutralChart)
            data.append(goodChart)
            
            var opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            opt?[.yLineNumber] = data.count
            opt?[.positive] = criterionCard.positive
            
            return {
                let node = AnalyticsHorizontalBarChartNode(title: Localizations.Analytics.Chart.HorizontalBar.Criterion.title, data: data, options: opt)
                node.chartDidLoad = { () in
                    node.chart.xAxis.labelFont = UIFont.systemFont(ofSize: 16.0, weight: .regular)
                }
                node.chartStringForValue = { (node, value, axis) in
                    return self.emogi(forValue: value)
                }
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
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
            let controller = UIStoryboard(name: Storyboards.numbersList.rawValue, bundle: nil).instantiateInitialViewController() as! NumbersListViewController
            controller.card = self.card
            controller.values = (self.card.data as! CriterionThreeCard).values.sorted(byKeyPath: "created", ascending: false)
            self.viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - Actions
    @objc private func proReviewAction(sender: UIButton) {
        if let nav = self.viewController?.navigationController {
            let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
            nav.pushViewController(controller, animated: true)
        }
    }
    private func emogi(forValue value: Double) -> String {
        let index = Int(value)
        if index == 0 {
            return "🙁"
        } else if index == 1 {
            return "😐"
        } else if index == 2 {
            return "🙂"
        }
        
        return "\(value)"
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
        
        let criterionCard = self.card.data as! CriterionThreeCard
        let sortedValues = criterionCard.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title),\(date),\(c.created.timeIntervalSince1970),\(edited),\(c.edited.timeIntervalSince1970),\(c.value)\n"
            
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
        
        let criterionCard = self.card.data as! CriterionThreeCard
        let sortedValues = criterionCard.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title), \(date), \(c.created.timeIntervalSince1970), \(edited), \(c.edited.timeIntervalSince1970), \(c.value)\n"
            
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
        
        let criterionCard = self.card.data as! CriterionThreeCard
        let sortedValues = criterionCard.values.sorted(byKeyPath: "created")
        
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
        shareContrroller.canonicalIdentifier = "criterionThreeShare"
        shareContrroller.channel = "Analytics"
        shareContrroller.shareHandler = { () in
            sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
        }
        
        self.viewController?.present(shareContrroller, animated: true, completion: nil)
    }
}
