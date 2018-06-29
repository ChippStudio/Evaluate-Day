//
//  ProLockSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 21/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RealmSwift

class ProLockSection: ListSectionController, ASSectionController {

    // MARK: - Variable
    var didSelectPro: (() -> Void)?
    
    // MARK: - Private variables
    private var isPro: Bool!
    private var realmToken: NotificationToken!
    
    override init() {
        super.init()
        if let user = Database.manager.app.objects(User.self).first {
            self.realmToken = user.observe({ (_) in
                if self.isPro != Store.current.isPro {
                    self.isPro = Store.current.isPro
                    self.collectionContext?.performBatch(animated: true, updates: { (context) in
                        print("RELOAD FROM PRO LOCK")
                        context.reload(self)
                    }, completion: nil)
                }
            })
        }
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 1
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let isPro = Store.current.isPro
        return {
            return SettingsProNode(pro: isPro, style: Themes.manager.settingsStyle)
        }
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        let width: CGFloat = self.collectionContext!.containerSize.width
        
        if  width >= maxCollectionWidth {
            let max = CGSize(width: width * collectionViewWidthDevider, height: CGFloat.greatestFiniteMagnitude)
            let min = CGSize(width: width * collectionViewWidthDevider, height: 0)
            return ASSizeRange(min: min, max: max)
        }
        
        let max = CGSize(width: width - collectionViewOffset, height: CGFloat.greatestFiniteMagnitude)
        let min = CGSize(width: width - collectionViewOffset, height: 0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .zero
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext!.dequeueReusableCell(of: _ASCollectionViewCell.self, for: self, at: index)
    }
    
    override func didSelectItem(at index: Int) {
        self.didSelectPro?()
    }
}
