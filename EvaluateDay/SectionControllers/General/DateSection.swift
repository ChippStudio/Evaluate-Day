//
//  DateSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class DateSection: ListSectionController, ASSectionController {
    
    // MARK: - Variables
    var date = Date() {
        didSet {
            if let controller = self.viewController as? CollectionViewController {
                if let node = controller.collectionNode.nodeForItem(at: IndexPath(row: 2, section: self.section)) as? DateButtonsNode {
                    node.date = date
                }
                if let node = controller.collectionNode.nodeForItem(at: IndexPath(row: 1, section: self.section)) as? DateShowNode {
                    node.date = date
                }
            }
        }
    }
    var isEdit = false {
        didSet {
            self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(in: self, at: IndexSet(integer: 1))
            }, completion: nil)
        }
    }
    
    // MARK: - Init
    init(date: Date) {
        self.date = date
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 4
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        switch index {
        case 1:
            if self.isEdit {
                return {
                    let node = DateSelectorNode(date: self.date)
                    node.didLoadDatePicker = {(datePicker) in
                        datePicker.addTarget(self, action: #selector(self.dateChanged(sender:)), for: .valueChanged)
                    }
                    return node
                }
            } else {
                return {
                    let node = DateShowNode(date: self.date)
                    return node
                }
            }
        case 2:
            return {
                let node = DateButtonsNode(date: self.date)
                node.date = self.date
                node.todayButton.addTarget(self, action: #selector(self.todayButtonTouch(sender:)), forControlEvents: .touchUpInside)
                node.arrowButton.addTarget(self, action: #selector(self.arrowButtonTouch(sender:)), forControlEvents: .touchUpInside)
                return node
            }
        default:
            return {
                let separator = SeparatorNode()
                var topInset: CGFloat = 0.0
                var buttonInset: CGFloat = 0.0
                if index == 0 {
                    topInset = 35.0
                }
                if index == 3 {
                    buttonInset = 35.0
                }
                separator.insets = UIEdgeInsets(top: topInset, left: 20.0, bottom: buttonInset, right: 20.0)
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
        
        let max = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let min = CGSize(width: width, height: 0)
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
    
    // MARK: - Actions
    @objc func arrowButtonTouch(sender: ASButtonNode) {
        
        self.isEdit = !self.isEdit
        
        if let controller = self.viewController as? CollectionViewController {
            if let node = controller.collectionNode.nodeForItem(at: IndexPath(row: 2, section: self.section)) as? DateButtonsNode {
                UIView.animate(withDuration: 0.2) {
                    if self.isEdit {
                        node.arrowImage.view.transform = CGAffineTransform.identity
                    } else {
                        node.arrowImage.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    }
                }
            }
        }
    }
    
    @objc func todayButtonTouch(sender: ASButtonNode) {
        self.date = Date()
        if let controller = self.viewController as? CollectionViewController {
            if let node = controller.collectionNode.nodeForItem(at: IndexPath(row: 1, section: self.section)) as? DateSelectorNode {
                node.datePicker.setDate(self.date, animated: true)
            }
        }
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        self.date = sender.date
    }
}
