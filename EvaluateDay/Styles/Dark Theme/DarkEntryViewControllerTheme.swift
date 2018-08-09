//
//  DarkEntryViewControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct DarkEntryViewControllerTheme: EntryViewControllerStyle {
    // MARK: - General controller
    var background: UIColor { return UIColor.charcoal }
    var barColor: UIColor { return UIColor.charcoal }
    var barTint: UIColor { return UIColor.white }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var tableNodeSeparatorColor: UIColor { return UIColor.lightGray }
    var tableSectionHeaderColor: UIColor { return UIColor.white }
    var tableSectionHeaderFont: UIFont { return UIFont.avenirNext(size: 15.0, weight: .medium) }
    
    // MARK: - TextNode
    var textNodeFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .regular) }
    var textNodeTextColor: UIColor { return UIColor.white }
    var textNodePlaceholderTextColor: UIColor { return UIColor.lightGray }
    
    // MARK: - ActionNodeStyle
    var actionDeleteTintColor: UIColor { return UIColor.salmon }
    var actionEditTintColor: UIColor { return UIColor.white }
    var actionMergeTintColor: UIColor { return UIColor.white }
    var actionDividerColor: UIColor { return UIColor.darkGreyBlue }
    
    // MARK: - DateNodeStyle
    var dateNodeFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .medium) }
    var dateFontColor: UIColor { return UIColor.white }
    var dateNodeSeparatorColor: UIColor { return UIColor.white }
    
    // MARK: - CheckInActionNodeStyle
    var checkInActionMapButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var checkInActionMapButtonColor: UIColor { return UIColor.pewterBlue }
    var checkInActionMapButtonHighlightColor: UIColor { return UIColor.white }
    var checkInActionCheckInButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var checkInActionCheckInButtonColor: UIColor { return UIColor.pewterBlue }
    var checkInActionCheckInButtonHighlightColor: UIColor { return UIColor.white }
    var checkInActionSeparatorColor: UIColor { return UIColor.white }
    var checkInActionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInActionDateColor: UIColor { return UIColor.white }
    
    // MARK: - CheckInPermissionNodeStyle
    var checkInPermissionDescriptionFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInPermissionDescriptionColor: UIColor { return UIColor.white }
    var checkInPermissionButtonFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var checkInPermissionButtonColor: UIColor { return UIColor.pewterBlue }
    var checkInPermissionButtonHighlightColor: UIColor { return UIColor.white }
    var checkInPermissionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInPermissionDateColor: UIColor { return UIColor.white}
    
    // MARK: - CheckInDataEvaluateNodeStyle
    var checkInDataStreetFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .bold) }
    var checkInDataStreetColor: UIColor { return UIColor.white }
    var checkInDataOtherAddressFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInDataOtherAddressColor: UIColor { return UIColor.white }
    var checkInDataCoordinatesFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var checkInDataCoordinatesColor: UIColor { return UIColor.white }
    var checkInDataDotColor: UIColor { return UIColor.pewterBlue }
    var checkInDataSeparatorColor: UIColor { return UIColor.white }
    
    // MARK: - WeatherNodeStyle
    var weatherNodeTintColor: UIColor { return UIColor.white }
    var weatherNodeDataTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .demiBold) }
    var weatherNodeTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var weatherNodeTextColor: UIColor { return UIColor.white }
    
    // MARK: - JournalEntryNodeStyle
    var journalNodeTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var journalNodeTextColor: UIColor { return UIColor.white }
    var journalNodeMetadataFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var journalNodeMetadataColor: UIColor { return UIColor.white }
    var journalNodeTextCoverColor: UIColor { return UIColor.gunmetal }
    var journalNodeImagePlaceHolderTintColor: UIColor { return UIColor.white }
}
