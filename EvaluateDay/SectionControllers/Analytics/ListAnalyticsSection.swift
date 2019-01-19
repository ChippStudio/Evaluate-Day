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
    
    private var nodes = [AnalyticsNodeType]()
    private var data: [(title: String, data: String)]?
    private var groupedData = [(date: Date, count: Int)]()
    
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
        
        self.groupValues()
        
        self.nodes.append(.title)
        self.nodes.append(.information)
        self.nodes.append(.barChart)
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
            self.groupValues()
            let listCard = self.card.data as! ListCard
            let allDone = listCard.values.filter("done=%@", true).count
            let allPercent = Double(allDone) / Double(listCard.values.count) * 100.0
            
            self.data = [(title: String, data: String)]()

            self.data!.append((title: Localizations.General.createDate + ":", data: DateFormatter.localizedString(from: self.card.created, dateStyle: .medium, timeStyle: .none)))
            
            if isPro {
                self.data!.append((title: Localizations.Analytics.List.items + ":", data: "\(listCard.values.count)"))
                self.data!.append((title: Localizations.Analytics.List.itemsDone + ":", data: "\(allDone)"))
                self.data!.append((title: Localizations.Analytics.List.percent + ":", data: String(format: "%.0f", allPercent) + " %"))
                self.data!.append((title: Localizations.Analytics.Statistics.days + ":", data: "\(self.groupedData.count)"))

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
                    self.data!.append((title: Localizations.Analytics.Statistics.maximum + ":", data: "\(maximum)"))
                    self.data!.append((title: Localizations.Analytics.Statistics.minimum + ":", data: "\(minimum)"))
                    self.data!.append((title: Localizations.Analytics.Statistics.average + ":", data: "\(Float(sum)/Float(self.groupedData.count))"))
                }
            } else {
                self.data!.append((title: Localizations.Analytics.List.items + ":", data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.List.itemsDone + ":", data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.List.percent + ":", data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.days + ":", data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.maximum + ":", data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.minimum + ":", data: proPlaceholder))
                self.data!.append((title: Localizations.Analytics.Statistics.average + ":", data: proPlaceholder))
            }

            return {
                let node = AnalyticsStatisticNode(data: self.data!)
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
                let node = AnalyticsBarChartNode(title: Localizations.Analytics.Chart.Bar.Criterion.title, data: data, options: opt)
                node.chartStringForValue = { (node, value, axis) in
                    return ""
                }
                node.topOffset = 20.0
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
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
        shareContrroller.canonicalIdentifier = "listShare"
        shareContrroller.channel = "Analytics"
        shareContrroller.shareHandler = { () in
            sendEvent(.shareFromEvaluateDay, withProperties: ["type": self.card.type.string])
        }
        
        self.viewController?.present(shareContrroller, animated: true, completion: nil)
    }
}
