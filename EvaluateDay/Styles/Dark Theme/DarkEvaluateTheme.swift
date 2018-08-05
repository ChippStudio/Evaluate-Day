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
    
    var tableNodeSeparatorColor: UIColor { return UIColor.lightGray }
    var actionSheetTintColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - CalendarDateNodeStyle
    var calendarDateColor: UIColor { return UIColor.white }
    var calendarDateFont: UIFont { return UIFont.avenirNext(size: 30.0, weight: .demiBold) }
    var calendarWeekdayColor: UIColor { return UIColor.white }
    var calendarWeekdayFont: UIFont { return UIFont.avenirNext(size: 22.0, weight: .regular) }
    var calendarBackgroundColor: UIColor { return UIColor.gunmetal}
    var calendarSelectedColor: UIColor { return UIColor.darkGreyBlue }
    
    // MARK: - Title Node
    var titleTitleColor: UIColor { return UIColor.white }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var titleSubtitleColor: UIColor { return UIColor.white }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.white }
    
    // MARK: - Color Evaluate node
    var selectedColor: UIColor { return UIColor.salmon }
    
    // MARK: - CriterionEvaluateNodeStyle
    var criterionEvaluateMaximumTrackColor: UIColor { return UIColor.white }
    var criterionEvaluateMinimumPositiveTrackColor: UIColor { return UIColor.pewterBlue }
    var criterionEvaluateMinimumNegativeTrackColor: UIColor { return UIColor.salmon }
    var criterionEvaluateCurrentValueColor: UIColor { return UIColor.white }
    var criterionEvaluateCurrentValueFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    
    // MARK: - CriterionThreeEvaluateNodeStyle
    var criterionThreeEvaluatePositiveColor: UIColor { return UIColor.pewterBlue }
    var criterionThreeEvaluateNeutralColor: UIColor { return UIColor.booger }
    var criterionThreeEvaluateNegativeColor: UIColor { return UIColor.salmon }
    var criterionThreeEvaluateUnsetColor: UIColor { return UIColor.lightGray }
    
    // MARK: - CheckInDataEvaluateNodeStyle
    var checkInDataStreetFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var checkInDataStreetColor: UIColor { return UIColor.white }
    var checkInDataOtherAddressFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var checkInDataOtherAddressColor: UIColor { return UIColor.white }
    var checkInDataCoordinatesFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var checkInDataCoordinatesColor: UIColor { return UIColor.white }
    var checkInDataDotColor: UIColor { return UIColor.pewterBlue }
    var checkInDataMapTintColor: UIColor { return UIColor.white }
    
    // MARK: - CheckInPermissionNodeStyle
    var checkInPermissionDescriptionFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var checkInPermissionDescriptionColor: UIColor { return UIColor.white }
    var checkInPermissionButtonFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInPermissionButtonColor: UIColor { return UIColor.white }
    var checkInPermissionButtonHighlightColor: UIColor { return UIColor.salmon }
    
    // MARK: - CheckInActionNodeStyle
    var checkInActionMapButtonFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInActionMapButtonColor: UIColor { return UIColor.pewterBlue }
    var checkInActionMapButtonHighlightColor: UIColor { return UIColor.salmon }
    var checkInActionCheckInButtonFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInActionCheckInButtonColor: UIColor { return UIColor.pewterBlue }
    var checkInActionCheckInButtonHighlightColor: UIColor { return UIColor.salmon }
    var checkInActionSeparatorColor: UIColor { return UIColor.lightGray }
    
    // MARK: - PhraseEvaluateNodeStyle
    var phraseEvaluateTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var phraseEvaluateTextColor: UIColor { return UIColor.white }
    var phraseEvaluateTintColor: UIColor { return UIColor.white }
    
    // MARK: - CounterEvaluateNodeStyle
    var counterEvaluateCounterFont: UIFont { return UIFont.avenirNext(size: 40.0, weight: .ultraLight) }
    var counterEvaluateCounterColor: UIColor { return UIColor.white }
    var counterEvaluateSumFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var counterEvaluateSumColor: UIColor { return UIColor.white }
    var counterEvaluatePlusColor: UIColor { return UIColor.pewterBlue }
    var counterEvaluatePlusHighlightedColor: UIColor { return UIColor.white }
    var counterEvaluateMinusColor: UIColor { return UIColor.salmon }
    var counterEvaluateMinusHighlightedColor: UIColor { return UIColor.white }
    var counterEvaluateCustomValueFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var counterEvaluateCustomValueColor: UIColor { return UIColor.white }
    var counterEvaluateCustomValueHighlightedColor: UIColor { return UIColor.salmon }
    
    // MARK: - HabitEvaluateNodeStyle
    var evaluateHabitCounterFont: UIFont { return UIFont.avenirNext(size: 46.0, weight: .regular) }
    var evaluateHabitCounterColor: UIColor { return UIColor.white }
    var evaluateHabitButtonsFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var evaluateHabitMarksColor: UIColor { return UIColor.pewterBlue }
    var evaluateHabitDeleteColor: UIColor { return UIColor.salmon }
    var evaluateHabitHighlightedColor: UIColor { return UIColor.white }
    var evaluateHabitSeparatorColor: UIColor { return UIColor.lightGray }
    
    // MARK: - HabitEvaluateCommentNodeStyle
    var habitEvaluateCommentFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var habitEvaluateCommentTintColor: UIColor { return UIColor.white }
    
    // MARK: - ListEvaluateNodeStyle
    var listEvaluateViewButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var listEvaluateViewButtonColor: UIColor { return UIColor.white }
    var listEvaluateViewButtonHighlightedColor: UIColor { return UIColor.pewterBlue }
    var listEvaluateDayDoneFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .regular) }
    var listEvaluateDayDoneColor: UIColor { return UIColor.white }
    var listEvaluateAllDoneFont: UIFont { return UIFont.avenirNext(size: 25.0, weight: .regular) }
    var listEvaluateAllDoneColor: UIColor { return UIColor.white }
    
    // MARK: - ListItemEvaluateNodeStyle
    var listItemTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var listItemTextColor: UIColor { return UIColor.white }
    var listItemTintColor: UIColor { return UIColor.white }
    
    // MARK: - GoalEvaluateNodeStyle
    var goalEvaluateCounterFont: UIFont { return UIFont.avenirNext(size: 40.0, weight: .ultraLight) }
    var goalEvaluateCounterColor: UIColor { return UIColor.white }
    var goalEvaluateSumFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var goalEvaluateSumColor: UIColor { return UIColor.white }
    var goalEvaluatePlusColor: UIColor { return UIColor.pewterBlue }
    var goalEvaluatePlusHighlightedColor: UIColor { return UIColor.white }
    var goalEvaluateMinusColor: UIColor { return UIColor.salmon }
    var goalEvaluateMinusHighlightedColor: UIColor { return UIColor.white }
    var goalEvaluateCustomValueFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var goalEvaluateCustomValueColor: UIColor { return UIColor.white }
    var goalEvaluateCustomValueHighlightedColor: UIColor { return UIColor.salmon }
    
    // MARK: - JournalNewEntryActionNodeStyle
    var journalNewEntryActionButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var journalNewEntryActionButtonColor: UIColor { return UIColor.white }
    var journalNewEntryActionButtonHighlightedColor: UIColor { return UIColor.salmon }
    var journalNewEntryActionTintColor: UIColor { return UIColor.white }
    
    // MARK: - JournalEntryNodeStyle
    var journalNodeTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var journalNodeTextColor: UIColor { return UIColor.white }
    var journalNodeMetadataFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var journalNodeMetadataColor: UIColor { return UIColor.white }
    
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
    var cardListEmptyNewFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var cardListEmptyNewTintColor: UIColor { return UIColor.white }
    var cardListEmptyNewTintHighlightedColor: UIColor { return UIColor.salmon }
    var cardListEmptyNewBackgroundColor: UIColor { return UIColor.gunmetal }
    
    // Action Node
    var actionDeleteTintColor: UIColor { return UIColor.salmon }
    var actionEditTintColor: UIColor { return UIColor.white }
    var actionMergeTintColor: UIColor { return UIColor.white }
    var actionDividerColor: UIColor { return UIColor.darkGreyBlue }
    
    // UnarchiveNodeStyle
    var unarchiveButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular)}
    var unarchiveButtonColor: UIColor { return UIColor.pewterBlue }
    var unarchiveDividerColor: UIColor { return UIColor.darkGreyBlue }
    
    // MARK: - AnalyticsNodeStyle
    var analyticsNodeTextColor: UIColor { return UIColor.white }
    var analyticsNodeTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var analyticsNodeTintColor: UIColor { return UIColor.snow }
    
    // MARK: - FutureNodeStyle
    var presentFutureQuoteFont: UIFont { return UIFont.avenirNext(size: 26.0, weight: .medium) }
    var presentFutureQuoteColor: UIColor { return UIColor.white }
    var presentFutureAuthorFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .demiBold) }
    var presentFutureAuthorColor: UIColor { return UIColor.white }
    var presentFutureShareFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var presentFutureShareTintColor: UIColor { return UIColor.white }
    var presentFutureShareTintHighlightedColor: UIColor { return UIColor.salmon }
    var presentFutureShareBackgroundColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - HabitNegativeNodeStyle
    var habitNegativeDescriptionFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var habitNegativeDescriptionColor: UIColor { return UIColor.white }
    var habitNegativeCoverColor: UIColor { return UIColor.salmon }
    var habitNegativeCoverAlpha: CGFloat { return 0.1 }
}
