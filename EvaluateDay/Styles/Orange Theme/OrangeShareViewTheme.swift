//
//  DarkShareViewTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct OrangeShareViewTheme: ShareViewStyle {
    var shareViewBackgroundColor: UIColor { return UIColor.snow }
    var shareViewTitleColor: UIColor { return UIColor.gunmetal }
    var shareViewLinkColor: UIColor { return UIColor.gunmetal }
    var shareViewTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var shareViewLinkFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var shareViewIconImage: UIImage { return #imageLiteral(resourceName: "appIcon1024") }
    
    var shareControllerBackground: UIColor { return UIColor.squash }
    var shareControllerCloseTintColor: UIColor { return UIColor.paleGrey }
    var shareControllerShareButtonColor: UIColor { return UIColor.pumpkin }
    var shareControllerShareButtonTextColor: UIColor { return UIColor.white }
    var shareControllerShareButtonTextHighlightedColor: UIColor { return UIColor.brownishRed }
    var shareControllerShareButtonTextFont: UIFont { return UIFont.avenirNext(size: 22.0, weight: .bold) }
}
