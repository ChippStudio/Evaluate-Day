//
//  AnalyticsPreviewViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 20/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

@objc protocol AnalyticsPreviewDelegate {
    func analyticsPreview(controller: AnalyticsPreviewViewController, didSelect action: UIPreviewAction, for previewedController: UIViewController)
}
class AnalyticsPreviewViewController: UIViewController {

    // MARK: - UI
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardSubtitleLabel: UILabel!
    
    @IBOutlet weak var cover: UIView!
    
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var collectionTitle: UILabel!
    
    // MARK: - Variables
    var card: Card!
    weak var delegate: AnalyticsPreviewDelegate?
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set data
        self.cardImageView.image = Sources.image(forType: self.card.type).withRenderingMode(.alwaysTemplate)
        self.cardTitleLabel.text = self.card.title
        self.cardSubtitleLabel.text = self.card.subtitle
        
        self.collectionImageView.image = nil
        self.collectionTitle.text = nil
        
        if self.card.dashboard != nil {
            if let collection = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@ AND id=%@", false, self.card.dashboard!).first {
                self.collectionImageView.image = UIImage(named: collection.image)
                if collection.title.isEmpty {
                    self.collectionTitle.text = Localizations.Collection.Edit.titlePlaceholder
                } else {
                    self.collectionTitle.text = collection.title
                }
            }
        }
        
        // Set appearance
        self.cardImageView.tintColor = UIColor.main
        self.cardTitleLabel.textColor = UIColor.text
        self.cardSubtitleLabel.textColor = UIColor.text
        
        self.collectionTitle.textColor = UIColor.main
        self.collectionImageView.layer.cornerRadius = 50/2
        self.collectionImageView.layer.masksToBounds = true
        
        self.cover.backgroundColor = UIColor.tint
        self.cover.layer.cornerRadius = 10.0
        
        self.view.backgroundColor = UIColor.background
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        let editAction = UIPreviewAction(title: Localizations.General.edit, style: .default) { (action, controller) in
            self.delegate?.analyticsPreview(controller: self, didSelect: action, for: controller)
        }
        let archiveTitle = self.card.archived ? Localizations.General.unarchive : Localizations.General.archive
        let archiveAction = UIPreviewAction(title: archiveTitle, style: .destructive) { (action, controller) in
            self.delegate?.analyticsPreview(controller: self, didSelect: action, for: controller)
        }
        let mergeAction = UIPreviewAction(title: Localizations.CardMerge.action, style: .default) { (action, controller) in
            self.delegate?.analyticsPreview(controller: self, didSelect: action, for: controller)
        }
        let analyticsAction = UIPreviewAction(title: Localizations.General.Action.analytics, style: .default) { (action, controller) in
            self.delegate?.analyticsPreview(controller: self, didSelect: action, for: controller)
        }
        
        return [analyticsAction, editAction, mergeAction, archiveAction]
    }
}
