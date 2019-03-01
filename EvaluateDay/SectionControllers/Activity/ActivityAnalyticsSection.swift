//
//  ActivityAnalyticsSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 19/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Charts
import Branch
import RealmSwift

private enum NodeType {
    case bar
    case stat
    case line
    case startsSum
}

class ActivityAnalyticsSection: ListSectionController, ASSectionController {
    
    // MARK: - Variables
    private var nodes = [NodeType]()
    var barChartData: (UIImage, String, String)?
    private var data: [(title: String, data: String)]?
    
    private var isPro: Bool!
    private var realmToken: NotificationToken!
    
    // MARK: - Init
    override init() {
        super.init()
        self.isPro = Store.current.isPro
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadeAnalytics(sender:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        if let user = Database.manager.app.objects(User.self).first {
            self.realmToken = user.observe({ (_) in
                if self.isPro != Store.current.isPro {
                    self.isPro = Store.current.isPro
                    self.collectionContext?.performBatch(animated: true, updates: { (context) in
                        print("RELOAD FROM ANALYTICS")
                        context.reload(self)
                    }, completion: nil)
                }
            })
        }
        
        self.nodes.append(.stat)
        if Store.current.isPro {
            self.nodes.append(.line)
            self.nodes.append(.startsSum)
        }
        self.nodes.append(.bar)
    }
    // MARK: - Override
    override func numberOfItems() -> Int {
        return self.nodes.count
    }
    
    func nodeForItem(at index: Int) -> ASCellNode {
        return ASCellNode()
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let item = self.nodes[index]
        var distance = Localizations.Activity.Analytics.Barchart.title + "\n\(Localizations.General.last7)"
        if isPro {
            distance = Localizations.Activity.Analytics.Barchart.title
        }
        switch item {
        case .bar:
            var maxCount: Int = 7
            if isPro {
                maxCount = Database.manager.application.firstStartDate.days(to: Date().end)
            }
            var data = [BarChartDataEntry]()
            var components = DateComponents()
            for i in 0...maxCount {
                components.day = -(maxCount - i)
                let currentDate = Calendar.current.date(byAdding: components, to: Date())!
                let stat = Database.manager.app.objects(AppUsage.self).filter("(date >= %@) AND (date <= %@)", currentDate.start, currentDate.end)
                let newdata = BarChartDataEntry(x: Double(i), y: Double(stat.count), data: currentDate.start as AnyObject)
                data.append(newdata)
            }
            var opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            opt?[.yLineNumber] = 5
            opt?[.positive] = true
            return {
                let node = AnalyticsBarChartNode(title: distance, data: data, options: opt)
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
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                return node
            }
        case .startsSum:
            var data = [BarChartDataEntry]()
            var opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            let firstStart = Database.manager.application.firstStartDate
            var runDate = firstStart
            var barIndex: Double = 0.0
            let currentMonthEnd = Calendar.current.dateInterval(of: .month, for: Date())!.end
            while currentMonthEnd.timeIntervalSince1970 > runDate.timeIntervalSince1970 {
                let monthInterval = Calendar.current.dateInterval(of: .month, for: runDate)!
                let monthValues = Database.manager.app.objects(AppUsage.self).filter("(date >= %@) AND (date <= %@)", monthInterval.start, monthInterval.end)
                if monthValues.count != 0 {
                    let total = monthValues.count
                    let barEntry = BarChartDataEntry(x: barIndex, y:  Double(total), data: monthInterval.start as AnyObject)
                    data.append(barEntry)
                    barIndex += 1
                }
                
                var components = DateComponents()
                components.month = 1
                
                let newRunDate = Calendar.current.date(byAdding: components, to: runDate)!
                runDate = newRunDate
            }
            
            opt?[.yLineNumber] = data.count
            return {
                let node = AnalyticsHorizontalBarChartNode(title: Localizations.Activity.Analytics.HorizontalBarchart.title, data: data, options: opt)
                node.format = "%.0f"
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
        case .line:
            var data = [ChartDataEntry]()
            var opt: [AnalyticsChartNodeOptionsKey: Any]? = [.uppercaseTitle: true]
            opt?[.yLineNumber] = 5
            
            let maxCount = Database.manager.application.firstStartDate.days(to: Date().end)
            var components = DateComponents()
            for i in 0...maxCount {
                components.day = -(maxCount - i)
                let currentDate = Calendar.current.date(byAdding: components, to: Date())!
                let stat = Database.manager.app.objects(AppUsage.self).filter("(date >= %@) AND (date <= %@)", currentDate.start, currentDate.end)
                let newData = ChartDataEntry(x: currentDate.timeIntervalSince1970, y: Double(stat.count), data: currentDate as AnyObject)
                data.append(newData)
            }
            return {
                let node = AnalyticsLineChartNode(title: Localizations.Activity.Analytics.Linechart.title, data: data, options: opt)
                node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                OperationQueue.main.addOperation {
                    node.shareButton.view.tag = index
                }
                return node
            }
        case .stat:
            self.data = [(title: String, data: String)]()
            
            let cards = Database.manager.data.objects(Card.self).filter("isDeleted=%@", false)
            let archived = cards.filter("archived=%@", true)
            let days: Int = Database.manager.application.firstStartDate.days(to: Date().end)
            let firstStart = DateFormatter.localizedString(from: Database.manager.application.firstStartDate, dateStyle: .medium, timeStyle: .none)
            let updateDate = DateFormatter.localizedString(from: Database.manager.application.lastUpdateDate, dateStyle: .medium, timeStyle: .none)
            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
            let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
            let fullVersion = "\(build) (\(version))"
            let totalStarts = Database.manager.app.objects(AppUsage.self).count
            
            self.data!.append((title: Localizations.Activity.Analytics.Stat.cards, data: "\(cards.count)"))
            self.data!.append((title: Localizations.Activity.Analytics.Stat.archived, data: "\(archived.count)"))
            self.data!.append((title: Localizations.Activity.Analytics.Stat.version, data: "\(fullVersion)"))
            if isPro {
                self.data!.append((title: Localizations.Activity.Analytics.Stat.alldays, data: "\(days)"))
                self.data!.append((title: Localizations.Activity.Analytics.Stat.firsStartDate, data: "\(firstStart)"))
                self.data!.append((title: Localizations.Activity.Analytics.Stat.updateDate, data: "\(updateDate)"))
                self.data!.append((title: Localizations.Activity.Analytics.Stat.totalStarts, data: "\(totalStarts)"))
            } else {
                self.data!.append((title: Localizations.Activity.Analytics.Stat.alldays, data: proPlaceholder))
                self.data!.append((title: Localizations.Activity.Analytics.Stat.firsStartDate, data: proPlaceholder))
                self.data!.append((title: Localizations.Activity.Analytics.Stat.updateDate, data: proPlaceholder))
                self.data!.append((title: Localizations.Activity.Analytics.Stat.totalStarts, data: proPlaceholder))
            }
            
            return {
                let node = AnalyticsStatisticNode(data: self.data!)
                // node.leftOffset = 10.0
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
    @objc func reloadeAnalytics(sender: Notification) {
        collectionContext?.performBatch(animated: false, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    
    @objc private func shareAction(sender: ASButtonNode) {
        guard let controller = self.viewController as? ActivityViewController else {
            return
        }
        
        let node = controller.collectionNode.nodeForItem(at: IndexPath(row: sender.view.tag, section: self.section))!
        
        let nodeImageViews = [UIImageView(image: node.view.snapshot)]
        
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
        shareContrroller.canonicalIdentifier = "activityShare"
        shareContrroller.channel = "Activity"
        
        self.viewController?.present(shareContrroller, animated: true, completion: nil)
    }
}
