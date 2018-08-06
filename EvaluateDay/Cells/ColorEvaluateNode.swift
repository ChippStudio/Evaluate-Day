//
//  ColorCardNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol ColorEvaluateNodeStyle {
    var selectedColor: UIColor { get }
    var selectedColorDateColor: UIColor { get }
    var selectedColorDateFont: UIFont { get }
}
class ColorEvaluateNode: ASCellNode, ASCollectionDataSource, ASCollectionDelegate {

    // MARK: - UI
    var colorCollection: ASCollectionNode!
    var currentDate = ASTextNode()
    
    // MARK: - Variable
    var didSelectColor: ((String) -> Void)?
    var selectedColor: String
    private var lock: Bool
    private var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    private var colorStyle: ColorEvaluateNodeStyle
    
    // MARK: - Init
    init(selectedColor: String, date: Date, lock: Bool = false, style: ColorEvaluateNodeStyle) {
        self.selectedColor = selectedColor
        self.colorStyle = style
        self.lock = lock
        super.init()
        
        if let i = colorsForSelection.index(of: self.selectedColor) {
            self.selectedIndex = IndexPath(row: i, section: 0)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        
        self.colorCollection = ASCollectionNode(collectionViewLayout: layout)
        self.colorCollection.dataSource = self
        self.colorCollection.delegate = self
        self.colorCollection.backgroundColor = UIColor.clear
        self.colorCollection.contentInset = UIEdgeInsets(top: 0.0, left: 40.0, bottom: 0.0, right: 20.0)
        OperationQueue.main.addOperation {
            self.colorCollection.view.showsHorizontalScrollIndicator = false
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: style.selectedColorDateFont, NSAttributedStringKey.foregroundColor: style.selectedColorDateColor])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func didLoad() {
        super.didLoad()
        OperationQueue.main.addOperation {
            self.colorCollection.scrollToItem(at: self.selectedIndex, at: .centeredHorizontally, animated: true)
        }
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.colorCollection.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 70.0)
        
        let dateInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 10.0)
        let dateInset = ASInsetLayoutSpec(insets: dateInsets, child: self.currentDate)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 15.0
        cell.alignItems = .end
        cell.children = [self.colorCollection, dateInset]
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 30.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - ASCollectionDataSource
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return colorsForSelection.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let node = ColorDotNode(color: colorsForSelection[indexPath.row], style: self.colorStyle)
            node.selectionStyle = .none
            if colorsForSelection[indexPath.row] == self.selectedColor {
                node.colorSelected = true
                self.selectedIndex = indexPath
            } else {
                node.colorSelected = false
            }
            return node
        }
    }
    
    // MARK: - ASCollectionDelegate
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        collectionNode.deselectItem(at: indexPath, animated: true)
        if self.lock {
            return
        }
        if self.selectedIndex != indexPath {
            let newSelectedNode = self.colorCollection.nodeForItem(at: indexPath) as! ColorDotNode
            let oldSelectedNode = self.colorCollection.nodeForItem(at: self.selectedIndex) as! ColorDotNode
            
            oldSelectedNode.colorSelected = false
            newSelectedNode.colorSelected = true
            
            self.selectedIndex = indexPath
            
            self.selectedColor = colorsForSelection[indexPath.row]
            self.didSelectColor?(colorsForSelection[indexPath.row])
        }
    }
}
