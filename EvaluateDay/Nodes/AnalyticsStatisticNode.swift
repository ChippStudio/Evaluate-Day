//
//  AnalyticsStatisticNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AnalyticsStatisticNode: ASCellNode, ASCollectionDataSource {
    // MARK: - UI
    var collectionNode: ASCollectionNode!
    
    // MARK: - Variables
    var data = [(title: String, data: String)]()
    
    // MARK: - Init
    init(data: [(title: String, data: String)]) {
        super.init()
        
        self.data = data
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130.0, height: 60.0)
        layout.minimumLineSpacing = 10.0
        
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.collectionNode.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        self.collectionNode.alwaysBounceHorizontal = true
        self.collectionNode.dataSource = self
        self.collectionNode.backgroundColor = UIColor.background
        
        OperationQueue.main.addOperation {
            self.collectionNode.view.showsVerticalScrollIndicator = false
            self.collectionNode.view.showsHorizontalScrollIndicator = false
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.collectionNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 60.0)
        
        let cellInsets = UIEdgeInsets(top: 35.0, left: 0.0, bottom: 30.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: self.collectionNode)
        
        return cellInset
    }
    
    // MARK: - ASCollectionDataSource
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let item = self.data[indexPath.row]
        return {
            return StatisticCollectionCell(title: item.title, data: item.data)
        }
    }
}

class StatisticCollectionCell: ASCellNode {
    
    // MARK: - UI
    var titleNode = ASTextNode()
    var subtitleNode = ASTextNode()
    
    // MARK: - Init
    init(title: String, data: String) {
        super.init()
        
        self.backgroundColor = UIColor.main
        self.cornerRadius = 5.0
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        self.titleNode.attributedText = NSAttributedString(string: data, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.textTint, NSAttributedStringKey.paragraphStyle: paragraph])
        self.subtitleNode.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.textTint, NSAttributedStringKey.paragraphStyle: paragraph])
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = title
        self.accessibilityValue = data
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let texts = ASStackLayoutSpec.vertical()
        texts.justifyContent = .spaceBetween
        texts.children = [self.titleNode, self.subtitleNode]
        
        let textInsets = UIEdgeInsets(top: 5.0, left: 2.0, bottom: 5.0, right: 2.0)
        let textInset = ASInsetLayoutSpec(insets: textInsets, child: texts)
        
        return textInset
    }
}
