//
//  CalendarSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CalendarSection: ListSectionController, ASSectionController, ASCollectionDataSource, ASCollectionDelegate {
    // MARK: - Variable
    var didSelectDate: ((_ date: Date) -> Void)?
    
    var dates = [Date]()
    
    var selectedDate = Date() {
        didSet {
            self.didSelectDate?(self.selectedDate)
        }
    }
    
    // MARK: - Override
    override init() {
        super.init()
        self.setDates()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadeCalendar(sender:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
    }
    override func numberOfItems() -> Int {
        return 1
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        return {
            let node = CalendarNode()
            node.collectionNode.dataSource = self
            node.collectionNode.delegate = self
            
            return node
        }
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        let width: CGFloat = self.collectionContext!.containerSize.width
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
    
    // MARK: - ASCollectionDataSource
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let date = self.dates[indexPath.row]
        let style = Themes.manager.evaluateStyle
        var selected = false
        if date == self.selectedDate.start {
            selected = true
        }
        return {
            let node = CalendarDateNode(date: date, style: style)
            if selected {
                node.cover.backgroundColor = style.calendarSelectedColor
            } else {
                node.cover.backgroundColor = style.calendarBackgroundColor
            }
            return node
        }
    }
    
    // MARK: - ASCollectionDelegate
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        collectionNode.deselectItem(at: indexPath, animated: true)
        
        if let index = self.dates.index(of: self.selectedDate.start) {
            let oldIndexPath = IndexPath(row: index, section: 0)
            
            self.selectedDate = self.dates[indexPath.row]
            collectionNode.reloadItems(at: [oldIndexPath])
        }
        collectionNode.reloadItems(at: [indexPath])
    }
    
    // MARK: - Action
    @objc func reloadeCalendar(sender: Notification) {
        self.setDates()
        collectionContext?.performBatch(animated: false, updates: { (batchContext) in
            batchContext.reload(self)
        }, completion: nil)
    }
    
    // MARK: - Private
    private func setDates() {
        
        self.dates.removeAll()
        
        let today = Date().start
        self.dates.append(today)
        
        var dateComponents = DateComponents()
        
        for i in 1...1500 {
            dateComponents.day = -i
            let newDate = Calendar.current.date(byAdding: dateComponents, to: today)!
            self.dates.insert(newDate, at: 0)
        }
        
        dateComponents.day = 1
        let newDate = Calendar.current.date(byAdding: dateComponents, to: today)!
        self.dates.append(newDate)
    }

}
