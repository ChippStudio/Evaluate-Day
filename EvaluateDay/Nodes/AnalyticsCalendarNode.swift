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

class AnalyticsCalendarNode: ASCellNode {
    // MARK: - UI
    var calendar: FSCalendar!
    var title = ASTextNode()
    var calendarNode: ASDisplayNode!
    var shareButton = ASButtonNode()
    
    // MARK: - Variable
    var didLoadCalendar: (() -> Void)?
    
    // MARK: - Unit
    init(title: String) {
        super.init()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedStringKey.foregroundColor: UIColor.text, NSAttributedStringKey.paragraphStyle: paragraphStyle])
        
        self.shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        self.shareButton.imageNode.contentMode = .scaleAspectFit
        self.shareButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        
        self.calendarNode = ASDisplayNode(viewBlock: { () -> UIView in
            self.calendar = FSCalendar()
            self.calendar.clipsToBounds = true
            self.calendar.allowsSelection = false
            self.calendar.today = nil
            self.calendar.backgroundColor = UIColor.clear
            self.calendar.firstWeekday = UInt(Database.manager.application.settings.weekStart)
            self.calendar.appearance.titleFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            self.calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            self.calendar.appearance.subtitleFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            self.calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            self.calendar.appearance.headerTitleColor = UIColor.text
            
            self.calendar.appearance.weekdayTextColor = UIColor.main
            self.calendar.appearance.titleDefaultColor = UIColor.text
            self.calendar.appearance.titlePlaceholderColor = UIColor.main
            return self.calendar
        }, didLoad: { (_) in
            self.didLoadCalendar?()
        })

        // Accessibility
        self.title.isAccessibilityElement = false
        
        self.shareButton.accessibilityLabel = Localizations.Calendar.Empty.share
        self.shareButton.accessibilityValue = "\(self.title.attributedText!.string), \(Localizations.Accessibility.Analytics.calendarView)"
        
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
        cell.justifyContent = .center
        cell.children = [shareInset, self.calendarNode]
        
        let cellInsets = UIEdgeInsets(top: 50.0, left: 0.0, bottom: 20.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
