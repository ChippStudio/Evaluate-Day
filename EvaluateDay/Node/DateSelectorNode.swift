//
//  DateSelectorNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class DateSelectorNode: ASCellNode {
    
    // MARK: - UI
    var datePicker: UIDatePicker!
    var cover: ASDisplayNode!
    
    // MARK: - Variables
    var didLoadDatePicker: ((_ datePicker: UIDatePicker) -> Void)?
    
    // MARK: - Init
    init(date: Date) {
        super.init()
        
        self.cover = ASDisplayNode(viewBlock: { () -> UIView in
            self.datePicker = UIDatePicker()
            self.datePicker.date = date
            self.datePicker.maximumDate = Date()
            self.datePicker.datePickerMode = UIDatePickerMode.date
            
            return self.datePicker
        }, didLoad: { (_) in
            self.didLoadDatePicker?(self.datePicker)
        })
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.cover.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 216)
        
        let cellInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: self.cover)
        
        return cellInset
    }
}
