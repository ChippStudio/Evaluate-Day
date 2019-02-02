//
//  GalleryCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/02/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    // MARK: - UI
    @IBOutlet weak var photoView: UIImageView!
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.photoView.layer.cornerRadius = 10.0
    }
    
}
