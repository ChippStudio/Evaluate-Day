//
//  ListAnalyticsSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/01/2018.
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
    case export
    case barChart
}

class ListAnalyticsSection: ListSectionController, ASSectionController, AnalyticalSection {
    // MARK: - Variable
    var card: Card!
    
    var lineChartData: (UIImage, String, String)?
    var barChartData: (UIImage, String, String)?
    
    private var nodes = [AnalyticsNodeType]()
    private var data: [(title: String, data: String)]?
    private var groupedData = [(date: Date, count: Int)]()
    
    // MARK: - Action
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
        
        self.groupValues()
        
        self.nodes.append(.title)
        if Store.current.isPro {
            self.nodes.append(.information)
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
            self.groupValues()
            let listCard = self.card.data as! ListCard
            let allDone = listCard.values.filter("done=%@", true).count
            let allPercent = Double(allDone) / Double(listCard.values.count) * 100.0
            
            self.data = [(title: String, data: String)]()

            self.data!.append((title: Localizations.general.createDate + ":", data: DateFormatter.localizedString(from: self.card.created, dateStyle: .medium, timeStyle: .none)))
            self.data!.append((title: Localizations.analytics.list.items + ":", data: "\(listCard.values.count)"))
            self.data!.append((title: Localizations.analytics.list.itemsDone + ":", data: "\(allDone)"))
            self.data!.append((title: Localizations.analytics.list.percent + ":", data: String(format: "%.0f", allPercent) + " %"))
            self.data!.append((title: Localizations.analytics.statistics.days + ":", data: "\(self.groupedData.count)"))

            var maximum = 0
            var minimum = 1000000000
            var sum = 0

            for i in self.groupedData {
                if i.count > maximum {
                    maximum = i.count
                }
                if i.count < minimum {
                    minimum = i.count
                }

                sum += i.count
            }

            if maximum != 0 && minimum != 1000000000 {
                self.data!.append((title: Localizations.analytics.statistics.maximum + ":", data: "\(maximum)"))
                self.data!.append((title: Localizations.analytics.statistics.minimum + ":", data: "\(minimum)"))
                self.data!.append((title: Localizations.analytics.statistics.average + ":", data: "\(Float(sum)/Float(self.groupedData.count))"))
            }

            return {
                let node = AnalyticsStatisticNode(title: Localizations.analytics.statistics.title, data: self.data!, style: style)
                node.topInset = 20.0
                return node
            }
        case .barChart:
            var data = [BarChartDataEntry]()
            for (i, v) in self.groupedData.enumerated() {
                let chartDataEntry = BarChartDataEntry(x: Double(i), y: Double(v.count), data: v.date.start as AnyObject)
                data.append(chartDataEntry)
            }

            var opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            opt?[.yLineNumber] = 5

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
                node.preShareAction = { (data) in
                    self.barChartData = data
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
        
        var csvText = "Title,Subtitle,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Text,Done,'Done Date'\n"
        
        let habitCard = self.card.data as! ListCard
        let sortedValues = habitCard.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            var doneDate = DateFormatter.localizedString(from: c.doneDate, dateStyle: .medium, timeStyle: .medium)
            if !c.done {
                doneDate = "Unset"
            }
            
            newLine = "\(self.card.title),\(self.card.subtitle),\(date),\(c.created.timeIntervalSince1970),\(edited),\(c.edited.timeIntervalSince1970),\(c.text),\(c.done),\(doneDate)\n"
            
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
        
        var txtText = "Title, Subtitle, Created, 'Created - Since 1970', Edited,'Edited - Since 1970', Text, Done, 'Done Date\n"
        
        let habitCard = self.card.data as! HabitCard
        let sortedValues = habitCard.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            var doneDate = DateFormatter.localizedString(from: c.doneDate, dateStyle: .medium, timeStyle: .medium)
            if !c.done {
                doneDate = "Unset"
            }
            
            newLine = "\(self.card.title), \(self.card.subtitle), \(date), \(c.created.timeIntervalSince1970), \(edited), \(c.edited.timeIntervalSince1970), \(c.text), \(c.done), \(doneDate) \n"
            
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
        
        let habitCard = self.card.data as! HabitCard
        let sortedValues = habitCard.values.sorted(byKeyPath: "created")
        
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
            valueJSON["done"].bool = c.done
            if c.done {
                valueJSON["doneDate"].double = c.doneDate.timeIntervalSince1970
            }
            
            json["\(i)"] = valueJSON
        }
        do {
            try json.rawData().write(to: path!, options: Data.WritingOptions.atomicWrite)
        } catch {
            return nil
        }
        
        return path
    }
    
    @objc private func groupValues() {
        self.groupedData.removeAll()
        let listCard = self.card.data as! ListCard
        let values = listCard.values.filter("done=%@ AND isDeleted=%@", true, false).sorted(byKeyPath: "doneDate", ascending: true)
        var currentDate: Date!
        if let value = values.first {
            currentDate = value.doneDate
        } else {
            return
        }
        
        var count = 0
        for (i, v) in values.enumerated() {
            if v.doneDate.days(to: currentDate) == 0 {
                count += 1
            } else {
                self.groupedData.append((date: currentDate, count: count))
                count = 1
                currentDate = v.doneDate
            }
            
            if i == values.count - 1 {
                self.groupedData.append((date: currentDate, count: count))
            }
        }
    }
    
    @objc private func shareAction(sender: ASButtonNode) {
        let style = Themes.manager.analyticalStyle
        let indexPath = IndexPath(row: sender.view.tag, section: self.section)
        var inView = UIView()
        if self.barChartData != nil {
            inView = AnalyticsBarChartShareView(image: self.barChartData!.0, xValue: self.barChartData!.1, yValue: self.barChartData!.2, positive: true, title: self.card.title, subtitle: self.card.subtitle, type: self.card.type)
            self.barChartData = nil
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
        let linkObject = BranchUniversalObject(canonicalIdentifier: "listShare")
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