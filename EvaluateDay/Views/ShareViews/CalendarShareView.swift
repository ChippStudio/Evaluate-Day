//
//  CalendarShareView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 21/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

protocol CalendarShareViewStyle {
    var presentFutureQuoteFont: UIFont { get }
    var presentFutureQuoteColor: UIColor { get }
    var presentFutureAuthorFont: UIFont { get }
    var presentFutureAuthorColor: UIColor { get }
}

class CalendarShareView: UIView {
    // MARK: - UI
    var quote = UILabel()
    var author = UILabel()
    
    // MARK: - Init
    init(message: String, author: String) {
        super.init(frame: CGRect.zero)
        
        let style = Themes.manager.shareViewStyle
        self.backgroundColor = style.cardShareBackground
        
        self.quote.text = message
        self.quote.numberOfLines = 0
        self.quote.textAlignment = .left
        self.quote.textColor = style.presentFutureQuoteColor
        self.quote.font = style.presentFutureQuoteFont
        self.addSubview(self.quote)
        self.quote.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30.0)
            make.trailing.equalToSuperview().offset(-20.0).priority(751.0)
            make.leading.equalToSuperview().offset(20.0)
            make.width.equalTo(280.0)
        }
        
        self.author.text = author
        self.author.numberOfLines = 1
        self.author.textAlignment = .right
        self.author.textColor = style.presentFutureAuthorColor
        self.author.font = style.presentFutureAuthorFont
        self.addSubview(self.author)
        self.author.snp.makeConstraints { (make) in
            make.top.equalTo(self.quote.snp.bottom).offset(10.0)
            make.trailing.equalToSuperview().offset(-20.0).priority(750.0)
            make.leading.equalToSuperview().offset(20.0)
            make.bottom.equalToSuperview().offset(-10.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
