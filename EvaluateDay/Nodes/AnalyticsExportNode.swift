//
//  AnalyticsExportNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 20/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AnalyticsExportNode: ASCellNode, ASCollectionDataSource, ASCollectionDelegate {
    // MARK: - UI
    var collectionNode: ASCollectionNode!
    var title = ASTextNode()
    var action = ASTextNode()
    
    // MARK: - Variables
    var topOffset: CGFloat = 10.0
    var didSelectType: ((ExportType, IndexPath, Int) -> Void)?
    private var types = [ExportType]()
    
    // MARK: - Init
    init(types: [ExportType], title: String, action: String) {
        super.init()
        
        self.types = types
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedStringKey.foregroundColor: UIColor.text])
        let center = NSMutableParagraphStyle()
        center.alignment = .center
        self.action.attributedText = NSAttributedString(string: action, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedStringKey.foregroundColor: UIColor.main, NSAttributedStringKey.paragraphStyle: center])
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10.0
        
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.collectionNode.dataSource = self
        self.collectionNode.delegate = self
        self.collectionNode.backgroundColor = UIColor.clear
        self.collectionNode.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        OperationQueue.main.addOperation {
            self.collectionNode.view.alwaysBounceHorizontal = true
            self.collectionNode.view.showsHorizontalScrollIndicator = false
        }
        
        // Accessibility
        self.action.isAccessibilityElement = false
        self.title.accessibilityValue = action
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.collectionNode.style.preferredSize.height = 90.0
        
        let collectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
        let collectionInset = ASInsetLayoutSpec(insets: collectionInsets, child: collectionNode)
        
        let titleInsets = UIEdgeInsets(top: self.topOffset, left: 10.0, bottom: 10.0, right: 10.0)
        let titleInset = ASInsetLayoutSpec(insets: titleInsets, child: self.title)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.children = [titleInset, collectionInset, self.action]
        
        return cell
    }
    
    // MARK: - ASCollectionDataSource
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.types.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let type = self.types[indexPath.row]
        return {
            return AnalyticsExportFileTypeNode(type: type)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        collectionNode.deselectItem(at: indexPath, animated: true)
        self.didSelectType?(self.types[indexPath.row], self.indexPath!, indexPath.row)
    }
}
