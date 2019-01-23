//
//  OnChatAnimationCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 22/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class OnChatLoadCell: UITableViewCell {

    var icon = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.icon.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.icon)
        let topConstraintIcon = NSLayoutConstraint(item: self.icon, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 5.0)
        let bottomConstraintIcon = NSLayoutConstraint(item: self.icon, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: -5.0)
        let leadingConstraintIcon = NSLayoutConstraint(item: self.icon, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1.0, constant: 20.0)
        let heightConstrainIcon = NSLayoutConstraint(item: self.icon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        let widthConstrainIcon = NSLayoutConstraint(item: self.icon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0)
        
        self.icon.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([topConstraintIcon, bottomConstraintIcon, leadingConstraintIcon, heightConstrainIcon, widthConstrainIcon])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
