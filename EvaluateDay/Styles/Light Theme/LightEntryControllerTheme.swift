//
//  LightEntryControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct LightEntryViewControllerTheme: EntryViewControllerStyle {
    
    // MARK: - General controller
    var background: UIColor { return UIColor.snow }
    var barColor: UIColor { return UIColor.snow }
    var barTint: UIColor { return UIColor.viridian }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    
    var tableNodeSeparatorColor: UIColor { return UIColor.lightGray }
    
    // MARK: - TextNode
    var textNodeFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .regular) }
    var textNodeTextColor: UIColor { return UIColor.gunmetal }
    var textNodePlaceholderTextColor: UIColor { return UIColor.lightGray }
    
    // MARK: - ActionNodeStyle
    var actionDeleteTintColor: UIColor { return UIColor.brownishRed }
    var actionEditTintColor: UIColor { return UIColor.gunmetal }
    var actionMergeTintColor: UIColor { return UIColor.gunmetal }
    var actionDividerColor: UIColor { return UIColor.platinum }
    
    // MARK: - DateNodeStyle
    var dateNodeFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var dateFontColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - CheckInActionNodeStyle
    var checkInActionMapButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var checkInActionMapButtonColor: UIColor { return UIColor.viridian }
    var checkInActionMapButtonHighlightColor: UIColor { return UIColor.gunmetal }
    var checkInActionCheckInButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var checkInActionCheckInButtonColor: UIColor { return UIColor.viridian }
    var checkInActionCheckInButtonHighlightColor: UIColor { return UIColor.gunmetal }
    var checkInActionSeparatorColor: UIColor { return UIColor.gunmetal }
    var checkInActionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInActionDateColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - CheckInPermissionNodeStyle
    var checkInPermissionDescriptionFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInPermissionDescriptionColor: UIColor { return UIColor.gunmetal }
    var checkInPermissionButtonFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var checkInPermissionButtonColor: UIColor { return UIColor.viridian }
    var checkInPermissionButtonHighlightColor: UIColor { return UIColor.gunmetal }
    var checkInPermissionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInPermissionDateColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - CheckInDataEvaluateNodeStyle
    var checkInDataStreetFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var checkInDataStreetColor: UIColor { return UIColor.gunmetal }
    var checkInDataOtherAddressFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var checkInDataOtherAddressColor: UIColor { return UIColor.gunmetal }
    var checkInDataCoordinatesFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var checkInDataCoordinatesColor: UIColor { return UIColor.gunmetal }
    var checkInDataSeparatorColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - WeatherNodeStyle
    var weatherNodeTintColor: UIColor { return UIColor.gunmetal }
    var weatherNodeDataTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .demiBold) }
    var weatherNodeTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var weatherNodeTextColor: UIColor { return UIColor.gunmetal }
}
