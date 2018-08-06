//
//  LightEvaluateTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 08/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct LightEvaluateTheme: EvaluableStyle {
    // MARK: - General controller
    var background: UIColor { return UIColor.snow }
    var statusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.default }
    var cardColor: UIColor { return UIColor.white }
    var cardShadowColor: UIColor { return UIColor.gunmetal}
    var barColor: UIColor { return UIColor.snow }
    var barTint: UIColor { return UIColor.viridian }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    
    var tableNodeSeparatorColor: UIColor { return UIColor.lightGray }
    var actionSheetTintColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - Title Node
    var titleTitleColor: UIColor { return UIColor.gunmetal }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var titleSubtitleColor: UIColor { return UIColor.gunmetal }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - Color Evaluate node
    var selectedColor: UIColor { return UIColor.brownishRed }
    var selectedColorDateColor: UIColor { return UIColor.gunmetal }
    var selectedColorDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - CriterionEvaluateNodeStyle
    var criterionEvaluateMaximumTrackColor: UIColor { return UIColor.gunmetal }
    var criterionEvaluateMinimumPositiveTrackColor: UIColor { return UIColor.viridian }
    var criterionEvaluateMinimumNegativeTrackColor: UIColor { return UIColor.brownishRed }
    var criterionEvaluateCurrentValueFont: UIFont { return UIFont.avenirNext(size: 48.0, weight: .demiBold) }
    var criterionEvaluateDateColor: UIColor {return UIColor.gunmetal }
    var criterionEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var criterionEvaluatePreviousValueColor: UIColor { return UIColor.gunmetal }
    var criterionEvaluatePreviousValueFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .medium) }
    var criterionEvaluatePersentColor: UIColor { return UIColor.gunmetal }
    var criterionEvaluatePersentFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .regular) }
    var criterionEvaluateSeparatorColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - CriterionThreeEvaluateNodeStyle
    var criterionThreeEvaluatePositiveColor: UIColor { return UIColor.viridian }
    var criterionThreeEvaluateNeutralColor: UIColor { return UIColor.booger }
    var criterionThreeEvaluateNegativeColor: UIColor { return UIColor.brownishRed }
    var criterionThreeEvaluateUnsetColor: UIColor { return UIColor.lightGray }
    var criterionThreeEvaluateSeparatorColor: UIColor { return UIColor.gunmetal }
    var criterionThreeEvaluateDateColor: UIColor { return UIColor.gunmetal }
    var criterionThreeEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - CheckInDataEvaluateNodeStyle
    var checkInDataStreetFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .bold) }
    var checkInDataStreetColor: UIColor { return UIColor.gunmetal }
    var checkInDataOtherAddressFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInDataOtherAddressColor: UIColor { return UIColor.gunmetal }
    var checkInDataCoordinatesFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var checkInDataCoordinatesColor: UIColor { return UIColor.gunmetal }
    var checkInDataSeparatorColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - CheckInPermissionNodeStyle
    var checkInPermissionDescriptionFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var checkInPermissionDescriptionColor: UIColor { return UIColor.gunmetal }
    var checkInPermissionButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .bold) }
    var checkInPermissionButtonColor: UIColor { return UIColor.viridian }
    var checkInPermissionButtonHighlightColor: UIColor { return UIColor.brownishRed }
    var checkInPermissionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInPermissionDateColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - CheckInActionNodeStyle
    var checkInActionMapButtonFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var checkInActionMapButtonColor: UIColor { return UIColor.viridian }
    var checkInActionMapButtonHighlightColor: UIColor { return UIColor.brownishRed }
    var checkInActionCheckInButtonFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var checkInActionCheckInButtonColor: UIColor { return UIColor.viridian }
    var checkInActionCheckInButtonHighlightColor: UIColor { return UIColor.brownishRed }
    var checkInActionSeparatorColor: UIColor { return UIColor.gunmetal }
    var checkInActionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInActionDateColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - PhraseEvaluateNodeStyle
    var phraseEvaluateTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .medium) }
    var phraseEvaluateTextColor: UIColor { return UIColor.gunmetal }
    var phraseEvaluateButtonColor: UIColor { return UIColor.gunmetal }
    var phraseEvaluateButtonTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular)}
    var phraseEvaluateDateColor: UIColor { return UIColor.gunmetal }
    var phraseEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - CounterEvaluateNodeStyle
    var counterEvaluateCounterFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .demiBold) }
    var counterEvaluateCounterColor: UIColor { return UIColor.gunmetal }
    var counterEvaluateSumFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .medium) }
    var counterEvaluateSumColor: UIColor { return UIColor.gunmetal }
    var counterEvaluatePlusColor: UIColor { return UIColor.viridian }
    var counterEvaluatePlusHighlightedColor: UIColor { return UIColor.gunmetal }
    var counterEvaluateMinusColor: UIColor { return UIColor.brownishRed }
    var counterEvaluateMinusHighlightedColor: UIColor { return UIColor.gunmetal }
    var counterEvaluateCustomValueFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var counterEvaluateCustomValueColor: UIColor { return UIColor.gunmetal }
    var counterEvaluateCustomValueHighlightedColor: UIColor { return UIColor.brownishRed }
    var counterEvaluateDateColor: UIColor { return UIColor.gunmetal }
    var counterEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var counterEvaluatePreviousValueFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .medium)}
    var counterEvaluatePreviousValueColor: UIColor { return UIColor.gunmetal }
    var counterEvaluateSeparatorColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - HabitEvaluateNodeStyle
    var evaluateHabitCounterFont: UIFont { return UIFont.avenirNext(size: 46.0, weight: .regular) }
    var evaluateHabitCounterColor: UIColor { return UIColor.gunmetal }
    var evaluateHabitButtonsFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var evaluateHabitMarksColor: UIColor { return UIColor.viridian }
    var evaluateHabitDeleteColor: UIColor { return UIColor.brownishRed }
    var evaluateHabitHighlightedColor: UIColor { return UIColor.gunmetal }
    var evaluateHabitSeparatorColor: UIColor { return UIColor.lightGray }
    
    // MARK: - HabitEvaluateCommentNodeStyle
    var habitEvaluateCommentFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var habitEvaluateCommentTintColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - ListEvaluateNodeStyle
    var listEvaluateViewButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var listEvaluateViewButtonColor: UIColor { return UIColor.gunmetal }
    var listEvaluateViewButtonHighlightedColor: UIColor { return UIColor.viridian }
    var listEvaluateDayDoneFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .regular) }
    var listEvaluateDayDoneColor: UIColor { return UIColor.gunmetal }
    var listEvaluateAllDoneFont: UIFont { return UIFont.avenirNext(size: 25.0, weight: .regular) }
    var listEvaluateAllDoneColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - ListItemEvaluateNodeStyle
    var listItemTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var listItemTextColor: UIColor { return UIColor.gunmetal }
    var listItemTintColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - GoalEvaluateNodeStyle
    var goalEvaluateCounterFont: UIFont { return UIFont.avenirNext(size: 40.0, weight: .ultraLight) }
    var goalEvaluateCounterColor: UIColor { return UIColor.gunmetal }
    var goalEvaluateSumFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var goalEvaluateSumColor: UIColor { return UIColor.gunmetal }
    var goalEvaluatePlusColor: UIColor { return UIColor.viridian }
    var goalEvaluatePlusHighlightedColor: UIColor { return UIColor.gunmetal }
    var goalEvaluateMinusColor: UIColor { return UIColor.brownishRed }
    var goalEvaluateMinusHighlightedColor: UIColor { return UIColor.gunmetal }
    var goalEvaluateCustomValueFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var goalEvaluateCustomValueColor: UIColor { return UIColor.gunmetal }
    var goalEvaluateCustomValueHighlightedColor: UIColor { return UIColor.brownishRed }
    
    // MARK: - JournalNewEntryActionNodeStyle
    var journalNewEntryActionButtonFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var journalNewEntryActionButtonColor: UIColor { return UIColor.gunmetal }
    var journalNewEntryActionButtonHighlightedColor: UIColor { return UIColor.brownishRed }
    var journalNewEntryActionTintColor: UIColor { return UIColor.gunmetal }
    var journalNewEntryActionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var journalNewEntryActionDateColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - JournalEntryNodeStyle
    var journalNodeTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var journalNodeTextColor: UIColor { return UIColor.gunmetal }
    var journalNodeMetadataFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var journalNodeMetadataColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - UpdateNodeStyle
    var updateTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var updateTitleColor: UIColor { return UIColor.gunmetal }
    var updateSubtitleColor: UIColor { return UIColor.gunmetal }
    var updateSubtitleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var updateButtonBorderColor: UIColor { return UIColor.viridian }
    var updateButtonFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var updateButtonColor: UIColor { return UIColor.viridian }
    
    // MARK: - CardListEmptyViewStyle
    var cardListEmptyTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .demiBold) }
    var cardListEmptyTitleColor: UIColor { return UIColor.gunmetal }
    var cardListEmptyDescriptionFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var cardListEmptyDescriptionColor: UIColor { return UIColor.gunmetal }
    var cardListEmptyNewFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var cardListEmptyNewTintColor: UIColor { return UIColor.gunmetal }
    var cardListEmptyNewTintHighlightedColor: UIColor { return UIColor.brownishRed }
    var cardListEmptyNewBackgroundColor: UIColor { return UIColor.white }
    
    // MARK: - HabitNegativeNodeStyle
    var habitNegativeDescriptionFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var habitNegativeDescriptionColor: UIColor { return UIColor.charcoal }
    var habitNegativeCoverColor: UIColor { return UIColor.brownishRed }
    var habitNegativeCoverAlpha: CGFloat { return 0.1 }
}
