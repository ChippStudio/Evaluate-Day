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
                let node = TitleNode(title: title, subtitle: subtitle, image: image, dashboard: nil, style: style)
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
        guard let controller = self.viewController as? ActivityViewController else {
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
        shareContrroller.canonicalIdentifier = "activityShare"
        shareContrroller.channel = "Activity"
        
        self.viewController?.present(shareContrroller, animated: true, completion: nil)
    }
}
