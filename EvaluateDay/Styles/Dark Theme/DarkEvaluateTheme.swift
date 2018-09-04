//
//  DarkEvaluateTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 08/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct DarkEvaluateTheme: EvaluableStyle {
    // MARK: - General controller
    var background: UIColor { return UIColor.charcoal }
    var statusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.lightContent }
    var cardColor: UIColor { return UIColor.gunmetal }
    var cardShadowColor: UIColor { return UIColor.darkGreyBlue }
    var barColor: UIColor { return UIColor.charcoal }
    var barTint: UIColor { return UIColor.white }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var cardArchiveColor: UIColor { return UIColor.charcoal }
    
    var tableNodeSeparatorColor: UIColor { return UIColor.lightGray }
    var actionSheetTintColor: UIColor { return UIColor.gunmetal }
    
    var imageInfoDateLabelFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .bold) }
    var imageInfoCoordinatesFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var imageInfoPlaceFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - Title Node
    var titleTitleColor: UIColor { return UIColor.white }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var titleSubtitleColor: UIColor { return UIColor.white }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.white }
    var titleDashboardFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .medium) }
    var titleDashboardColor: UIColor { return UIColor.white }
    
    // MARK: - Color Evaluate node
    var selectedColor: UIColor { return UIColor.salmon }
    var selectedColorDateColor: UIColor { return UIColor.white }
    var selectedColorDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - CriterionEvaluateNodeStyle
    var criterionEvaluateMaximumTrackColor: UIColor { return UIColor.white }
    var criterionEvaluateMinimumPositiveTrackColor: UIColor { return UIColor.pewterBlue }
    var criterionEvaluateMinimumNegativeTrackColor: UIColor { return UIColor.salmon }
    var criterionEvaluateCurrentValueFont: UIFont { return UIFont.avenirNext(size: 48.0, weight: .demiBold) }
    var criterionEvaluateDateColor: UIColor {return UIColor.white }
    var criterionEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var criterionEvaluatePreviousValueColor: UIColor { return UIColor.white }
    var criterionEvaluatePreviousValueFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .medium) }
    var criterionEvaluatePersentColor: UIColor { return UIColor.white }
    var criterionEvaluatePersentFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .regular) }
    var criterionEvaluateSeparatorColor: UIColor { return UIColor.white }
    
    // MARK: - CriterionThreeEvaluateNodeStyle
    var criterionThreeEvaluatePositiveColor: UIColor { return UIColor.pewterBlue }
    var criterionThreeEvaluateNeutralColor: UIColor { return UIColor.booger }
    var criterionThreeEvaluateNegativeColor: UIColor { return UIColor.salmon }
    var criterionThreeEvaluateUnsetColor: UIColor { return UIColor.lightGray }
    var criterionThreeEvaluateSeparatorColor: UIColor { return UIColor.white }
    var criterionThreeEvaluateDateColor: UIColor { return UIColor.white }
    var criterionThreeEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - CheckInDataEvaluateNodeStyle
    var checkInDataStreetFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .bold) }
    var checkInDataStreetColor: UIColor { return UIColor.white }
    var checkInDataOtherAddressFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInDataOtherAddressColor: UIColor { return UIColor.white }
    var checkInDataCoordinatesFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var checkInDataCoordinatesColor: UIColor { return UIColor.white }
    var checkInDataDotColor: UIColor { return UIColor.pewterBlue }
    var checkInDataSeparatorColor: UIColor { return UIColor.white }
    
    // MARK: - CheckInPermissionNodeStyle
    var checkInPermissionDescriptionFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var checkInPermissionDescriptionColor: UIColor { return UIColor.white }
    var checkInPermissionButtonFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInPermissionButtonColor: UIColor { return UIColor.white }
    var checkInPermissionButtonHighlightColor: UIColor { return UIColor.salmon }
    var checkInPermissionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInPermissionDateColor: UIColor { return UIColor.white }
    
    // MARK: - CheckInActionNodeStyle
    var checkInActionMapButtonFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var checkInActionMapButtonColor: UIColor { return UIColor.pewterBlue }
    var checkInActionMapButtonHighlightColor: UIColor { return UIColor.salmon }
    var checkInActionCheckInButtonFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var checkInActionCheckInButtonColor: UIColor { return UIColor.pewterBlue }
    var checkInActionCheckInButtonHighlightColor: UIColor { return UIColor.salmon }
    var checkInActionSeparatorColor: UIColor { return UIColor.white }
    var checkInActionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInActionDateColor: UIColor { return UIColor.white }
    
    // MARK: - PhraseEvaluateNodeStyle
    var phraseEvaluateTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .medium) }
    var phraseEvaluateTextColor: UIColor { return UIColor.white }
    var phraseEvaluateButtonColor: UIColor { return UIColor.white }
    var phraseEvaluateButtonTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var phraseEvaluateDateColor: UIColor { return UIColor.white }
    var phraseEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - CounterEvaluateNodeStyle
    var counterEvaluateCounterFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .demiBold) }
    var counterEvaluateCounterColor: UIColor { return UIColor.white }
    var counterEvaluateSumFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .medium) }
    var counterEvaluateSumColor: UIColor { return UIColor.white }
    var counterEvaluatePlusColor: UIColor { return UIColor.pewterBlue }
    var counterEvaluatePlusHighlightedColor: UIColor { return UIColor.white }
    var counterEvaluateMinusColor: UIColor { return UIColor.salmon }
    var counterEvaluateMinusHighlightedColor: UIColor { return UIColor.white }
    var counterEvaluateCustomValueFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var counterEvaluateCustomValueColor: UIColor { return UIColor.white }
    var counterEvaluateCustomValueHighlightedColor: UIColor { return UIColor.salmon }
    var counterEvaluateDateColor: UIColor { return UIColor.white }
    var counterEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var counterEvaluatePreviousValueFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .medium)}
    var counterEvaluatePreviousValueColor: UIColor { return UIColor.white }
    var counterEvaluateSeparatorColor: UIColor { return UIColor.white }
    
    // MARK: - HabitEvaluateNodeStyle
    var evaluateHabitCounterFont: UIFont { return UIFont.avenirNext(size: 48.0, weight: .demiBold) }
    var evaluateHabitCounterColor: UIColor { return UIColor.white }
    var evaluateHabitButtonsFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .bold) }
    var evaluateHabitMarksColor: UIColor { return UIColor.pewterBlue }
    var evaluateHabitDeleteColor: UIColor { return UIColor.salmon }
    var evaluateHabitHighlightedColor: UIColor { return UIColor.white }
    var evaluateHabitSeparatorColor: UIColor { return UIColor.lightGray }
    var evaluateHabitDateColor: UIColor { return UIColor.white }
    var evaluateHabitDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var evaluateHabitPreviousCountColor: UIColor { return UIColor.white }
    var evaluateHabitPreviousCountFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .demiBold) }
    
    // MARK: - HabitEvaluateCommentNodeStyle
    var habitEvaluateCommentFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var habitEvaluateCommentTintColor: UIColor { return UIColor.white }
    
    // MARK: - HabitNegativeNodeStyle
    var habitNegativeDescriptionFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .demiBold) }
    var habitNegativeDescriptionColor: UIColor { return UIColor.white }
    var habitNegativeCoverColor: UIColor { return UIColor.salmon }
    var habitNegativeCoverAlpha: CGFloat { return 0.8 }
    
    // MARK: - ListEvaluateNodeStyle
    var listEvaluateViewButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .bold) }
    var listEvaluateViewButtonColor: UIColor { return UIColor.white }
    var listEvaluateViewButtonHighlightedColor: UIColor { return UIColor.pewterBlue }
    var listEvaluateDayDoneFont: UIFont { return UIFont.avenirNext(size: 30.0, weight: .demiBold) }
    var listEvaluateDayDoneColor: UIColor { return UIColor.white }
    var listEvaluateAllDoneFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var listEvaluateAllDoneColor: UIColor { return UIColor.white }
    var listEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var listEvaluateDateColor: UIColor { return UIColor.white }
    var listEvaluateSeparatorColor: UIColor { return UIColor.white }
    
    // MARK: - ListItemEvaluateNodeStyle
    var listItemTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var listItemTextColor: UIColor { return UIColor.white }
    var listItemTintColor: UIColor { return UIColor.white }
    
    // MARK: - GoalEvaluateNodeStyle
    var goalEvaluateCounterFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .demiBold) }
    var goalEvaluateCounterColor: UIColor { return UIColor.white }
    var goalEvaluateSumFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .medium) }
    var goalEvaluateSumColor: UIColor { return UIColor.white }
    var goalEvaluatePlusColor: UIColor { return UIColor.pewterBlue }
    var goalEvaluatePlusHighlightedColor: UIColor { return UIColor.white }
    var goalEvaluateMinusColor: UIColor { return UIColor.salmon }
    var goalEvaluateMinusHighlightedColor: UIColor { return UIColor.white }
    var goalEvaluateCustomValueFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var goalEvaluateCustomValueColor: UIColor { return UIColor.white }
    var goalEvaluateCustomValueHighlightedColor: UIColor { return UIColor.salmon }
    var goalEvaluateGoalFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .medium) }
    var goalEvaluateGoalColor: UIColor { return UIColor.white }
    var goalEvaluateDateColor: UIColor { return UIColor.white }
    var goalEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var goalEvaluatePreviousValueFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .medium)}
    var goalEvaluatePreviousValueColor: UIColor { return UIColor.white }
    var goalEvaluateSeparatorColor: UIColor { return UIColor.white }
    
    // MARK: - JournalNewEntryActionNodeStyle
    var journalNewEntryActionButtonFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var journalNewEntryActionButtonColor: UIColor { return UIColor.white }
    var journalNewEntryActionButtonHighlightedColor: UIColor { return UIColor.salmon }
    var journalNewEntryActionTintColor: UIColor { return UIColor.white }
    var journalNewEntryActionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var journalNewEntryActionDateColor: UIColor { return UIColor.white }
    
    // MARK: - JournalEntryNodeStyle
    var journalNodeTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var journalNodeTextColor: UIColor { return UIColor.white }
    var journalNodeMetadataFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var journalNodeMetadataColor: UIColor { return UIColor.white }
    var journalNodeTextCoverColor: UIColor { return UIColor.gunmetal }
    var journalNodeImagePlaceHolderTintColor: UIColor { return UIColor.white }
    
    // MARK: - UpdateNodeStyle
    var updateTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var updateTitleColor: UIColor { return UIColor.white }
    var updateSubtitleColor: UIColor { return UIColor.white }
    var updateSubtitleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var updateButtonBorderColor: UIColor { return UIColor.salmon }
    var updateButtonFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var updateButtonColor: UIColor { return UIColor.salmon }
    
    // MARK: - CardListEmptyViewStyle
    var cardListEmptyTitleFont: UIFont { return UIFont.avenirNext(size: 30.0, weight: .bold) }
    var cardListEmptyTitleColor: UIColor { return UIColor.white }
    var cardListEmptyDescriptionFont: UIFont { return UIFont.avenirNext(size: 22.0, weight: .regular) }
    var cardListEmptyDescriptionColor: UIColor { return UIColor.white }
    var cardListEmptyNewFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var cardListEmptyNewTintColor: UIColor { return UIColor.white }
    var cardListEmptyNewTintHighlightedColor: UIColor { return UIColor.salmon }
    var cardListEmptyNewBackgroundColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - DashboardsNodeStyle
    var dashboardsNodeTitleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var dashboardsNodeTitleColor: UIColor { return UIColor.white }
    var dashboardsNodeNewColor: UIColor { return UIColor.white }
    var dashboardsNodeNewBorderColor: UIColor { return UIColor.gunmetal }
    var dashboardsNodeCountColor: UIColor { return UIColor.salmon }
    var dashboardsNodeCountTextColor: UIColor { return UIColor.white }
    var dashboardsNodeCountTextFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .demiBold) }
}
