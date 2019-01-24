//
//  ActivityPhotoNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 20/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ActivityPhotoNode: ASCellNode {
    // MARK: - UI
    var imageNode = ASImageNode()
    
    // MARK: - Init
    init(image: UIImage) {
        super.init()
        
        self.imageNode.image = image
        self.imageNode.cornerRadius = 10.0
        self.imageNode.clipsToBounds = true
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let inset: CGFloat = 10.0
        let imageWidth = constrainedSize.max.width - inset * 2
        self.imageNode.style.preferredSize = CGSize(width: imageWidth, height: imageWidth)
        
        self.cornerRadius = 10.0
        
        let cellInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: self.imageNode)
        
        return cellInset
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = UIColor.tint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = UIColor.background
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = UIColor.background
        }
    }
}
