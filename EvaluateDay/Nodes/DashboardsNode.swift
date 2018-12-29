//
//  DashboardsNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol DashboardsNodeStyle {
    var dashboardsNodeTitleFont: UIFont { get }
    var dashboardsNodeTitleColor: UIColor { get }
    var dashboardsNodeNewColor: UIColor { get }
    var dashboardsNodeNewBorderColor: UIColor { get }
    var dashboardsNodeCountColor: UIColor { get }
    var dashboardsNodeCountTextColor: UIColor { get }
    var dashboardsNodeCountTextFont: UIFont { get }
}

class DashboardsNode: ASCellNode {
    // MARK: - UI
    var collectionNode: ASDisplayNode!
    var collectionView: UICollectionView!
    
    var accessibilityNode = ASDisplayNode()
    
    // MARK: - Variables
    var collectionDidLoad: (() -> Void)?
    var cellHeight: CGFloat = 95.0
    
    // MARK: - Init
    init(cellSize: CGSize = CGSize(width: 70.0, height: 95.0)) {
        super.init()
        
        self.collectionNode = ASDisplayNode(viewBlock: { () -> UIView in
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 20.0
            layout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
            layout.itemSize = cellSize
            
            self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            self.collectionView.backgroundColor = UIColor.clear
            self.collectionView.alwaysBounceHorizontal = true
            self.collectionView.showsHorizontalScrollIndicator = false
            self.collectionView.showsVerticalScrollIndicator = false
            self.collectionView.register(DashboardCell.classForCoder(), forCellWithReuseIdentifier: "dashboard")
            self.collectionView.register(DashboardNewCell.classForCoder(), forCellWithReuseIdentifier: "newDashboard")
            self.collectionView.register(DashboardIconCell.classForCoder(), forCellWithReuseIdentifier: "dashboardIcon")
            
            return self.collectionView
        }, didLoad: { (_) in
            self.collectionDidLoad?()
        })
        
        // Accessibility
        self.accessibilityNode.isAccessibilityElement = true
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.collectionNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: cellHeight)
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: self.collectionNode)
        
        let cell = ASBackgroundLayoutSpec(child: cellInset, background: self.accessibilityNode)
        return cell
    }
}

class DashboardCell: UICollectionViewCell {
    // MARK: - UI
    var titleLabel = UILabel()
    var imageView = UIImageView()
    var countCover = UIView()
    var countLabel = UILabel()
    
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
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 35.0
        self.imageView.contentMode = .scaleAspectFill
        
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(self.imageView.snp.width)
        }
        
        let style = Themes.manager.evaluateStyle
        
        self.titleLabel.textColor = style.dashboardsNodeTitleColor
        self.titleLabel.font = style.dashboardsNodeTitleFont
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 1
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        self.countCover.backgroundColor = style.dashboardsNodeCountColor
        self.countCover.layer.masksToBounds = true
        self.countCover.layer.cornerRadius = 10.0
        self.contentView.addSubview(self.countCover)
        self.countCover.snp.makeConstraints { (make) in
            make.height.equalTo(20.0)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.imageView.snp.bottom)
            make.width.greaterThanOrEqualTo(self.countCover.snp.height)
        }
        
        self.countLabel.textColor = style.dashboardsNodeCountTextColor
        self.countLabel.font = style.dashboardsNodeCountTextFont
        self.countLabel.textAlignment = .center
        self.countCover.addSubview(self.countLabel)
        self.countLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        self.isAccessibilityElement = true
    }
}

class DashboardNewCell: UICollectionViewCell {
    // MARK: - UI
    var circle = UIView()
    var addNew = UIImageView()
    
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
        
        let style = Themes.manager.evaluateStyle
        
        self.circle.backgroundColor = UIColor.clear
        self.circle.layer.borderColor = style.dashboardsNodeNewBorderColor.cgColor
        self.circle.layer.borderWidth = 2.0
        self.circle.layer.cornerRadius = 35.0
        
        self.contentView.addSubview(self.circle)
        self.circle.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(self.circle.snp.width)
        }
        
        self.addNew.image = #imageLiteral(resourceName: "new").withRenderingMode(.alwaysTemplate)
        self.addNew.tintColor = style.dashboardsNodeNewColor
        self.circle.addSubview(self.addNew)
        self.addNew.snp.makeConstraints { (make) in
            make.width.equalTo(30.0)
            make.height.equalTo(30.0)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.isAccessibilityElement = true
    }
}

class DashboardIconCell: UICollectionViewCell {
    // MARK: - UI
    var imageView: UIImageView = UIImageView()
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
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 35.0
        self.imageView.contentMode = .scaleAspectFill
        
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.height.equalTo(70.0)
            make.width.equalTo(70.0)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
