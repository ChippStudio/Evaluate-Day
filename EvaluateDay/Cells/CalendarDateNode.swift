//
//  CalendarDateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol CalendarDateNodeStyle {
    var calendarDateColor: UIColor { get }
    var calendarDateFont: UIFont { get }
    var calendarWeekdayColor: UIColor { get }
    var calendarWeekdayFont: UIFont { get }
    var calendarBackgroundColor: UIColor { get }
    var calendarSelectedColor: UIColor { get }
}

class CalendarDateNode: ASCellNode {
    // MARK: - UI
    var date = ASTextNode()
    var weekday = ASTextNode()
    var cover = ASDisplayNode()
    
    // MARK: - Init
    init(date: Date, style: CalendarDateNodeStyle) {
        super.init()
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        self.date.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: style.calendarDateFont, NSAttributedStringKey.foregroundColor: style.calendarDateColor, NSAttributedStringKey.paragraphStyle: paragraph])
        
        formatter.dateFormat = "EEE"
        self.weekday.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: style.calendarWeekdayFont, NSAttributedStringKey.foregroundColor: style.calendarWeekdayColor, NSAttributedStringKey.paragraphStyle: paragraph])
        
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraitButton
        self.accessibilityLabel = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        self.accessibilityElementsHidden = false
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let text = ASStackLayoutSpec.vertical()
        text.spacing = -10.0
        text.justifyContent = .center
        text.children = [self.date, self.weekday]
        
        self.cover.style.preferredSize = CGSize(width: 80.0, height: 80.0)
        self.cover.cornerRadius = 10.0
        
        let cell = ASBackgroundLayoutSpec(child: text, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
