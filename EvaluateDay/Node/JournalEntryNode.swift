//
//  JournalEntryNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 04/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class JournalEntryNode: ASCellNode {
    // MARK: - UI
    var imageNode: ASImageNode!
    var textPreview = ASTextNode()
    var metadataNode = ASTextNode()
    var textCover = ASDisplayNode()
    
    var imageButton: ASButtonNode!
    var editTextButton: ASButtonNode!
    var selectImageButton: ASButtonNode!
    var cameraButton: ASButtonNode!
    var deleteImageButton: ASButtonNode!
    
    var cover = ASDisplayNode()
    
    private var button: ASButtonNode!
    
    // MARK: - Variables
    
    var didSelectItem: ((_ index: Int) -> Void)?
    
    private var index: Int = 0
    
    // MARK: - Init
    init(text: String, metadata: [String], photo: UIImage?, index: Int? = nil, truncation: Bool = false, editMode: Bool = false) {
        super.init()
        
        self.cover.backgroundColor = UIColor.main
        self.cover.cornerRadius = 10.0
        
        if index != nil {
            self.index = index!
        }
        
        var newText = text
        if newText.isEmpty {
            newText = Localizations.Evaluate.Journal.Entry.placeholder
        }
        
        if truncation {
            let maxCharts = 80
            
            if newText.count > maxCharts {
                let index = newText.index(newText.startIndex, offsetBy: maxCharts)
                newText = String(newText[..<index]) + "..."
            }
        }
        
        if photo != nil {
            self.imageNode = ASImageNode()
            self.imageNode.image = photo
            self.imageNode.contentMode = .scaleAspectFill
            self.imageNode.clipsToBounds = true
            self.imageNode.cornerRadius = 5.0
        } else if editMode {
            self.imageNode = ASImageNode()
            self.imageNode.image = #imageLiteral(resourceName: "imagePlaceholder")
            self.imageNode.contentMode = .scaleAspectFit
            self.imageNode.alpha = 0.7
            self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.tint)
            self.imageNode.clipsToBounds = true
            self.imageNode.cornerRadius = 5.0
        }
        
        self.textPreview.attributedText = NSAttributedString(string: newText, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.tint])
        
        var metadataString = ""
        for (i, m) in metadata.enumerated() {
            if i != 0 {
                metadataString += " • "
            }
            
            metadataString += m
        }
        
        self.metadataNode.attributedText = NSAttributedString(string: metadataString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2), NSAttributedStringKey.foregroundColor: UIColor.tint])
        
        if index != nil {
            self.button = ASButtonNode()
            self.button.addTarget(self, action: #selector(self.buttonAction(sender:)), forControlEvents: .touchUpInside)
        }
        
        if !editMode {
            self.isAccessibilityElement = true
            self.accessibilityTraits = UIAccessibilityTraitButton
            self.accessibilityLabel = newText
            self.accessibilityValue = metadataString
            if photo != nil {
                self.accessibilityValue = "\(metadataString), \(Localizations.Accessibility.Evaluate.Journal.entryPhoto)"
            }
            self.accessibilityHint = Localizations.Accessibility.Evaluate.Journal.entryHint
        }
        
        self.textCover.backgroundColor = UIColor.main
        self.textCover.cornerRadius = 5.0
        self.textCover.alpha = 0.8
        
        // Buttons
        if editMode {
            self.imageButton = ASButtonNode()
            self.imageButton.accessibilityLabel = Localizations.Accessibility.Evaluate.Journal.Entry.viewPhoto
            self.imageButton.accessibilityHint = Localizations.Accessibility.Evaluate.Journal.Entry.actionHint
            
            self.editTextButton = ASButtonNode()
            self.textPreview.isAccessibilityElement = false
            self.editTextButton.accessibilityLabel = newText
            self.editTextButton.accessibilityHint = Localizations.Accessibility.Evaluate.Journal.Entry.actionHint
            
            self.selectImageButton = ASButtonNode()
            self.selectImageButton.setImage(#imageLiteral(resourceName: "selectPhoto").resizedImage(newSize: CGSize(width: 25.0, height: 25.0)), for: .normal)
            self.selectImageButton.accessibilityLabel = Localizations.Accessibility.Evaluate.Journal.Entry.openGalery
            self.selectImageButton.accessibilityHint = Localizations.Accessibility.Evaluate.Journal.Entry.actionHint
            
            self.cameraButton = ASButtonNode()
            self.cameraButton.setImage(#imageLiteral(resourceName: "camera").resizedImage(newSize: CGSize(width: 25.0, height: 25.0)), for: .normal)
            self.cameraButton.accessibilityLabel = Localizations.Accessibility.Evaluate.Journal.Entry.openCamera
            self.cameraButton.accessibilityHint = Localizations.Accessibility.Evaluate.Journal.Entry.actionHint
            
            if photo != nil {
                self.deleteImageButton = ASButtonNode()
                self.deleteImageButton.setImage(Images.Media.delete.image.resizedImage(newSize: CGSize(width: 25.0, height: 25.0)), for: .normal)
                self.deleteImageButton.accessibilityLabel = Localizations.Accessibility.Evaluate.Journal.Entry.deletePhoto
                self.deleteImageButton.accessibilityHint = Localizations.Accessibility.Evaluate.Journal.Entry.actionHint
            }
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let textInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        let textInset = ASInsetLayoutSpec(insets: textInsets, child: self.textPreview)
        
        let cover = ASBackgroundLayoutSpec(child: textInset, background: self.textCover)
        var coverTopInset: CGFloat = 10.0
        if self.imageNode != nil {
            coverTopInset = -30.0
        }
        
        let coverInsets = UIEdgeInsets(top: coverTopInset, left: 20.0, bottom: 20.0, right: 10.0)
        var coverInset = ASInsetLayoutSpec(insets: coverInsets, child: cover)
        if editTextButton != nil {
            let editTextBackButton = ASOverlayLayoutSpec(child: cover, overlay: self.editTextButton)
            coverInset = ASInsetLayoutSpec(insets: coverInsets, child: editTextBackButton)
        }
        
        let meta = ASStackLayoutSpec.vertical()
        meta.spacing = 5.0
        meta.alignItems = .end
        meta.children = [self.metadataNode]
        
        let content = ASStackLayoutSpec.vertical()
        content.spacing = 5.0
        content.children = [coverInset, meta]
        
        if self.selectImageButton != nil {
            self.selectImageButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
            self.cameraButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
            if self.deleteImageButton != nil {
                self.deleteImageButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
            }
        }
        
        if self.imageNode != nil {
            self.imageNode.style.preferredSize = CGSize(width: 140.0, height: 80.0)
            if self.imageButton == nil {
                content.children?.insert(self.imageNode, at: 0)
            } else {
                let imageBackButton = ASOverlayLayoutSpec(child: self.imageNode, overlay: self.imageButton)
                imageBackButton.style.preferredSize = CGSize(width: 140.0, height: 80.0)
                
                let buttonsStack = ASStackLayoutSpec.horizontal()
                buttonsStack.spacing = 10.0
                buttonsStack.children = [imageBackButton, self.cameraButton, self.selectImageButton]
                
                if self.deleteImageButton != nil {
                    buttonsStack.children?.append(self.deleteImageButton)
                }
                content.children?.insert(buttonsStack, at: 0)
            }
        }
        
        let contentInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        if self.button != nil {
            let back = ASOverlayLayoutSpec(child: cellInset, overlay: self.button)
            return back
        }
        
        return cellInset
    }
    
    // MARK: - Action
    @objc func buttonAction(sender: ASButtonNode) {
        self.didSelectItem?(self.index)
    }
}
