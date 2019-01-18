//
//  AnalyticsExportFileTypeNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 20/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AnalyticsExportFileTypeNode: ASCellNode {

    // MARK: - UI
    var imageNode = ASImageNode()
    
    // MARK: - Init
    init(type: ExportType) {
        super.init()
        
        self.backgroundColor = UIColor.background
        self.cornerRadius = 10.0
        
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraitButton
        self.accessibilityHint = Localizations.Accessibility.Analytics.Export.hint
        
        var fileTitle = ""
        switch type {
        case .csv:
            self.imageNode.image = Images.Media.csv.image
            fileTitle = "csv"
        case .json:
            self.imageNode.image = Images.Media.json.image
            fileTitle = "json"
        case .txt:
            self.imageNode.image = Images.Media.txt.image
            fileTitle = "txt"
        }
        
        self.accessibilityLabel = Localizations.Accessibility.Analytics.Export.title(fileTitle)
        
        self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        self.imageNode.contentMode = .scaleAspectFit
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.imageNode.style.preferredSize = CGSize(width: constrainedSize.max.height - 20, height: constrainedSize.max.height - 20)
        
        let imageInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let imageInset = ASInsetLayoutSpec(insets: imageInsets, child: self.imageNode)
        
        return imageInset
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
