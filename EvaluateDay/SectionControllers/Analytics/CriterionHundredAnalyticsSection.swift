//
//  CriterionHundredAnalyticsSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 09/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
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
}

class CriterionHundredAnalyticsSection: ListSectionController, ASSectionController, AnalyticalSection {
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
        if Store.current.isPro {
            self.nodes.append(.lineChart)
        }
        self.nodes.append(.barChart)
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
                if !isPro {
                    node.shareButton.alpha = 0.0
                } else {
                    node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                }
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                return node
            }
        case .information:
            let criterion = self.card.data as! CriterionHundredCard
            self.data = [(title: String, data: String)]()
            self.data!.append((title: Localizations.general.createDate + ":", data: DateFormatter.localizedString(from: self.card.created, dateStyle: .medium, timeStyle: .none)))
            self.data!.append((title: Localizations.analytics.statistics.days + ":", data: "\(criterion.values.count)"))
            
            var minimum: Double = 100
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
            
            self.data!.append((title: Localizations.analytics.statistics.maximum + ":", data: String(format: "%.0f", maximum)))
            self.data!.append((title: Localizations.analytics.statistics.minimum + ":", data: String(format: "%.0f", minimum)))
            self.data!.append((title: Localizations.analytics.statistics.average + ":", data: String(format: "%.0f", sum/Double(criterion.values.count))))
            
            return {
                let node = AnalyticsStatisticNode(title: Localizations.analytics.statistics.title, data: self.data!, style: style)
                node.topInset = 20.0
                return node
            }
            
        case .lineChart:
            var data = [ChartDataEntry]()
            let criterionCard = self.card.data as! CriterionHundredCard
            let sortedValues = criterionCard.values.sorted(byKeyPath: "created")
            for v in sortedValues {
                let chartDataEntry = ChartDataEntry(x: Double(v.created.start.timeIntervalSince1970), y: Double(v.value), data: v.created.start as AnyObject)
                data.append(chartDataEntry)
            }
            
            var opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            opt?[.yLineNumber] = 5
            opt?[.positive] = criterionCard.positive
            
            return {
                let node = AnalyticsLineChartNode(title: Localizations.analytics.chart.line.criterion.title, data: data, options: opt, style: style)
                node.topOffset = 50.0
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                return node
            }
            
        case .barChart:
            var data = [BarChartDataEntry]()
            let criterionCard = self.card.data as! CriterionHundredCard
            let sortedValues = criterionCard.values.sorted(byKeyPath: "created")
            for (i, v) in sortedValues.enumerated() {
                //let chartDataEntry = ChartDataEntry(x: Double(v.created.start.timeIntervalSince1970), y: Double(v.value))
                let chartDataEntry = BarChartDataEntry(x: Double(i), y: Double(v.value), data: v.created.start as AnyObject)
                data.append(chartDataEntry)
            }
            
            var opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            opt?[.yLineNumber] = 5
            opt?[.positive] = criterionCard.positive
            
            return {
                let node = AnalyticsBarChartNode(title: Localizations.analytics.chart.bar.criterion.title, data: data, options: opt, style: style)
                node.chartStringForValue = { (node, value, axis) in
                    return ""
                }
                node.topOffset = 50.0
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
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
        
        var csvText = "Title,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Value\n"
        
        let criterionCard = self.card.data as! CriterionHundredCard
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
        
        let criterionCard = self.card.data as! CriterionHundredCard
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
        
        let criterionCard = self.card.data as! CriterionHundredCard
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
        // FIXME: - Need share sction
        print("Share action not implemented")
    }
}
