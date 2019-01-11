//
//  ColorCardNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ColorEvaluateNode: ASCellNode, ASCollectionDataSource, ASCollectionDelegate {

    // MARK: - UI
    var colorCollection: ASCollectionNode!
    var currentDate = ASTextNode()
    var cover = ASDisplayNode()
    
    // MARK: - Variable
    var didSelectColor: ((String) -> Void)?
    var selectedColor: String
    private var lock: Bool
    private var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    // MARK: - Init
    init(selectedColor: String, date: Date, lock: Bool = false) {
        self.selectedColor = selectedColor
        self.lock = lock
        super.init()
        
        self.cover.backgroundColor = UIColor.main
        self.cover.cornerRadius = 10.0
        
        for i in 0..<colorsForSelection.count {
            if colorsForSelection[i].color == self.selectedColor {
                self.selectedIndex = IndexPath(row: i, section: 0)
                break
            }
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        
        self.colorCollection = ASCollectionNode(collectionViewLayout: layout)
        self.colorCollection.dataSource = self
        self.colorCollection.delegate = self
        self.colorCollection.backgroundColor = UIColor.clear
        self.colorCollection.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        OperationQueue.main.addOperation {
            self.colorCollection.view.showsHorizontalScrollIndicator = false
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.tint])
        self.currentDate.isAccessibilityElement = false
        
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
        
        let content = ASStackLayoutSpec.vertical()
        content.spacing = 15.0
        content.alignItems = .end
        content.children = [self.colorCollection, dateInset]
        
        let contentInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 10.0, right: 0.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
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
            let node = ColorDotNode(color: colorsForSelection[indexPath.row].color)
            node.isAccessibilityElement = true
            node.accessibilityLabel = "\(colorsForSelection[indexPath.row].name), \(self.currentDate.attributedText!.string)"
            node.accessibilityTraits = UIAccessibilityTraitButton
            node.selectionStyle = .none
            if colorsForSelection[indexPath.row].color == self.selectedColor {
                node.colorSelected = true
                node.accessibilityValue = Localizations.Accessibility.selected
                self.selectedIndex = indexPath
            } else {
                node.colorSelected = false
                node.accessibilityValue = Localizations.Accessibility.unselected
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
            oldSelectedNode.accessibilityValue = Localizations.Accessibility.unselected
            newSelectedNode.colorSelected = true
            newSelectedNode.accessibilityValue = Localizations.Accessibility.selected
            
            self.selectedIndex = indexPath
            
            self.selectedColor = colorsForSelection[indexPath.row].color
            self.didSelectColor?(colorsForSelection[indexPath.row].color)
        }
    }
}
