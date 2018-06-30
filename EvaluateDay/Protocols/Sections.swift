//
//  Sections.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Activity
protocol ActivitySection: UserInformationNodeStyle, AnalyticsCalendarNodeStyle, AnalyticsStatisticNodeStyle, AnalyticsBarChartNodeStyle, TitleNodeStyle, SettingsMoreNodeStyle { }

// MARK: - Evaluable
protocol EvaluableSection {
    // MARK: - Variables
    var card: Card! { get set }
    var date: Date! { get set }
    
    // MARK: - Handlers
    var shareHandler: ((_ indexPath: IndexPath, _ bcard: Card, _ items: [Any]) -> Void)? { get set }
    var deleteHandler: ((_ indexPath: IndexPath, _ bcard: Card) -> Void)? { get set }
    var editHandler: ((_ indexPath: IndexPath, _ bcard: Card) -> Void)? { get set }
    var mergeHandler: ((_ indexPath: IndexPath, _ bcard: Card) -> Void)? { get set }
    var unarchiveHandler: ((_ indexPath: IndexPath, _ bcard: Card) -> Void)? { get set }
    var didSelectItem: ((_ section: Int, _  bcard: Card) -> Void)? { get set }
}
protocol EvaluableSectionStyle: TitleNodeStyle, ColorEvaluateNodeStyle, CriterionEvaluateNodeStyle, UpdateNodeStyle, CheckInDataEvaluateNodeStyle, CheckInPermissionNodeStyle, CheckInActionNodeStyle, CriterionThreeEvaluateNodeStyle, PhraseEvaluateNodeStyle, CounterEvaluateNodeStyle, HabitEvaluateCommentNodeStyle, HabitEvaluateNodeStyle, ListEvaluateNodeStyle, ListItemEvaluateNodeStyle, GoalEvaluateNodeStyle, JournalNewEntryActionNodeStyle, JournalEntryNodeStyle, CalendarDateNodeStyle, ActionNodeStyle, UnarchiveNodeStyle, AnalyticsNodeStyle, FutureNodeStyle, HabitNegativeNodeStyle { }

// MARK: - Analytical
protocol AnalyticalSection {
    // MARK: - Variables
    var card: Card! { get set }
    
    // MARK: - Handlers
    var shareHandler: ((_ indexPath: IndexPath, _ items: [Any]) -> Void)? { get set }
    var exportHandler: ((_ indexPath: IndexPath, _ index: Int, _ item: Any) -> Void)? { get set }
}
protocol AnalyticalSectionStyle: TitleNodeStyle, AnalyticsCalendarNodeStyle, AnalyticsColorStatisticNodeStyle, AnalyticsStatisticNodeStyle, AnalyticsLineChartNodeStyle, AnalyticsBarChartNodeStyle, AnalyticsExportNodeStyle, AnalyticsMapNodeStyle, PhraseListNodeStyle, SettingsMoreNodeStyle, SettingsProButtonNodeStyle { }

// MARK: - Editable
protocol EditableSection {
    // MARK: - Variables
    var card: Card! { get set }
    
    // MARK: - Handlers
    var setTextHandler: ((_ title: String, _ property: String, _ oldText: String?) -> Void)? { get set }
    var setBoolHandler: ((_ isOn: Bool, _ property: String, _ oldIsOn: Bool) -> Void)? { get set }
}
protocol EditableSectionStyle: CardSettingsTextNodeStyle, CardSettingsBooleanNodeStyle, DescriptionNodeStyle, SettingsMoreNodeStyle { }

// MARK: - Merge
protocol MergeSection {
    // MARK: - Variables
    var card: Card! { get set }
    
    // MARK: - Handlers
    var mergeDone: (() -> Void)? { get set }
}

protocol MergeSectionStyle: BigDescriptionNodeStyle, DescriptionNodeStyle, SettingsMoreNodeStyle, TitleNodeStyle, SettingsProButtonNodeStyle { }