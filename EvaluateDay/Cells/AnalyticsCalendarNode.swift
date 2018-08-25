//
//  AnalyticsCalendarNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import FSCalendar

protocol AnalyticsCalendarNodeStyle {
    var calendarTitleFont: UIFont { get }
    var calendarTitleColor: UIColor { get }
    var calendarFont: UIFont { get }
    var calendarWeekdaysColor: UIColor { get }
    var calendarCurrentMonthColor: UIColor { get }
    var calendarOtherMonthColor: UIColor { get }
    var calendarShareTintColor: UIColor { get }
    var calendarSetColor: UIColor { get }
}

class AnalyticsCalendarNode: ASCellNode {
    // MARK: - UI
    var calendar: FSCalendar!
    var title = ASTextNode()
    var calendarNode: ASDisplayNode!
    var shareButton = ASButtonNode()
    
    // MARK: - Variable
    var topInset: CGFloat = 0.0
    var didLoadCalendar: (() -> Void)?
    
    // MARK: - Unit
    init(title: String, style: AnalyticsCalendarNodeStyle) {
        super.init()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: style.calendarTitleFont, NSAttributedStringKey.foregroundColor: style.calendarTitleColor, NSAttributedStringKey.paragraphStyle: paragraphStyle])
        
        self.shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        self.shareButton.imageNode.contentMode = .scaleAspectFit
        self.shareButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.calendarShareTintColor)
        
        self.calendarNode = ASDisplayNode(viewBlock: { () -> UIView in
            self.calendar = FSCalendar()
            self.calendar.clipsToBounds = true
            self.calendar.allowsSelection = false
            self.calendar.today = nil
            self.calendar.backgroundColor = UIColor.clear
            self.calendar.firstWeekday = UInt(Database.manager.application.settings.weekStart)
            self.calendar.appearance.titleFont = style.calendarFont
            self.calendar.appearance.weekdayFont = style.calendarFont
            self.calendar.appearance.subtitleFont = style.calendarFont
            self.calendar.appearance.headerTitleFont = style.calendarFont
            self.calendar.appearance.headerTitleColor = style.calendarWeekdaysColor
            
            self.calendar.appearance.weekdayTextColor = style.calendarWeekdaysColor
            self.calendar.appearance.titleDefaultColor = style.calendarCurrentMonthColor
            self.calendar.appearance.titlePlaceholderColor = style.calendarOtherMonthColor
            return self.calendar
        }, didLoad: { (_) in
            self.didLoadCalendar?()
        })
        
        // Accessibility
        self.title.isAccessibilityElement = false
        
        self.shareButton.accessibilityLabel = Localizations.calendar.empty.share
        self.shareButton.accessibilityValue = "\(self.title.attributedText!.string), \(Localizations.accessibility.analytics.calendarView)"
        
        self.calendarNode.isAccessibilityElement = true
        self.calendarNode.accessibilityTraits = UIAccessibilityTraitNotEnabled
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.calendarNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 250.0)
        self.shareButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        
        self.title.style.flexShrink = 1.0
        
        let titleStack = ASStackLayoutSpec.horizontal()
        titleStack.alignItems = .center
        titleStack.justifyContent = .spaceBetween
        titleStack.style.flexShrink = 1.0
        titleStack.children = [self.title, self.shareButton]
        
        let shareInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        let shareInset = ASInsetLayoutSpec(insets: shareInsets, child: titleStack)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 10.0
        cell.children = [shareInset, self.calendarNode]
        
        let cellInsets = UIEdgeInsets(top: self.topInset, left: 0.0, bottom: 20.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
