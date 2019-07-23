//
//  CardsListDotNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CardsListDotNode: ASCellNode {
    
    // MARK: - UI
    var cover = ASDisplayNode()
    var image = ASImageNode()
    
    // MARK: - Init
    init(image: UIImage) {
        super.init()
        
        self.cover.backgroundColor = UIColor.main
        self.image.image = image //.resizeImage(maxSize: 30.0)
        self.image.contentMode = .scaleAspectFit
        self.image.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
        
        self.addSubnode(self.cover)
        self.cover.addSubnode(self.image)
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.cover.style.preferredSize = CGSize(width: 70.0, height: 70.0)
        self.cover.cornerRadius = 35.0
        
        self.cover.layoutSpecBlock = { (_, _) in
            self.image.style.preferredSize = CGSize(width: 30.0, height: 30.0)
            let center = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: self.image)
            return center
        }
        
        let coverInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let coverInset = ASInsetLayoutSpec(insets: coverInsets, child: self.cover)
        
        return coverInset
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.selected
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.main
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.main
        }
    }
}
