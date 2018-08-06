//
//  DarkEntryViewControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct OrangeEntryViewControllerTheme: EntryViewControllerStyle {
    // MARK: - General controller
    var background: UIColor { return UIColor.squash }
    var barColor: UIColor { return UIColor.squash }
    var barTint: UIColor { return UIColor.paleGrey }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    
    var tableNodeSeparatorColor: UIColor { return UIColor.white }
    
    // MARK: - TextNode
    var textNodeFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .regular) }
    var textNodeTextColor: UIColor { return UIColor.paleGrey }
    var textNodePlaceholderTextColor: UIColor { return UIColor.white }
    
    // MARK: - ActionNodeStyle
    var actionDeleteTintColor: UIColor { return UIColor.grapePurple }
    var actionEditTintColor: UIColor { return UIColor.paleGrey }
    var actionMergeTintColor: UIColor { return UIColor.paleGrey }
    var actionDividerColor: UIColor { return UIColor.darkBlueGreen }
    
    // MARK: - DateNodeStyle
    var dateNodeFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var dateFontColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - CheckInActionNodeStyle
    var checkInActionMapButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var checkInActionMapButtonColor: UIColor { return UIColor.darkBlueGreen }
    var checkInActionMapButtonHighlightColor: UIColor { return UIColor.paleGrey }
    var checkInActionCheckInButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var checkInActionCheckInButtonColor: UIColor { return UIColor.darkBlueGreen }
    var checkInActionCheckInButtonHighlightColor: UIColor { return UIColor.paleGrey }
    var checkInActionSeparatorColor: UIColor { return UIColor.paleGrey }
    var checkInActionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInActionDateColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - CheckInPermissionNodeStyle
    var checkInPermissionDescriptionFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInPermissionDescriptionColor: UIColor { return UIColor.paleGrey }
    var checkInPermissionButtonFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var checkInPermissionButtonColor: UIColor { return UIColor.darkBlueGreen }
    var checkInPermissionButtonHighlightColor: UIColor { return UIColor.paleGrey }
    var checkInPermissionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInPermissionDateColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - CheckInDataEvaluateNodeStyle
    var checkInDataStreetFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .bold) }
    var checkInDataStreetColor: UIColor { return UIColor.paleGrey }
    var checkInDataOtherAddressFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInDataOtherAddressColor: UIColor { return UIColor.paleGrey }
    var checkInDataCoordinatesFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var checkInDataCoordinatesColor: UIColor { return UIColor.paleGrey }
    var checkInDataDotColor: UIColor { return UIColor.darkBlueGreen }
    var checkInDataSeparatorColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - WeatherNodeStyle
    var weatherNodeTintColor: UIColor { return UIColor.paleGrey }
    var weatherNodeDataTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .demiBold) }
    var weatherNodeTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var weatherNodeTextColor: UIColor { return UIColor.paleGrey }
}
