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
    case title
    case stat
}

class ActivityAnalyticsSection: ListSectionController, ASSectionController {
    
    // MARK: - Variables
    private var nodes = [NodeType]()
    var barChartData: (UIImage, String, String)?
    private var data: [(title: String, data: String)]?
    
    private var isPro: Bool!
    private var realmToken: NotificationToken!
    
    // MARK: - Actions
    var shareHandler: ((IndexPath, [Any]) -> Void)?
    
    // MARK: - Init
    override init() {
        super.init()
        self.isPro = Store.current.isPro
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadeAnalytics(sender:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
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
        
        self.nodes.append(.bar)
        self.nodes.append(.title)
        self.nodes.append(.stat)
    }
    // MARK: - Override
    override func numberOfItems() -> Int {
        return self.nodes.count
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let item = self.nodes[index]
        let style = Themes.manager.activityControlerStyle
        var distance = Localizations.general.last7
        if isPro {
            distance = Localizations.general.lifetime
        }
        switch item {
        case .title:
            let title = Localizations.activity.analytics.stat.title
            let subtitle = Localizations.activity.analytics.stat.subtitle
            let image = Sources.image(forType: .evaluate)
            return {
                let node = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
                node.topInset = 10.0
                if self.isPro {
                    node.shareButton.addTarget(self, action: #selector(self.shareAction(sender:)), forControlEvents: .touchUpInside)
                    OperationQueue.main.addOperation {
                        node.shareButton.view.tag = index
                    }
                } else {
                    node.shareButton.alpha = 0.0
                }
                return node
            }
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
                let node = AnalyticsBarChartNode(title: Localizations.activity.analytics.barchart.title + "\n(\(distance))", data: data, options: opt, style: style)
                //node.leftOffset = 0.0
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
        case .stat:
            self.data = [(title: String, data: String)]()
            
            let cards = Database.manager.data.objects(Card.self).filter("isDeleted=%@", false)
            let archived = cards.filter("archived=%@", true)
            let days: Int = Database.manager.application.firstStartDate.days(to: Date().end)
            let firstStart = DateFormatter.localizedString(from: Database.manager.application.firstStartDate, dateStyle: .medium, timeStyle: .medium)
            let updateDate = DateFormatter.localizedString(from: Database.manager.application.lastUpdateDate, dateStyle: .medium, timeStyle: .medium)
            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
            let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
            let fullVersion = "\(build) (\(version))"
            let totalStarts = Database.manager.app.objects(AppUsage.self).count
            
            self.data!.append((title: Localizations.activity.analytics.stat.cards, data: "\(cards.count)"))
            self.data!.append((title: Localizations.activity.analytics.stat.archived, data: "\(archived.count)"))
            if isPro {
                self.data!.append((title: Localizations.activity.analytics.stat.alldays, data: "\(days)"))
                self.data!.append((title: Localizations.activity.analytics.stat.firsStartDate, data: "\(firstStart)"))
                self.data!.append((title: Localizations.activity.analytics.stat.updateDate, data: "\(updateDate)"))
                self.data!.append((title: Localizations.activity.analytics.stat.totalStarts, data: "\(totalStarts)"))
            }
            self.data!.append((title: Localizations.activity.analytics.stat.version, data: "\(fullVersion)"))
            
            return {
                let node = AnalyticsStatisticNode(title: Localizations.activity.analytics.stat.description, data: self.data!, style: style)
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
    @objc func reloadeAnalytics(sender: Notification) {
        collectionContext?.performBatch(animated: false, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    
    @objc private func shareAction(sender: ASButtonNode) {
        let style = Themes.manager.analyticalStyle
        let indexPath = IndexPath(row: sender.view.tag, section: self.section)
        var inView = UIView()
        if self.barChartData != nil {
            inView = AnalyticsBarChartShareView(image: self.barChartData!.0, xValue: self.barChartData!.1, yValue: self.barChartData!.2, positive: true, title: Localizations.activity.analytics.barchart.title, subtitle: "", type: .evaluate)
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

                inView = AnalyticsStackShareView(stack: stack, text: "", title: Localizations.activity.analytics.stat.title, subtitle: Localizations.activity.analytics.stat.subtitle, type: .evaluate)
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
        let linkObject = BranchUniversalObject(canonicalIdentifier: "activity")
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
