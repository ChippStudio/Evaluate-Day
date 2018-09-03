//
//  DarkEvaluateTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 08/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct OrangeEvaluateTheme: EvaluableStyle {
    // MARK: - General controller
    var background: UIColor { return UIColor.squash }
    var statusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.lightContent }
    var cardColor: UIColor { return UIColor.pumpkin }
    var cardShadowColor: UIColor { return UIColor.paleGrey }
    var barColor: UIColor { return UIColor.squash }
    var barTint: UIColor { return UIColor.paleGrey }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var cardArchiveColor: UIColor { return UIColor.squash }
    
    var tableNodeSeparatorColor: UIColor { return UIColor.lightGray }
    var actionSheetTintColor: UIColor { return UIColor.pumpkin }
    
    var imageInfoDateLabelFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .bold) }
    var imageInfoCoordinatesFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var imageInfoPlaceFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - Title Node
    var titleTitleColor: UIColor { return UIColor.paleGrey }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var titleSubtitleColor: UIColor { return UIColor.paleGrey }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.paleGrey }
    var titleDashboardFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .medium) }
    var titleDashboardColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - Color Evaluate node
    var selectedColor: UIColor { return UIColor.white }
    var selectedColorDateColor: UIColor { return UIColor.paleGrey }
    var selectedColorDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - CriterionEvaluateNodeStyle
    var criterionEvaluateMaximumTrackColor: UIColor { return UIColor.paleGrey }
    var criterionEvaluateMinimumPositiveTrackColor: UIColor { return UIColor.darkBlueGreen }
    var criterionEvaluateMinimumNegativeTrackColor: UIColor { return UIColor.grapePurple }
    var criterionEvaluateCurrentValueFont: UIFont { return UIFont.avenirNext(size: 48.0, weight: .demiBold) }
    var criterionEvaluateDateColor: UIColor {return UIColor.paleGrey }
    var criterionEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var criterionEvaluatePreviousValueColor: UIColor { return UIColor.paleGrey }
    var criterionEvaluatePreviousValueFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .medium) }
    var criterionEvaluatePersentColor: UIColor { return UIColor.paleGrey }
    var criterionEvaluatePersentFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .regular) }
    var criterionEvaluateSeparatorColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - CriterionThreeEvaluateNodeStyle
    var criterionThreeEvaluatePositiveColor: UIColor { return UIColor.darkBlueGreen }
    var criterionThreeEvaluateNeutralColor: UIColor { return UIColor.booger }
    var criterionThreeEvaluateNegativeColor: UIColor { return UIColor.grapePurple }
    var criterionThreeEvaluateUnsetColor: UIColor { return UIColor.white }
    var criterionThreeEvaluateSeparatorColor: UIColor { return UIColor.paleGrey }
    var criterionThreeEvaluateDateColor: UIColor { return UIColor.paleGrey }
    var criterionThreeEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - CheckInDataEvaluateNodeStyle
    var checkInDataStreetFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var checkInDataStreetColor: UIColor { return UIColor.paleGrey }
    var checkInDataOtherAddressFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var checkInDataOtherAddressColor: UIColor { return UIColor.paleGrey }
    var checkInDataCoordinatesFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var checkInDataCoordinatesColor: UIColor { return UIColor.paleGrey }
    var checkInDataDotColor: UIColor { return UIColor.darkBlueGreen }
    var checkInDataSeparatorColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - CheckInPermissionNodeStyle
    var checkInPermissionDescriptionFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var checkInPermissionDescriptionColor: UIColor { return UIColor.paleGrey }
    var checkInPermissionButtonFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInPermissionButtonColor: UIColor { return UIColor.paleGrey }
    var checkInPermissionButtonHighlightColor: UIColor { return UIColor.grapePurple }
    var checkInPermissionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInPermissionDateColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - CheckInActionNodeStyle
    var checkInActionMapButtonFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var checkInActionMapButtonColor: UIColor { return UIColor.darkBlueGreen }
    var checkInActionMapButtonHighlightColor: UIColor { return UIColor.grapePurple }
    var checkInActionCheckInButtonFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var checkInActionCheckInButtonColor: UIColor { return UIColor.darkBlueGreen }
    var checkInActionCheckInButtonHighlightColor: UIColor { return UIColor.grapePurple }
    var checkInActionSeparatorColor: UIColor { return UIColor.paleGrey }
    var checkInActionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInActionDateColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - PhraseEvaluateNodeStyle
    var phraseEvaluateTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .medium) }
    var phraseEvaluateTextColor: UIColor { return UIColor.paleGrey }
    var phraseEvaluateButtonColor: UIColor { return UIColor.paleGrey }
    var phraseEvaluateButtonTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var phraseEvaluateDateColor: UIColor { return UIColor.paleGrey }
    var phraseEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - CounterEvaluateNodeStyle
    var counterEvaluateCounterFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .demiBold) }
    var counterEvaluateCounterColor: UIColor { return UIColor.paleGrey }
    var counterEvaluateSumFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .medium) }
    var counterEvaluateSumColor: UIColor { return UIColor.paleGrey }
    var counterEvaluatePlusColor: UIColor { return UIColor.darkBlueGreen }
    var counterEvaluatePlusHighlightedColor: UIColor { return UIColor.paleGrey }
    var counterEvaluateMinusColor: UIColor { return UIColor.grapePurple }
    var counterEvaluateMinusHighlightedColor: UIColor { return UIColor.paleGrey }
    var counterEvaluateCustomValueFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var counterEvaluateCustomValueColor: UIColor { return UIColor.paleGrey }
    var counterEvaluateCustomValueHighlightedColor: UIColor { return UIColor.grapePurple }
    var counterEvaluateDateColor: UIColor { return UIColor.paleGrey }
    var counterEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var counterEvaluatePreviousValueFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .medium)}
    var counterEvaluatePreviousValueColor: UIColor { return UIColor.paleGrey }
    var counterEvaluateSeparatorColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - HabitEvaluateNodeStyle
    var evaluateHabitCounterFont: UIFont { return UIFont.avenirNext(size: 48.0, weight: .demiBold) }
    var evaluateHabitCounterColor: UIColor { return UIColor.paleGrey }
    var evaluateHabitButtonsFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .bold) }
    var evaluateHabitMarksColor: UIColor { return UIColor.darkBlueGreen }
    var evaluateHabitDeleteColor: UIColor { return UIColor.grapePurple }
    var evaluateHabitHighlightedColor: UIColor { return UIColor.paleGrey }
    var evaluateHabitSeparatorColor: UIColor { return UIColor.white }
    var evaluateHabitDateColor: UIColor { return UIColor.paleGrey }
    var evaluateHabitDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var evaluateHabitPreviousCountColor: UIColor { return UIColor.paleGrey }
    var evaluateHabitPreviousCountFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .demiBold) }
    
    // MARK: - HabitEvaluateCommentNodeStyle
    var habitEvaluateCommentFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var habitEvaluateCommentTintColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - HabitNegativeNodeStyle
    var habitNegativeDescriptionFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .demiBold) }
    var habitNegativeDescriptionColor: UIColor { return UIColor.paleGrey }
    var habitNegativeCoverColor: UIColor { return UIColor.grapePurple }
    var habitNegativeCoverAlpha: CGFloat { return 0.5 }
    
    // MARK: - ListEvaluateNodeStyle
    var listEvaluateViewButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .bold) }
    var listEvaluateViewButtonColor: UIColor { return UIColor.paleGrey }
    var listEvaluateViewButtonHighlightedColor: UIColor { return UIColor.darkBlueGreen }
    var listEvaluateDayDoneFont: UIFont { return UIFont.avenirNext(size: 30.0, weight: .demiBold) }
    var listEvaluateDayDoneColor: UIColor { return UIColor.paleGrey }
    var listEvaluateAllDoneFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var listEvaluateAllDoneColor: UIColor { return UIColor.paleGrey }
    var listEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var listEvaluateDateColor: UIColor { return UIColor.paleGrey }
    var listEvaluateSeparatorColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - ListItemEvaluateNodeStyle
    var listItemTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var listItemTextColor: UIColor { return UIColor.paleGrey }
    var listItemTintColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - GoalEvaluateNodeStyle
    var goalEvaluateCounterFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .demiBold) }
    var goalEvaluateCounterColor: UIColor { return UIColor.paleGrey }
    var goalEvaluateSumFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .medium) }
    var goalEvaluateSumColor: UIColor { return UIColor.paleGrey }
    var goalEvaluatePlusColor: UIColor { return UIColor.darkBlueGreen }
    var goalEvaluatePlusHighlightedColor: UIColor { return UIColor.white }
    var goalEvaluateMinusColor: UIColor { return UIColor.grapePurple }
    var goalEvaluateMinusHighlightedColor: UIColor { return UIColor.paleGrey }
    var goalEvaluateCustomValueFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var goalEvaluateCustomValueColor: UIColor { return UIColor.paleGrey }
    var goalEvaluateCustomValueHighlightedColor: UIColor { return UIColor.grapePurple }
    var goalEvaluateGoalFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .medium) }
    var goalEvaluateGoalColor: UIColor { return UIColor.paleGrey }
    var goalEvaluateDateColor: UIColor { return UIColor.paleGrey }
    var goalEvaluateDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var goalEvaluatePreviousValueFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .medium)}
    var goalEvaluatePreviousValueColor: UIColor { return UIColor.paleGrey }
    var goalEvaluateSeparatorColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - JournalNewEntryActionNodeStyle
    var journalNewEntryActionButtonFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var journalNewEntryActionButtonColor: UIColor { return UIColor.paleGrey }
    var journalNewEntryActionButtonHighlightedColor: UIColor { return UIColor.grapePurple }
    var journalNewEntryActionTintColor: UIColor { return UIColor.paleGrey }
    var journalNewEntryActionDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var journalNewEntryActionDateColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - JournalEntryNodeStyle
    var journalNodeTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var journalNodeTextColor: UIColor { return UIColor.paleGrey }
    var journalNodeMetadataFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var journalNodeMetadataColor: UIColor { return UIColor.paleGrey }
    var journalNodeTextCoverColor: UIColor { return UIColor.pumpkin }
    var journalNodeImagePlaceHolderTintColor: UIColor { return UIColor.white }
    
    // MARK: - UpdateNodeStyle
    var updateTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var updateTitleColor: UIColor { return UIColor.paleGrey }
    var updateSubtitleColor: UIColor { return UIColor.paleGrey }
    var updateSubtitleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var updateButtonBorderColor: UIColor { return UIColor.grapePurple }
    var updateButtonFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var updateButtonColor: UIColor { return UIColor.grapePurple }
    
    // MARK: - CardListEmptyViewStyle
    var cardListEmptyTitleFont: UIFont { return UIFont.avenirNext(size: 30.0, weight: .bold) }
    var cardListEmptyTitleColor: UIColor { return UIColor.paleGrey }
    var cardListEmptyDescriptionFont: UIFont { return UIFont.avenirNext(size: 22.0, weight: .regular) }
    var cardListEmptyDescriptionColor: UIColor { return UIColor.paleGrey }
    var cardListEmptyNewFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var cardListEmptyNewTintColor: UIColor { return UIColor.paleGrey }
    var cardListEmptyNewTintHighlightedColor: UIColor { return UIColor.grapePurple }
    var cardListEmptyNewBackgroundColor: UIColor { return UIColor.pumpkin }
    
    // MARK: - DashboardsNodeStyle
    var dashboardsNodeTitleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var dashboardsNodeTitleColor: UIColor { return UIColor.paleGrey }
    var dashboardsNodeNewColor: UIColor { return UIColor.paleGrey }
    var dashboardsNodeNewBorderColor: UIColor { return UIColor.pumpkin }
}
