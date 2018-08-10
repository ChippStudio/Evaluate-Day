//
//  AnalyticsStatisticNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol AnalyticsStatisticNodeStyle {
    var statisticTitleColor: UIColor { get }
    var statisticTitleFont: UIFont { get }
    var statisticSeparatorColor: UIColor { get }
    var statisticDataTitleColor: UIColor { get }
    var statisticDataTitleFont: UIFont { get }
    var statisticDataColor: UIColor { get }
    var statisticDataFont: UIFont { get }
    var statisticDataCellBackground: UIColor { get }
}

class AnalyticsStatisticNode: ASCellNode, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - UI
    var titleNode = ASTextNode()
    var stats: ASDisplayNode!
    
    // MARK: - Variables
    var collectionView: UICollectionView!
    var data = [(title: String, data: String)]()
    
    // MARK: - Init
    init(title: String, data: [(title: String, data: String)], style: AnalyticsStatisticNodeStyle) {
        super.init()
        
        self.data = data
        
        self.titleNode.attributedText = NSAttributedString(string: title.uppercased(), attributes: [NSAttributedStringKey.foregroundColor: style.statisticTitleColor, NSAttributedStringKey.font: style.statisticTitleFont])
        
        self.stats = ASDisplayNode(viewBlock: { () -> UIView in
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 150.0, height: 170.0)
            layout.minimumInteritemSpacing = 10.0
            layout.minimumLineSpacing = 20.0
            layout.scrollDirection = .horizontal
            
            self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.backgroundColor = UIColor.clear
            self.collectionView.showsVerticalScrollIndicator = false
            self.collectionView.showsHorizontalScrollIndicator = false
            
            self.collectionView.register(StatisticCollectionCell.classForCoder(), forCellWithReuseIdentifier: "stat")
            
            return self.collectionView
        })
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.stats.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 170.0)
        
        let titleInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        let titleInset = ASInsetLayoutSpec(insets: titleInsets, child: self.titleNode)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 20.0
        cell.children = [titleInset, self.stats]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 30.0, right: 0.0)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stat", for: indexPath) as! StatisticCollectionCell
        let stat = self.data[indexPath.row]
        cell.titleLabel.text = stat.title
        cell.dataLabel.text = stat.data
        return cell
    }
}

class StatisticCollectionCell: UICollectionViewCell {
    // MARK: - UI
    var titleLabel: UILabel!
    var dataLabel: UILabel!
    
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
        
        let style = Themes.manager.analyticalStyle
        
        self.contentView.backgroundColor = style.statisticDataCellBackground
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 8.0
        
        self.titleLabel = UILabel()
        self.titleLabel.numberOfLines = 2
        self.titleLabel.font = style.statisticDataTitleFont
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.textColor = style.statisticDataTitleColor
        self.titleLabel.textAlignment = .left
        
        self.dataLabel = UILabel()
        self.dataLabel.numberOfLines = 2
        self.dataLabel.font = style.statisticDataFont
        self.dataLabel.textColor = style.statisticDataColor
        self.dataLabel.adjustsFontSizeToFitWidth = true
        self.dataLabel.textAlignment = .center
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.dataLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.leading.equalToSuperview().offset(10.0)
        }
        
        self.dataLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20.0)
            make.trailing.equalToSuperview().offset(-30.0)
            make.leading.equalToSuperview().offset(30.0)
            make.bottom.equalToSuperview().offset(-20.0)
        }
    }
}
