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
}

class DashboardsSection: ListSectionController, ASSectionController, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - Variables
    var dashboards: Results<Dashboard>!
    var selectDashboard: ((_ dashboard: String) -> Void)?
    
    private var nodes = [DashboardsSectionNodeType]()
    
    init(isCardSettings: Bool) {
        self.dashboards = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", false)
        
        if isCardSettings {
            self.nodes.append(.sectionTitle)
            self.nodes.append(.separator)
            self.nodes.append(.dashboards)
            self.nodes.append(.separator)
        } else {
            self.nodes.append(.dashboards)
        }
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
            return {
                let node = DashboardsNode()
                node.collectionDidLoad = { () in
                    node.collectionView.dataSource = self
                    node.collectionView.delegate = self
                }
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
            if let controller = self.viewController as? EvaluateViewController {
                if controller.selectedDashboard != nil {
                    if controller.selectedDashboard! != dashboard.id {
                        cell.imageView.image = dashboardImage.noir
                    }
                }
            } else if let controller = self.viewController as? CardSettingsViewController {
                if controller.card.dashboard != nil {
                    if controller.card.dashboard! != dashboard.id {
                        cell.imageView.image = dashboardImage.noir
                    }
                }
            }
            let cards = Database.manager.data.objects(Card.self).filter("dashboard=%@ AND isDeleted=%@", dashboard.id, false)
            cell.countLabel.text = "\(cards.count)"
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newDashboard", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.selectDashboard?(self.dashboards[indexPath.row].id)
            collectionView.reloadData()
        }
    }
}
