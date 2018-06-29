//
//  BlackSlidesControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct BlackSlidesControllerTheme: SlidesViewControllerStyle {
    // MARK: - General
    var background: UIColor { return UIColor.black }
    var pageIndicatorColor: UIColor { return UIColor.lightGray }
    var currentPageIndicatorColor: UIColor { return UIColor.white }
    
    // MARK: - WelcomeImageNodeStyle
    var welcomeImageNodeTextFont: UIFont { return UIFont.avenirNext(size: 22.0, weight: .bold) }
    
    // MARK: - DescriptionNodeStyle
    var descriptionNodeTextColor: UIColor { return UIColor.smokyBlack }
    var descriptionNodeTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular)}
    
    // MARK: - WelcomeLastSlideNodeStyle
    var welcomeLastTitleColor: UIColor { return UIColor.white }
    var welcomeLastTitleFont: UIFont { return UIFont.avenirNext(size: 22.0, weight: .regular) }
    var welcomeLastSubtitleColor: UIColor { return UIColor.white }
    var welcomeLastSubtitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
}
