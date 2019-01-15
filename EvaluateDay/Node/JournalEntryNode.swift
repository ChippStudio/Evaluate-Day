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
    var imageNodes = [ASImageNode]()
    var textPreview = ASTextNode()
    var dateNode = ASTextNode()
    
    var weatherImage = ASImageNode()
    var weatherText = ASTextNode()
    var locationText = ASTextNode()
    
    var cover = ASDisplayNode()
    
    private var button: ASButtonNode!
    
    // MARK: - Variables
    
    var didSelectItem: ((_ index: Int) -> Void)?
    
    private var index: Int!
    
    // MARK: - Init
    init(preview: String, images: [UIImage?], date: Date, weatherImage: UIImage?, weatherText: String, locationText: String, index: Int? = nil) {
        super.init()
        
        self.index = index
        
        self.cover.backgroundColor = UIColor.background
        self.cover.cornerRadius = 10.0
        
        for i in images {
            let im = ASImageNode()
            im.image = i
            im.contentMode = .scaleAspectFill
            im.clipsToBounds = true
            im.cornerRadius = 24.0
            im.style.preferredSize = CGSize(width: 48.0, height: 48.0)
            self.imageNodes.append(im)
        }
        
        self.weatherImage.image = weatherImage
        self.weatherImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        self.weatherImage.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        
        self.weatherText.attributedText = NSAttributedString(string: weatherText, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedStringKey.foregroundColor: UIColor.main])
        self.locationText.attributedText = NSAttributedString(string: locationText, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedStringKey.foregroundColor: UIColor.main])
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .medium)
        self.dateNode.attributedText = NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedStringKey.foregroundColor: UIColor.main])
        
        var newText = preview
        if newText.isEmpty {
            newText = Localizations.Evaluate.Journal.Entry.placeholder
        }
        let maxCharts = 80
        
        if newText.count > maxCharts {
            let index = newText.index(newText.startIndex, offsetBy: maxCharts)
            newText = String(newText[..<index]) + "..."
        }
        
        self.textPreview.attributedText = NSAttributedString(string: newText, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        if self.index != nil {
            self.button = ASButtonNode()
            self.button.addTarget(self, action: #selector(self.buttonAction(sender:)), forControlEvents: .touchUpInside)
            
            self.button.addTarget(self, action: #selector(self.buttonInitialAction(sender:)), forControlEvents: .touchDown)
            self.button.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpOutside)
            self.button.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpInside)
            self.button.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchCancel)
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let images = ASStackLayoutSpec.horizontal()
        images.spacing = -18
        images.children = self.imageNodes
        
        let metadata = ASStackLayoutSpec.vertical()
        metadata.children = [self.weatherText, self.locationText]
        
        let allWeather = ASStackLayoutSpec.horizontal()
        allWeather.spacing = 5.0
        allWeather.alignItems = .center
        allWeather.children = [self.weatherImage, metadata]
        
        let allMetadata = ASStackLayoutSpec.horizontal()
        allMetadata.spacing = 10.0
        allMetadata.justifyContent = .spaceBetween
        allMetadata.alignItems = .center
        allMetadata.children = [images, allWeather]
        
        let dateStack = ASStackLayoutSpec.horizontal()
        dateStack.justifyContent = .end
        dateStack.children = [self.dateNode]
        
        let content = ASStackLayoutSpec.vertical()
        content.spacing = 5.0
        content.children = [allMetadata, self.textPreview, dateStack]
        
        let contentInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)

        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)

        let cellInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 0.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)

        if self.button != nil {
            let back = ASOverlayLayoutSpec(child: cellInset, overlay: self.button)
            return back
        }
        
        return cellInset
    }
    
    // MARK: - Action
    @objc func buttonAction(sender: ASButtonNode) {
        if index != nil {
            self.didSelectItem?(self.index)
        }
    }
    
    @objc func buttonInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.tint
        }
    }
    
    @objc func buttonEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.background
        }
    }
}
