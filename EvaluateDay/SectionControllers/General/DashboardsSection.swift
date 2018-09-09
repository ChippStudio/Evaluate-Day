//
//  DashboardsSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RealmSwift

private enum DashboardsSectionNodeType {
    case sectionTitle
    case dashboards
    case separator
    case none
}

class DashboardsSection: ListSectionController, ASSectionController, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - Variables
    var dashboards: Results<Dashboard>!
    var selectDashboard: ((_ dashboard: String) -> Void)?
    var collectionView: UICollectionView!
    
    private var nodes = [DashboardsSectionNodeType]()
    private var realmToken: NotificationToken!
    
    init(isCardSettings: Bool) {
        super.init()
        self.dashboards = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", false)
        
        if isCardSettings {
            self.nodes.append(.sectionTitle)
            self.nodes.append(.separator)
            if self.dashboards.count != 0 {
                self.nodes.append(.dashboards)
            } else {
                self.nodes.append(.none)
            }
            self.nodes.append(.separator)
        } else {
            if self.dashboards.count != 0 {
                self.nodes.append(.dashboards)
            } else {
                self.nodes.append(.none)
            }
        }
        
        self.realmToken = self.dashboards.observe({ (c) in
            switch c {
            case .initial(_):()
            case .update(_, deletions: _, insertions: _, modifications: _):
                if self.collectionView != nil {
                    self.collectionView.reloadData()
                }
            case .error(let error):
                print("ERROR - \(error.localizedDescription)")
            }
        })
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return self.nodes.count
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let style = Themes.manager.cardSettingsStyle
        switch self.nodes[index] {
        case .sectionTitle:
            return {
                let node = CardSettingsSectionTitleNode(title: Localizations.dashboard.title, style: style)
                return node
            }
        case .dashboards:
            
            let count = self.dashboards.count
            return {
                let node = DashboardsNode()
                node.collectionDidLoad = { () in
                    self.collectionView = node.collectionView
                    node.collectionView.dataSource = self
                    node.collectionView.delegate = self
                }
                node.accessibilityNode.accessibilityLabel = Localizations.accessibility.dashboard.dashboards(value1: "\(count)")
                return node
            }
        case .separator:
            return {
                let separator = SeparatorNode(style: style)
                if index != 1 && index != self.nodes.count - 1 {
                    separator.leftInset = 20.0
                }
                return separator
            }
        case .none:
            return {
                let node = DashboardsNoneNode(style: Themes.manager.evaluateStyle)
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
        if self.dashboards.count == 0 {
            if let nav = self.viewController?.parent as? UINavigationController {
                let controller = UIStoryboard(name: Storyboards.dashboards.rawValue, bundle: nil).instantiateInitialViewController() as! DashboardsViewController
                controller.dashboard = Dashboard()
                nav.pushViewController(controller, animated: true)
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.dashboards.count
        }
        
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboard", for: indexPath) as! DashboardCell
            let dashboard = self.dashboards[indexPath.row]
            cell.titleLabel.text = dashboard.title
            var dashboardImage: UIImage
            if let image = UIImage(named: dashboard.image) {
                dashboardImage = image
            } else {
                dashboardImage = #imageLiteral(resourceName: "dashboard-0")
            }
            cell.imageView.image = dashboardImage
            cell.accessibilityTraits = UIAccessibilityTraitButton
            if let controller = self.viewController as? EvaluateViewController {
                if controller.selectedDashboard != nil {
                    if controller.selectedDashboard! != dashboard.id {
                        cell.imageView.image = dashboardImage.noir
                    } else {
                        cell.accessibilityTraits |= UIAccessibilityTraitSelected
                    }
                }
            } else if let controller = self.viewController as? CardSettingsViewController {
                if controller.card.dashboard != nil {
                    if controller.card.dashboard! != dashboard.id {
                        cell.imageView.image = dashboardImage.noir
                    } else {
                        cell.accessibilityTraits |= UIAccessibilityTraitSelected
                    }
                }
            }
            let cards = Database.manager.data.objects(Card.self).filter("dashboard=%@ AND isDeleted=%@", dashboard.id, false)
            cell.countLabel.text = "\(cards.count)"
            
            cell.isAccessibilityElement = true
            cell.accessibilityLabel = Localizations.accessibility.dashboard.override(value1: dashboard.title, "\(cards.count)")
            cell.accessibilityTraits |= UIAccessibilityTraitButton
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newDashboard", for: indexPath)
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = Localizations.accessibility.dashboard.new
        cell.accessibilityTraits = UIAccessibilityTraitButton
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.selectDashboard?(self.dashboards[indexPath.row].id)
            collectionView.reloadData()
        }
        
        if indexPath.section == 1 {
            if let nav = self.viewController?.parent as? UINavigationController {
                let controller = UIStoryboard(name: Storyboards.dashboards.rawValue, bundle: nil).instantiateInitialViewController() as! DashboardsViewController
                controller.dashboard = Dashboard()
                nav.pushViewController(controller, animated: true)
            }
        }
    }
}
