//
//  CollectionListNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CollectionListNode: ASCellNode {

    // MARK: - UI
    var imageNode = ASImageNode()
    var title = ASTextNode()
    
    var previews = [ASCellNode]()
    
    // MARK: - Init
    init(title: String, image: UIImage, previews: [ASCellNode]) {
        super.init()
        
        self.previews = previews
        
        self.backgroundColor = UIColor.background
        self.cornerRadius = 10.0
        self.borderColor = UIColor.text.cgColor
        self.borderWidth = 1.0
        self.clipsToBounds = true
        
        self.imageNode.image = image
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .title1), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.imageNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 120.0)
        
        let titleInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let titleInset = ASInsetLayoutSpec(insets: titleInsets, child: self.title)
        
        let content = ASStackLayoutSpec.vertical()
        content.children = [self.imageNode, titleInset]
        
        for p in self.previews {
            content.children?.append(p)
        }
        
        return content
    }
}
