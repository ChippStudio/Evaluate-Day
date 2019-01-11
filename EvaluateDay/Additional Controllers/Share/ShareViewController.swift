//
//  ShareViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/08/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import Branch

class ShareViewController: UIViewController {
    
    // MARK: - UI
    @IBOutlet weak var closeButtonCover: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var shareImageView: UIImageView!
    
    @IBOutlet weak var shareButtonCover: UIView!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Variable
    var image: UIImage!
    var canonicalIdentifier: String = ""
    var feature = "Content share"
    var channel = ""
    
    // MARK: - Handler
    var shareHandler: (() -> Void)?
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let style = Themes.manager.shareViewStyle
        
        self.view.backgroundColor = style.shareControllerBackground
        
        self.closeButton.setImage(#imageLiteral(resourceName: "close").resizedImage(newSize: CGSize(width: 30.0, height: 30.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.closeButton.tintColor = style.shareControllerCloseTintColor
        self.closeButton.accessibilityLabel = Localizations.General.close
        self.closeButtonCover.layer.masksToBounds = true
        self.closeButtonCover.layer.cornerRadius = 25.0
        self.closeButtonCover.backgroundColor = style.shareControllerBackground
        
        self.shareImageView.contentMode = .scaleAspectFit
        self.shareImageView.image = self.image
        
        self.shareButton.setTitle(Localizations.Calendar.Empty.share, for: .normal)
        self.shareButton.setTitleColor(style.shareControllerShareButtonTextColor, for: .normal)
        self.shareButton.setTitleColor(style.shareControllerShareButtonTextHighlightedColor, for: .highlighted)
        self.shareButton.titleLabel?.font = style.shareControllerShareButtonTextFont
        self.shareButtonCover.layer.masksToBounds = true
        self.shareButtonCover.layer.cornerRadius = 8.0
        self.shareButtonCover.backgroundColor = style.shareControllerShareButtonColor
        
        if self.imageViewWidthConstraint != nil {
            self.imageViewWidthConstraint.constant = maxCollectionWidth
        }
        
        // Analytics
        sendEvent(.openShareController, withProperties: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func shareButtonAction(_ sender: UIButton) {
        
        var items = [Any]()
        items.append(self.image)
        // Make universal Branch Link
        let linkObject = BranchUniversalObject(canonicalIdentifier: self.canonicalIdentifier)
        linkObject.title = Localizations.Share.Link.title
        linkObject.contentDescription = Localizations.Share.description
        
        let linkProperties = BranchLinkProperties()
        linkProperties.feature = self.feature
        linkProperties.channel = self.channel
        
        linkObject.getShortUrl(with: linkProperties) { (link, error) in
            if error != nil && link == nil {
                print(error!.localizedDescription)
            } else {
                items.append(link!)
                items.append("#evaluatedayapp")
            }
            
            // Open share controller
            let shareActivity = UIActivityViewController(activityItems: items, applicationActivities: nil)
            if self.view.traitCollection.userInterfaceIdiom == .pad {
                shareActivity.popoverPresentationController?.sourceRect = self.shareButton.frame
                shareActivity.popoverPresentationController?.sourceView = self.shareButton
            }
            self.shareHandler?()
            self.present(shareActivity, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
