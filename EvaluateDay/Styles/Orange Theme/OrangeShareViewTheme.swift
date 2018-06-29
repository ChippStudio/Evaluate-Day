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
    var background: UIColor { return UIColor.squash }
    var borderColor: UIColor { return UIColor.squash }
    var titleTint: UIColor { return UIColor.paleGrey }
    var titleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var descriptionColor: UIColor { return UIColor.paleGrey }
    var descriptionFont: UIFont { return UIFont.avenirNext(size: 8.0, weight: .regular) }
    
    var cardShareBackground: UIColor { return UIColor.pumpkin}
    var cardShareTitleColor: UIColor { return UIColor.paleGrey }
    var cardShareTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var cardShareSubtitleColor: UIColor { return UIColor.white }
    var cardShareSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var cardShareDateColor: UIColor { return UIColor.grapePurple }
    var cardShareDateFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .demiBold) }
    var cardSelectedDateColor: UIColor { return UIColor.paleGrey }
    var cardSelectedDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var cardSelectedValuePositiveColor: UIColor { return UIColor.darkBlueGreen }
    var cardSelectedValueNegativeColor: UIColor { return UIColor.grapePurple }
    var cardSelectedValueFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .regular) }
    
    // MARK: - EvaluateColorShareViewStyle
    var evaluateColorShareNoColorDescriptionColor: UIColor { return UIColor.paleGrey }
    var evaluateColorShareNoColorDescriptionFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular)}
    var evaluateColorShareWhiteBorderColor: UIColor { return UIColor.pumpkin }
    
    // MARK: - EvaluateCheckInShareViewStyle
    var shareCheckInDataStreetFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var shareCheckInDataStreetColor: UIColor { return UIColor.paleGrey }
    var shareCheckInDataOtherAddressFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var shareCheckInDataOtherAddressColor: UIColor { return UIColor.paleGrey }
    var shareCheckInDataCoordinatesFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var shareCheckInDataCoordinatesColor: UIColor { return UIColor.paleGrey }
    var shareCheckInDataMapTintColor: UIColor { return UIColor.paleGrey }
    var shareCheckInNoDataFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var shareCheckInNoDataColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - EvaluatePhraseShareViewStyle
    var evaluatePhraseTextColor: UIColor { return UIColor.paleGrey }
    var evaluatePhraseTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    
    // MARK: - EvaluateHundredTenCriterionShareViewStyle
    var evaluateHundredTenCriterionNegativeColor: UIColor { return UIColor.grapePurple }
    var evaluateHundredTenCriterionPositiveColor: UIColor { return UIColor.darkBlueGreen }
    var evaluateHundredTenCriterionColor: UIColor { return UIColor.paleGrey }
    var evaluateHundredTenCriterionValueColor: UIColor { return UIColor.paleGrey }
    var evaluateHundredTenCriterionValueFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    
    // MARK: - EvaluateCriterionThreeShareViewStyle
    var evaluateThreeCriterionMessageColor: UIColor { return UIColor.paleGrey }
    var evaluateThreeCriterionMessageFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var evaluateThreeCriterionNegativeColor: UIColor { return UIColor.grapePurple }
    var evaluateThreeCriterionPositiveColor: UIColor { return UIColor.darkBlueGreen }
    var evaluateThreeCriterionNeutralColor: UIColor { return UIColor.booger }
    var evaluateThreeCriterionUnsetColor: UIColor { return UIColor.white }
    
    // MARK: - EvaluateCounterShareViewStyle
    var evaluateCounterValueFont: UIFont { return UIFont.avenirNext(size: 40.0, weight: .regular) }
    var evaluateCounterValueColor: UIColor { return UIColor.paleGrey }
    var evalueteCounterSumFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var evaluateCounterSumColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - EvaluateGoalShareViewStyle
    var evaluateGoalValueFont: UIFont { return UIFont.avenirNext(size: 40.0, weight: .regular) }
    var evaluateGoalValueColor: UIColor { return UIColor.paleGrey }
    var evalueteGoalSumFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var evaluateGoalSumColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - EvaluateHabitShareViewStyle
    var evaluateHabitMarksFont: UIFont { return UIFont.avenirNext(size: 46.0, weight: .regular) }
    var evaluateHabitMarksColor: UIColor { return UIColor.paleGrey }
    var evaluateHabitCommentFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var evaluateHabitCommentColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - EvaluateListShareViewStyle
    var listEvaluateShareDayDoneFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .regular) }
    var listEvaluateShareDayDoneColor: UIColor { return UIColor.paleGrey }
    var listEvaluateShareAllDoneFont: UIFont { return UIFont.avenirNext(size: 25.0, weight: .regular) }
    var listEvaluateShareAllDoneColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - ListShareViewStyle
    var listShareDescriptionColor: UIColor { return UIColor.paleGrey }
    var listShareDescriptionFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - AnalyticsStackShareViewStyle
    var stackTextColor: UIColor { return UIColor.paleGrey }
    var stackTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - EvaluateJournalShareViewStyle
    var shareJournalTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var shareJournalTextColor: UIColor { return UIColor.paleGrey }
    var shareJournalMetadataFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var shareJournalMetadataColor: UIColor { return UIColor.paleGrey }
    var shareJournalNoDataFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var shareJournalNoDataColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - CalendarShareViewStyle
    var presentFutureQuoteFont: UIFont { return UIFont.avenirNext(size: 26.0, weight: .medium) }
    var presentFutureQuoteColor: UIColor { return UIColor.paleGrey }
    var presentFutureAuthorFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .demiBold) }
    var presentFutureAuthorColor: UIColor { return UIColor.paleGrey }
}
