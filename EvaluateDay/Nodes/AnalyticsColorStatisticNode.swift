//
//  AnalyticsColorStatisticNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AnalyticsColorStatisticNode: ASCellNode, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - UI
    var stats: ASDisplayNode!
    var emptyImageNode: ASImageNode!
    
    // MARK: - Variables
    var collectionView: UICollectionView!
    var data = [(color: String, data: String)]()
    
    // MARK: - Init
    init(data: [(color: String, data: String)]) {
        super.init()
        
        self.data = data
        
        if data.isEmpty {
            self.emptyImageNode = ASImageNode()
            self.emptyImageNode.contentMode = .center
            self.emptyImageNode.image = UIImage(named: "empty\(3.random)")?.resizedImage(newSize: CGSize(width: 60.0, height: 60.0))
            self.emptyImageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        }
        
        self.stats = ASDisplayNode(viewBlock: { () -> UIView in
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 90.0, height: 60.0)
            layout.minimumInteritemSpacing = 10.0
            layout.minimumLineSpacing = 10.0
            layout.scrollDirection = .horizontal
            
            self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.backgroundColor = UIColor.clear
            self.collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
            self.collectionView.showsVerticalScrollIndicator = false
            self.collectionView.showsHorizontalScrollIndicator = false
            
            self.collectionView.register(StatisticColorCollectionCell.classForCoder(), forCellWithReuseIdentifier: "stat")
            
            return self.collectionView
        })
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.stats.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 60.0)
        
        let cell = ASStackLayoutSpec.vertical()
        if self.emptyImageNode != nil {
            self.emptyImageNode.style.preferredSize.height = 60
            cell.children = [self.emptyImageNode]
        } else {
            cell.children = [self.stats]
        }
        
        let cellInsets = UIEdgeInsets(top: 40.0, left: 0.0, bottom: 20.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stat", for: indexPath) as! StatisticColorCollectionCell
        let stat = self.data[indexPath.row]
        cell.dataLabel.text = stat.data
        cell.color = stat.color
        
        cell.isAccessibilityElement = true
        for c in colorsForSelection {
            if c.color == stat.color {
                cell.accessibilityLabel = Localizations.Accessibility.Analytics.color(c.name, stat.data)
            }
        }
        return cell
    }
}

class StatisticColorCollectionCell: UICollectionViewCell {
    // MARK: - UI
    var dataLabel: UILabel!
    
    // MARK: - Variables
    var color: String! {
        didSet {
            if color == "FFFFFF" {
                self.dataLabel.textColor = UIColor.main
                self.contentView.layer.borderColor = UIColor.main.cgColor
                self.contentView.layer.borderWidth = 0.2
            } else {
                self.dataLabel.textColor = UIColor.white
                self.contentView.layer.borderWidth = 0.0
            }
            
            self.contentView.backgroundColor = color.color
        }
    }
    
    // MARK: - Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSubviews()
    }
    
    // MARK: - Init subviews
    fileprivate func initSubviews() {
        // Custom initialization
        for v in self.contentView.subviews {
            v.removeFromSuperview()
        }
        
        self.contentView.backgroundColor = UIColor.background
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 8.0
        
        self.dataLabel = UILabel()
        self.dataLabel.numberOfLines = 2
        self.dataLabel.font = UIFont.systemFont(ofSize: 30.0, weight: .bold)
        self.dataLabel.textColor = UIColor.white
        self.dataLabel.adjustsFontSizeToFitWidth = true
        self.dataLabel.textAlignment = .center
        
        self.contentView.addSubview(self.dataLabel)
        
        self.dataLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30.0)
            make.leading.equalToSuperview().offset(30.0)
        }
    }
}
