//
//  LightShareViewTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct LightShareViewTheme: ShareViewStyle {
    var background: UIColor { return UIColor.snow }
    var borderColor: UIColor { return UIColor.snow }
    var titleTint: UIColor { return UIColor.charcoal }
    var titleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var descriptionColor: UIColor { return UIColor.charcoal }
    var descriptionFont: UIFont { return UIFont.avenirNext(size: 8.0, weight: .regular) }
    
    var cardShareBackground: UIColor { return UIColor.white}
    var cardShareTitleColor: UIColor { return UIColor.gunmetal }
    var cardShareTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var cardShareSubtitleColor: UIColor { return UIColor.gray }
    var cardShareSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var cardShareDateColor: UIColor { return UIColor.viridian }
    var cardShareDateFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .demiBold) }
    var cardSelectedDateColor: UIColor { return UIColor.gunmetal }
    var cardSelectedDateFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var cardSelectedValuePositiveColor: UIColor { return UIColor.viridian }
    var cardSelectedValueNegativeColor: UIColor { return UIColor.brownishRed }
    var cardSelectedValueFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .regular) }
    
    // MARK: - EvaluateColorShareViewStyle
    var evaluateColorShareNoColorDescriptionColor: UIColor { return UIColor.gunmetal }
    var evaluateColorShareNoColorDescriptionFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular)}
    var evaluateColorShareWhiteBorderColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - EvaluateCheckInShareViewStyle
    var shareCheckInDataStreetFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    var shareCheckInDataStreetColor: UIColor { return UIColor.gunmetal }
    var shareCheckInDataOtherAddressFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var shareCheckInDataOtherAddressColor: UIColor { return UIColor.gunmetal }
    var shareCheckInDataCoordinatesFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var shareCheckInDataCoordinatesColor: UIColor { return UIColor.gunmetal }
    var shareCheckInDataMapTintColor: UIColor { return UIColor.gunmetal }
    var shareCheckInNoDataFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var shareCheckInNoDataColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - EvaluatePhraseShareViewStyle
    var evaluatePhraseTextColor: UIColor { return UIColor.gunmetal }
    var evaluatePhraseTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    
    // MARK: - EvaluateHundredTenCriterionShareViewStyle
    var evaluateHundredTenCriterionNegativeColor: UIColor { return UIColor.brownishRed }
    var evaluateHundredTenCriterionPositiveColor: UIColor { return UIColor.viridian }
    var evaluateHundredTenCriterionColor: UIColor { return UIColor.gunmetal }
    var evaluateHundredTenCriterionValueColor: UIColor { return UIColor.gunmetal }
    var evaluateHundredTenCriterionValueFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    
    // MARK: - EvaluateCriterionThreeShareViewStyle
    var evaluateThreeCriterionMessageColor: UIColor { return UIColor.gunmetal }
    var evaluateThreeCriterionMessageFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var evaluateThreeCriterionNegativeColor: UIColor { return UIColor.brownishRed }
    var evaluateThreeCriterionPositiveColor: UIColor { return UIColor.viridian }
    var evaluateThreeCriterionNeutralColor: UIColor { return UIColor.booger }
    var evaluateThreeCriterionUnsetColor: UIColor { return UIColor.lightGray }
    
    // MARK: - EvaluateCounterShareViewStyle
    var evaluateCounterValueFont: UIFont { return UIFont.avenirNext(size: 40.0, weight: .regular) }
    var evaluateCounterValueColor: UIColor { return UIColor.gunmetal }
    var evalueteCounterSumFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var evaluateCounterSumColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - EvaluateGoalShareViewStyle
    var evaluateGoalValueFont: UIFont { return UIFont.avenirNext(size: 40.0, weight: .regular) }
    var evaluateGoalValueColor: UIColor { return UIColor.gunmetal }
    var evalueteGoalSumFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var evaluateGoalSumColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - EvaluateHabitShareViewStyle
    var evaluateHabitMarksFont: UIFont { return UIFont.avenirNext(size: 46.0, weight: .regular) }
    var evaluateHabitMarksColor: UIColor { return UIColor.gunmetal }
    var evaluateHabitCommentFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var evaluateHabitCommentColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - EvaluateListShareViewStyle
    var listEvaluateShareDayDoneFont: UIFont { return UIFont.avenirNext(size: 36.0, weight: .regular) }
    var listEvaluateShareDayDoneColor: UIColor { return UIColor.gunmetal }
    var listEvaluateShareAllDoneFont: UIFont { return UIFont.avenirNext(size: 25.0, weight: .regular) }
    var listEvaluateShareAllDoneColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - ListShareViewStyle
    var listShareDescriptionColor: UIColor { return UIColor.gunmetal }
    var listShareDescriptionFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - AnalyticsStackShareViewStyle
    var stackTextColor: UIColor { return UIColor.gunmetal }
    var stackTextFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // MARK: - EvaluateJournalShareViewStyle
    var shareJournalTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var shareJournalTextColor: UIColor { return UIColor.gunmetal }
    var shareJournalMetadataFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var shareJournalMetadataColor: UIColor { return UIColor.gunmetal }
    var shareJournalNoDataFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var shareJournalNoDataColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - CalendarShareViewStyle
    var presentFutureQuoteFont: UIFont { return UIFont.avenirNext(size: 26.0, weight: .medium) }
    var presentFutureQuoteColor: UIColor { return UIColor.gunmetal }
    var presentFutureAuthorFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .demiBold) }
    var presentFutureAuthorColor: UIColor { return UIColor.gunmetal }
}
