//
//  HabitEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class HabitEvaluateNode: ASCellNode {
    // MARK: - UI
    var marksCount = ASTextNode()
    var previousMarkCount = ASTextNode()
    var currentDate = ASTextNode()
    var previousDate = ASTextNode()
    var countSeparator = ASDisplayNode()
    
    var markButton = ASButtonNode()
    var markButtonCover = ASDisplayNode()
    
    var markAndCommentButton = ASButtonNode()
    var markAndCommentButtonCover = ASDisplayNode()
    
    var deleteButton: ASButtonNode?
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(marks: Int, previousMarks: Int, date: Date) {
        super.init()
        
        self.marksCount.attributedText = NSAttributedString(string: "\(marks)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 50.0, weight: .medium), NSAttributedStringKey.foregroundColor: UIColor.text])
        self.previousMarkCount.attributedText = NSAttributedString(string: "\(previousMarks)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 50.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        var components = DateComponents()
        components.day = -1
        
        let previousDate = Calendar.current.date(byAdding: components, to: date)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text])
        self.previousDate.attributedText = NSAttributedString(string: formatter.string(from: previousDate), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        self.countSeparator.backgroundColor = UIColor.main
        self.countSeparator.cornerRadius = 2.0
        
        let markButtonString = NSAttributedString(string: Localizations.Evaluate.Habit.mark, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.textTint])
        let markCommentButtonString = NSAttributedString(string: Localizations.Evaluate.Habit.markAndComment, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.textTint])
        let deleteCommentString = NSAttributedString(string: Localizations.Evaluate.Habit.removeLast, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.negative])
        
        self.markButtonCover.backgroundColor = UIColor.main
        self.markButtonCover.cornerRadius = 10.0
        self.markAndCommentButtonCover.backgroundColor = UIColor.main
        self.markAndCommentButtonCover.cornerRadius = 10.0
        
        self.markButton.setAttributedTitle(markButtonString, for: .normal)
        self.markAndCommentButton.setAttributedTitle(markCommentButtonString, for: .normal)
        
        if marks != 0 {
            self.deleteButton = ASButtonNode()
            self.deleteButton!.setAttributedTitle(deleteCommentString, for: .normal)
        }
        
        // Accessibility
        self.currentDate.isAccessibilityElement = false
        self.marksCount.isAccessibilityElement = false
        self.previousDate.isAccessibilityElement = false
        self.previousMarkCount.isAccessibilityElement = false
        
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = Localizations.Accessibility.Evaluate.Habit.summory("\(marks)", formatter.string(from: date), "\(previousMarks)")
        
        self.markButton.addTarget(self, action: #selector(self.markInitialAction(sender:)), forControlEvents: .touchDown)
        self.markButton.addTarget(self, action: #selector(self.markValueEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.markButton.addTarget(self, action: #selector(self.markValueEndAction(sender:)), forControlEvents: .touchUpInside)
        self.markButton.addTarget(self, action: #selector(self.markValueEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.markAndCommentButton.addTarget(self, action: #selector(self.markAndCommentInitialAction(sender:)), forControlEvents: .touchDown)
        self.markAndCommentButton.addTarget(self, action: #selector(self.markAndCommentEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.markAndCommentButton.addTarget(self, action: #selector(self.markAndCommentEndAction(sender:)), forControlEvents: .touchUpInside)
        self.markAndCommentButton.addTarget(self, action: #selector(self.markAndCommentEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Overrirde
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let currentStack = ASStackLayoutSpec.vertical()
        currentStack.alignItems = .end
        currentStack.spacing = 5.0
        currentStack.children = [self.marksCount, currentDate]
        
        let previousStack = ASStackLayoutSpec.vertical()
        previousStack.alignItems = .end
        previousStack.spacing = 5.0
        previousStack.children = [self.previousMarkCount, self.previousDate]
        
        self.countSeparator.style.preferredSize = CGSize(width: 4.0, height: 80.0)
        
        let allMarks = ASStackLayoutSpec.horizontal()
        allMarks.spacing = 20.0
        allMarks.alignItems = .end
        allMarks.children = [currentStack, self.countSeparator, previousStack]
        
        let allMarksAccessibility = ASBackgroundLayoutSpec(child: allMarks, background: self.accessibilityNode)
        
        let marksCounter = ASStackLayoutSpec.horizontal()
        marksCounter.justifyContent = .spaceBetween
        marksCounter.spacing = 10.0
        marksCounter.children = [allMarksAccessibility]
        marksCounter.flexWrap = .wrap
        marksCounter.alignItems = .end
        if self.deleteButton != nil {
            marksCounter.children?.append(self.deleteButton!)
        }
        
        let markButtonsInsets = UIEdgeInsets(top: 10.0, left: 30.0, bottom: 10.0, right: 30.0)
        
        let markButtonInset = ASInsetLayoutSpec(insets: markButtonsInsets, child: self.markButton)
        let markAndCommentButtonInset = ASInsetLayoutSpec(insets: markButtonsInsets, child: self.markAndCommentButton)
        
        let fullMarkButton = ASBackgroundLayoutSpec(child: markButtonInset, background: self.markButtonCover)
        let fullMarkAndCommentButton = ASBackgroundLayoutSpec(child: markAndCommentButtonInset, background: self.markAndCommentButtonCover)
        
        fullMarkButton.style.flexGrow = 1.0
        fullMarkAndCommentButton.style.flexGrow = 1.0
        
        let buttons = ASStackLayoutSpec.vertical()
        buttons.spacing = 10.0
        buttons.children = [fullMarkButton, fullMarkAndCommentButton]
        
        let counterInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
        let counterInset = ASInsetLayoutSpec(insets: counterInsets, child: marksCounter)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 20.0
        cell.children = [counterInset, buttons]
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func markInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.markButtonCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func markValueEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.markButtonCover.backgroundColor = UIColor.main
        }
    }
    
    @objc func markAndCommentInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.markAndCommentButtonCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func markAndCommentEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.markAndCommentButtonCover.backgroundColor = UIColor.main
        }
    }
}
