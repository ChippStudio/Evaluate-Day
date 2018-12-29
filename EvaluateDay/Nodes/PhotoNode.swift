//
//  PhotoNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PhotoNode: ASCellNode {
    // MARK: - UI
    var photo = ASImageNode()
    
    // MARK: - Init
    init(photo: UIImage) {
        super.init()
        
        self.photo.image = photo
        self.photo.contentMode = .scaleAspectFill
        
        self.photo.cornerRadius = 5.0
        self.photo.clipsToBounds = true
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.photo.style.preferredSize.height = 230.0
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: self.photo)
        
        return cellInset
    }
}
