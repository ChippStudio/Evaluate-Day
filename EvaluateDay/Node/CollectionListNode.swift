//
//  CollectionListNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CollectionListNode: ASCellNode, ASCollectionDataSource {

    // MARK: - UI
    var imageNode = ASImageNode()
    var title = ASTextNode()
    var previews = [ASCellNode]()
    var collectionNode: ASCollectionNode!
    
    var editButton = ASButtonNode()
    var editButtonCover = ASDisplayNode()
    
    // MARK: - Variables
    var data = [(title: String, subtitle: String)]()
    
    // MARK: - Init
    init(title: String, image: UIImage, previews: [ASCellNode], data: [(title: String, subtitle: String)]) {
        super.init()
        
        self.previews = previews
        self.data = data
        
        self.editButtonCover.backgroundColor = UIColor.background
        self.editButtonCover.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        self.editButtonCover.cornerRadius = 25.0
        self.editButtonCover.alpha = 0.5
        
        self.editButton.setImage(Images.Media.dots.image.resizedImage(newSize: CGSize(width: 20.0, height: 6.0)), for: .normal)
        self.editButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        self.editButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        
        self.backgroundColor = UIColor.background
        self.cornerRadius = 10.0
        self.borderColor = UIColor.main.cgColor
        self.borderWidth = 0.5
        self.clipsToBounds = true
        
        self.imageNode.image = image
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .title1), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130.0, height: 60.0)
        layout.minimumLineSpacing = 10.0
        
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.collectionNode.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        self.collectionNode.showsVerticalScrollIndicator = false
        self.collectionNode.showsHorizontalScrollIndicator = false
        self.collectionNode.alwaysBounceHorizontal = true
        self.collectionNode.dataSource = self
        
        // Set button
        self.editButton.addTarget(self, action: #selector(self.buttonInitialAction(sender:)), forControlEvents: .touchDown)
        self.editButton.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.editButton.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpInside)
        self.editButton.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.imageNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 120.0)
        let fullEditButton = ASBackgroundLayoutSpec(child: self.editButton, background: self.editButtonCover)
        
        let fullEditButtonInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 10.0)
        let fullEditButtonInset = ASInsetLayoutSpec(insets: fullEditButtonInsets, child: fullEditButton)
        
        let relativeButton = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .start, sizingOption: [], child: fullEditButtonInset)
        let topImage = ASOverlayLayoutSpec(child: self.imageNode, overlay: relativeButton)
        
        let titleInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let titleInset = ASInsetLayoutSpec(insets: titleInsets, child: self.title)
        
        self.collectionNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 60.0)
        let collectionNodeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        let collectionNodeInset = ASInsetLayoutSpec(insets: collectionNodeInsets, child: self.collectionNode)
        
        let content = ASStackLayoutSpec.vertical()
        content.children = [topImage, titleInset, collectionNodeInset]
        
        for p in self.previews {
            content.children?.append(p)
        }
        
        return content
    }
    
    // MARK: - ASCollectionDataSource
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let item = self.data[indexPath.row]
        return {
            return CollectionListStaticticNode(title: item.title, subtitle: item.subtitle)
        }
    }
    
    // MARK: - Actions
    @objc func buttonInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.editButtonCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func buttonEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.editButtonCover.backgroundColor = UIColor.background
        }
    }
}

class CollectionListStaticticNode: ASCellNode {
    
    // MARK: - UI
    var titleNode = ASTextNode()
    var subtitleNode = ASTextNode()
    
    // MARK: - Init
    init(title: String, subtitle: String) {
        super.init()
        
        self.backgroundColor = UIColor.main
        self.cornerRadius = 5.0
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        self.titleNode.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.tint, NSAttributedStringKey.paragraphStyle: paragraph])
        self.subtitleNode.attributedText = NSAttributedString(string: subtitle, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.tint, NSAttributedStringKey.paragraphStyle: paragraph])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let texts = ASStackLayoutSpec.vertical()
        texts.justifyContent = .spaceBetween
        texts.children = [self.titleNode, self.subtitleNode]
        
        let textInsets = UIEdgeInsets(top: 5.0, left: 2.0, bottom: 5.0, right: 2.0)
        let textInset = ASInsetLayoutSpec(insets: textInsets, child: texts)
        
        return textInset
    }
}
