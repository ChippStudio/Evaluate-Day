//
//  LightSlidesControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct LightSlidesControllerTheme: SlidesViewControllerStyle {
    // MARK: - General
    var background: UIColor { return UIColor.snow }
    var pageIndicatorColor: UIColor { return UIColor.lightGray }
    var currentPageIndicatorColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - WelcomeImageNodeStyle
    var welcomeImageNodeTextFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    
    // MARK: - DescriptionNodeStyle
    var descriptionNodeTextColor: UIColor { return UIColor.gunmetal }
    var descriptionNodeTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular)}
    
    // MARK: - WelcomeLastSlideNodeStyle
    var welcomeLastTitleColor: UIColor { return UIColor.gunmetal }
    var welcomeLastTitleFont: UIFont { return UIFont.avenirNext(size: 22.0, weight: .regular) }
    var welcomeLastSubtitleColor: UIColor { return UIColor.gunmetal }
    var welcomeLastSubtitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
}
