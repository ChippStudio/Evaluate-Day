//
//  OnChatAnswerCell.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 22/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class OnChatAnswerCell: UITableViewCell, OnChatBubbleCell {
    
    var titleLabel: UILabel = UILabel()
    var cover: UIView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.titleLabel.textColor = UIColor.gray
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.titleLabel.numberOfLines = 0
        
        self.cover.layer.cornerRadius = 20.0
        self.cover.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(self.cover)
        let topConstraintCover = NSLayoutConstraint(item: self.cover, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 5.0)
        let bottomConstraintCover = NSLayoutConstraint(item: self.cover, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: -5.0)
        let leadingConstraintCover = NSLayoutConstraint(item: self.cover, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: self.contentView, attribute: .leading, multiplier: 1.0, constant: 60.0)
        let trailingConstraintCover = NSLayoutConstraint(item: self.cover, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1.0, constant: -20.0)
        
        self.cover.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([topConstraintCover, bottomConstraintCover, trailingConstraintCover, leadingConstraintCover])
        
        self.cover.addSubview(self.titleLabel)
        let topConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: .top, relatedBy: .equal, toItem: self.cover, attribute: .top, multiplier: 1.0, constant: 10.0)
        let bottomConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self.cover, attribute: .bottom, multiplier: 1.0, constant: -10.0)
        let leadingConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.cover, attribute: .leading, multiplier: 1.0, constant: 15.0)
        let trailingConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self.cover, attribute: .trailing, multiplier: 1.0, constant: -15.0)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
