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

class DashboardsSection: ListSectionController, ASSectionController, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - Variables
    var dashboards: Results<Dashboard>!
    
    override init() {
        self.dashboards = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", false)
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 1
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        return {
            let node = DashboardsNode()
            node.collectionDidLoad = { () in
                node.collectionView.dataSource = self
                node.collectionView.delegate = self
            }
            return node
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
            if let image = UIImage(named: dashboard.image) {
                cell.imageView.image = image
            } else {
                cell.imageView.image = #imageLiteral(resourceName: "dashboard-0")
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newDashboard", for: indexPath)
        return cell
    }
}
