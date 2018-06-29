//
//  DarkShareViewTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct DarkShareViewTheme: ShareViewStyle {
    var background: UIColor { return UIColor.charcoal }
    var borderColor: UIColor { return UIColor.charcoal }
    var titleTint: UIColor { return UIColor.white }
    var titleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var descriptionColor: UIColor { return UIColor.white }
    var descriptionFont: UIFont { return UIFont.avenirNext(size: 8.0, weight: .regular) }
    
    var cardShareBackground: UIColor { return UIColor.gunmetal}
    var cardShareTitleColor: UIColor { return UIColor.white }
    var cardShareTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var cardShareSubtitleColor: UIColor { return UIColor.lightGray }
    var cardShareSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var cardShareDateColor: UIColor { return UIColor.salmon }
    var cardShareDateFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .demiBold) }
    var cardSelectedDateColor: UIColor { return UIColor.white }
    var cardSelectedDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var cardSelectedValuePositiveColor: UIColor { return UIColor.pewterBlue }
    var cardSelectedValueNegativeColor: UIColor { return UIColor.salmon }
    var cardSelectedValueFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .regular) }
    
    // MARK: - EvaluateColorShareViewStyle
    var evaluateColorShareNoColorDescriptionColor: UIColor { return UIColor.white }
    var evaluateColorShareNoColorDescriptionFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular)}
    var evaluateColorShareWhiteBorderColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - EvaluateCheckInShareViewStyle
    var shareCheckInDataStreetFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var shareCheckInDataStreetColor: UIColor { return UIColor.white }
    var shareCheckInDataOtherAddressFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var shareCheckInDataOtherAddressColor: UIColor { return UIColor.white }
    var shareCheckInDataCoordinatesFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var shareCheckInDataCoordinatesColor: UIColor { return UIColor.white }
    var shareCheckInDataMapTintColor: UIColor { return UIColor.white }
    var shareCheckInNoDataFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var shareCheckInNoDataColor: UIColor { return UIColor.white }
    
    // MARK: - EvaluatePhraseShareViewStyle
    var evaluatePhraseTextColor: UIColor { return UIColor.white }
    var evaluatePhraseTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    
    // MARK: - EvaluateHundredTenCriterionShareViewStyle
    var evaluateHundredTenCriterionNegativeColor: UIColor { return UIColor.salmon }
    var evaluateHundredTenCriterionPositiveColor: UIColor { return UIColor.pewterBlue }
    var evaluateHundredTenCriterionColor: UIColor { return UIColor.white }
    var evaluateHundredTenCriterionValueColor: UIColor { return UIColor.white }
    var evaluateHundredTenCriterionValueFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    
    // MARK: - EvaluateCriterionThreeShareViewStyle
    var evaluateThreeCriterionMessageColor: UIColor { return UIColor.white }
    var evaluateThreeCriterionMessageFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var evaluateThreeCriterionNegativeColor: UIColor { return UIColor.salmon }
    var evaluateThreeCriterionPositiveColor: UIColor { return UIColor.pewterBlue }
    var evaluateThreeCriterionNeutralColor: UIColor { return UIColor.booger }
    var evaluateThreeCriterionUnsetColor: UIColor { return UIColor.lightGray }
    
    // MARK: - EvaluateCounterShareViewStyle
    var evaluateCounterValueFont: UIFont { return UIFont.avenirNext(size: 40.0, weight: .regular) }
    var evaluateCounterValueColor: UIColor { return UIColor.white }
    var evalueteCounterSumFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var evaluateCounterSumColor: UIColor { return UIColor.white }
    
    // MARK: - EvaluateGoalShareViewStyle
    var evaluateGoalValueFont: UIFont { return UIFont.avenirNext(size: 40.0, weight: .regular) }
    var evaluateGoalValueColor: UIColor { return UIColor.white }
    var evalueteGoalSumFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var evaluateGoalSumColor: UIColor { return UIColor.white }
    
    // MARK: - EvaluateHabitShareViewStyle
    var evaluateHabitMarksFont: UIFont { return UIFont.avenirNext(size: 46.0, weight: .regular) }
    var evaluateHabitMarksColor: UIColor { return UIColor.white }
    var evaluateHabitCommentFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var evaluateHabitCommentColor: UIColor { return UIColor.white }
    
    // MARK: - EvaluateListShareViewStyle
    var listEvaluateShareDayDoneFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .regular) }
    var listEvaluateShareDayDoneColor: UIColor { return UIColor.white }
    var listEvaluateShareAllDoneFont: UIFont { return UIFont.avenirNext(size: 25.0, weight: .regular) }
    var listEvaluateShareAllDoneColor: UIColor { return UIColor.white }
    
    // MARK: - ListShareViewStyle
    var listShareDescriptionColor: UIColor { return UIColor.white }
    var listShareDescriptionFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - AnalyticsStackShareViewStyle
    var stackTextColor: UIColor { return UIColor.white }
    var stackTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - EvaluateJournalShareViewStyle
    var shareJournalTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var shareJournalTextColor: UIColor { return UIColor.white }
    var shareJournalMetadataFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var shareJournalMetadataColor: UIColor { return UIColor.white }
    var shareJournalNoDataFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var shareJournalNoDataColor: UIColor { return UIColor.white }
    
    // MARK: - CalendarShareViewStyle
    var presentFutureQuoteFont: UIFont { return UIFont.avenirNext(size: 26.0, weight: .medium) }
    var presentFutureQuoteColor: UIColor { return UIColor.white }
    var presentFutureAuthorFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .demiBold) }
    var presentFutureAuthorColor: UIColor { return UIColor.white }
}
