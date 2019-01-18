//
//  CollectionsListCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class CollectionsListCell: UITableViewCell {
    
    // MARK: - UI
    @IBOutlet weak var collectionImage: UIImageView!
    @IBOutlet weak var collectionTitle: UILabel!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.tint
        selectedView.layer.cornerRadius = 10.0
        
        self.selectedBackgroundView = selectedView
        
        // Initialization code
        self.collectionImage.layer.cornerRadius = 10.0
        self.collectionImage.layer.masksToBounds = true
        self.collectionTitle.textColor = UIColor.main
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
