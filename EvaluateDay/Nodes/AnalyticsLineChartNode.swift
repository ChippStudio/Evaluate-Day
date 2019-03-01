//
//  AnalyticsLineChartNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Charts

class AnalyticsLineChartNode: ASCellNode, IAxisValueFormatter, ChartViewDelegate {
    // MARK: - UI
    var chartNode: ASDisplayNode!
    var chart: LineChartView!
    var titleNode = ASTextNode()
    var shareButton = ASButtonNode()
    var valueNode = ASTextNode()
    var date = ASTextNode()
    
    // range buttons
    var weekButton = ASButtonNode()
    var monthButton = ASButtonNode()
    var yearButton = ASButtonNode()
    var rangeButtonCover = ASDisplayNode()
    
    var rangeBackButton = ASButtonNode()
    var rangeForwardButton = ASButtonNode()
    var rangeTitle = ASTextNode()
    
    private var dataAndDateAccessibility = ASDisplayNode()
    
    // MARK: - Variable
    var chartDidLoad: (() -> Void)?
    var options: [AnalyticsChartNodeOptionsKey: Any]?
    
    private var numberFormatter = NumberFormatter()
    
    private var valueAttributes: [NSAttributedString.Key: Any]!
    private var dateAttributes: [NSAttributedString.Key: Any]!
    
    private var selectedYValue: String?
    private var selectedXValue: String?
    
    private var selectedRange: AnalyticsChartRange = .week
    
    // Data
    private var newData = [ChartDataEntry]()
    private let data: [ChartDataEntry]
    private var highlightColor: UIColor!
    private var centralDate = Date()
    
    // MARK: - Delegates handlers
    var chartStringForYValue: ((_ node: AnalyticsLineChartNode, _ value: Double, _ axis: AxisBase?) -> String)?
    var chartStringForXValue: ((_ node: AnalyticsLineChartNode, _ value: Double, _ axis: AxisBase?) -> String)?
    var chartXValueSelected: ((_ node: AnalyticsLineChartNode, _ value: Double, _ highlight: Highlight) -> String)?
    var chartYValueSelected: ((_ node: AnalyticsLineChartNode, _ value: Double, _ highlight: Highlight) -> String)?
    
    // MARK: - Init
    init(title: String, data: [ChartDataEntry], options: [AnalyticsChartNodeOptionsKey: Any]?) {
        self.data = data
        
        super.init()
        
        self.numberFormatter.numberStyle = .decimal
        self.numberFormatter.maximumFractionDigits = 2
        
        self.options = options
    
        var positive = true
        if let pos = self.options?[.positive] as? Bool {
            positive = pos
        }
        
        if !positive {
            self.highlightColor = UIColor.negative
        } else {
            self.highlightColor = UIColor.positive
        }
        
        var titleString = title
        if let opt = options?[AnalyticsChartNodeOptionsKey.uppercaseTitle] as? Bool {
            if opt {
                titleString = title.uppercased()
            }
        }
        self.titleNode.attributedText = NSAttributedString(string: titleString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.text])
        
        self.shareButton.setImage(Images.Media.share.image, for: .normal)
        self.shareButton.imageNode.contentMode = .scaleAspectFit
        self.shareButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        
        var dateString = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
        var lastValueString = Localizations.General.none
        if let lastValue = data.last {
            if let date = lastValue.data as? Date {
                dateString = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
            } else {
                dateString = "\(lastValue.x)"
            }
            lastValueString = "\(Int(lastValue.y))"
            
            self.selectedXValue = dateString
            self.selectedYValue = "\(Float(lastValue.y))"
        }
        
        self.dateAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.main]
        self.date.attributedText = NSAttributedString(string: dateString, attributes: self.dateAttributes)
        
        var valueColor = UIColor.positive
        if !positive {
            valueColor = UIColor.negative
        }
        self.valueAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 45.0, weight: .medium), NSAttributedString.Key.foregroundColor: valueColor]
        self.valueNode.attributedText = NSAttributedString(string: lastValueString, attributes: self.valueAttributes)
        
        // Range buttons
        self.setRangeButtons()
        self.weekButton.addTarget(self, action: #selector(self.weekRangeAction(sender:)), forControlEvents: .touchUpInside)
        self.monthButton.addTarget(self, action: #selector(self.monthRangeAction(sender:)), forControlEvents: .touchUpInside)
        self.yearButton.addTarget(self, action: #selector(self.yearRangeAction(sender:)), forControlEvents: .touchUpInside)
        self.rangeButtonCover.backgroundColor = UIColor.main
        self.rangeButtonCover.cornerRadius = 5.0
        self.rangeButtonCover.clipsToBounds = true
        
        // Ranges
        self.rangeBackButton.setImage(Images.Media.backArrow.image.resizedImage(newSize: CGSize(width: 8.0, height: 13.0)), for: .normal)
        self.rangeBackButton.addTarget(self, action: #selector(self.backButtonAction(sender:)), forControlEvents: .touchUpInside)
        self.rangeBackButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        self.rangeForwardButton.setImage(Images.Media.disclosure.image.resizedImage(newSize: CGSize(width: 8.0, height: 13.0)), for: .normal)
        self.rangeForwardButton.addTarget(self, action: #selector(self.forwardButtonAction(sender:)), forControlEvents: .touchUpInside)
        self.rangeForwardButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        
        self.chartNode = ASDisplayNode(viewBlock: { () -> UIView in
            self.chart = LineChartView()
            self.chart.chartDescription?.text = ""
            self.chart.legend.enabled = false
            self.chart.scaleYEnabled = false
            self.chart.xAxis.labelPosition = .bottom
            self.chart.xAxis.drawAxisLineEnabled = false
            self.chart.xAxis.drawGridLinesEnabled = false
            self.chart.xAxis.valueFormatter = self
            self.chart.xAxis.labelFont = UIFont.systemFont(ofSize: 9.0, weight: .regular)
            self.chart.xAxis.labelTextColor = UIColor.main
            self.chart.rightAxis.enabled = false
            self.chart.leftAxis.drawAxisLineEnabled = false
            self.chart.leftAxis.valueFormatter = self
            self.chart.leftAxis.gridColor = UIColor.tint
            self.chart.leftAxis.labelFont = UIFont.systemFont(ofSize: 9.0, weight: .regular)
            self.chart.leftAxis.labelTextColor = UIColor.main
            self.chart.doubleTapToZoomEnabled = false
//
            if let opt = options?[AnalyticsChartNodeOptionsKey.yLineNumber] as? Int {
                self.chart.leftAxis.labelCount = opt
            }
            self.chart.delegate = self
    
            self.setData()
            
            return self.chart
        }, didLoad: { (_) in
            if let entry = data.last {
                self.selectValue(self.chart, entry: entry, highlight: Highlight())
            }
            self.chartDidLoad?()
        })
        
        // Accessibility
        self.titleNode.isAccessibilityElement = false
        
        self.shareButton.accessibilityLabel = Localizations.Calendar.Empty.share
        self.shareButton.accessibilityValue = "\(self.titleNode.attributedText!.string), \(Localizations.Accessibility.Analytics.lineChart)"
        
        self.dataAndDateAccessibility.isAccessibilityElement = true
        self.dataAndDateAccessibility.accessibilityLabel = "\(self.date.attributedText!.string), \(self.valueNode.attributedText!.string)"
        if !data.isEmpty {
            self.dataAndDateAccessibility.accessibilityValue = Localizations.Accessibility.Analytics.lineChartData("\(data.count)")
        }
        
        self.date.isAccessibilityElement = false
        self.valueNode.isAccessibilityElement = false
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.shareButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        let titleAndShare = ASStackLayoutSpec.horizontal()
        titleAndShare.justifyContent = .spaceBetween
        titleAndShare.alignItems = .center
        titleAndShare.children = [self.titleNode, self.shareButton]
        
        let dateAndValue = ASStackLayoutSpec.horizontal()
        dateAndValue.alignItems = .end
        dateAndValue.justifyContent = .spaceBetween
        dateAndValue.children = [self.valueNode, self.date]
        
        let dateAndValueInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let dateAndValueInset = ASInsetLayoutSpec(insets: dateAndValueInsets, child: dateAndValue)
        
        let dateAndValueAccessibility = ASBackgroundLayoutSpec(child: dateAndValueInset, background: self.dataAndDateAccessibility)
        
        let topStack = ASStackLayoutSpec.vertical()
        topStack.children = [titleAndShare, dateAndValueAccessibility]
        
        let topInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 5.0, right: 10.0)
        let topInset = ASInsetLayoutSpec(insets: topInsets, child: topStack)
        
        let rangeButtons = ASStackLayoutSpec.horizontal()
        rangeButtons.spacing = 10.0
        rangeButtons.children = []
        
        let rangeButtonInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        let weekRangeInset = ASInsetLayoutSpec(insets: rangeButtonInsets, child: self.weekButton)
        let monthRangeInset = ASInsetLayoutSpec(insets: rangeButtonInsets, child: self.monthButton)
        let yearRangeInset = ASInsetLayoutSpec(insets: rangeButtonInsets, child: self.yearButton)
        
        // Set range buttons
        switch self.selectedRange {
        case .week:
            let week = ASBackgroundLayoutSpec(child: weekRangeInset, background: self.rangeButtonCover)
            rangeButtons.children = [week, monthRangeInset, yearRangeInset]
        case .month:
            let month = ASBackgroundLayoutSpec(child: monthRangeInset, background: self.rangeButtonCover)
            rangeButtons.children = [weekRangeInset, month, yearRangeInset]
        case .year:
            let year = ASBackgroundLayoutSpec(child: yearRangeInset, background: self.rangeButtonCover)
            rangeButtons.children = [weekRangeInset, monthRangeInset, year]
        }
        
        let rangeButtonsInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let rangeButtonsInset = ASInsetLayoutSpec(insets: rangeButtonsInsets, child: rangeButtons)
        
        // Set range title
        self.rangeBackButton.style.preferredSize = CGSize(width: 20.0, height: 20.0)
        self.rangeForwardButton.style.preferredSize = CGSize(width: 20.0, height: 20.0)
        let rangeTitleStack = ASStackLayoutSpec.horizontal()
        rangeTitleStack.spacing = 10.0
        rangeTitleStack.alignItems = .center
        rangeTitleStack.justifyContent = .end
        rangeTitleStack.children = [self.rangeBackButton, self.rangeTitle, self.rangeForwardButton]
        
        let rangeTitleInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        let rangeTitleInset = ASInsetLayoutSpec(insets: rangeTitleInsets, child: rangeTitleStack)
        
        self.chartNode.style.preferredSize.height = 200.0
        let cell = ASStackLayoutSpec.vertical()
        cell.children = [topInset, rangeButtonsInset, rangeTitleInset, self.chartNode]
        
        let cellInsets = UIEdgeInsets(top: 50.0, left: 0.0, bottom: 20.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - IAxisValueFormatter
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        if axis is YAxis {
            if self.chartStringForYValue != nil {
                return self.chartStringForYValue!(self, value, axis)
            }
            return String(format: "%.0f", value)
        }
        
        if axis is XAxis {
            if self.chartStringForXValue != nil {
                return self.chartStringForXValue!(self, value, axis)
            }
            
            if Int(value) >= self.newData.count {
                return ""
            }
            let dateFormatter = DateFormatter()
            
            switch self.selectedRange {
            case .week:
                dateFormatter.dateFormat = "dd"
            case .month:
                dateFormatter.dateFormat = "dd"
            case .year:
                dateFormatter.dateFormat = "dd MMM"
            }
            if let opt = self.options?[AnalyticsChartNodeOptionsKey.dateFormat] as? String {
                dateFormatter.dateFormat = opt
            }
            
            let entry = self.newData[Int(value)]
            if let date = entry.data as? Date {
                return dateFormatter.string(from: date)
            }
        }
        
        return ""
    }
    
    // MARK: - ChartViewDelegate
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        Feedback.player.play(sound: .selectValue, impact: true)
        
        self.selectValue(chartView, entry: entry, highlight: highlight)
    }
    
    // MARK: - Actions
    @objc func weekRangeAction(sender: ASButtonNode) {
        self.centralDate = Date()
        self.selectedRange = .week
        self.setRangeButtons()
        self.setData()
        self.transitionLayout(withAnimation: true, shouldMeasureAsync: true, measurementCompletion: nil)
        self.setData()
    }
    @objc func monthRangeAction(sender: ASButtonNode) {
        self.centralDate = Date()
        self.selectedRange = .month
        self.setRangeButtons()
        self.setData()
        self.transitionLayout(withAnimation: true, shouldMeasureAsync: true, measurementCompletion: nil)
    }
    @objc func yearRangeAction(sender: ASButtonNode) {
        self.centralDate = Date()
        self.selectedRange = .year
        self.setRangeButtons()
        self.setData()
        self.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
    }
    
    @objc func forwardButtonAction(sender: ASButtonNode) {
        switch self.selectedRange {
        case .week:
            var components = Calendar.current.dateComponents([.weekOfYear], from: self.centralDate)
            components.weekOfYear = 1
            self.centralDate = Calendar.current.date(byAdding: components, to: self.centralDate)!
            self.setData()
        case .month:
            var components = Calendar.current.dateComponents([.month], from: self.centralDate)
            components.month = 1
            self.centralDate = Calendar.current.date(byAdding: components, to: self.centralDate)!
            self.setData()
        case .year:
            var components = Calendar.current.dateComponents([.year], from: self.centralDate)
            components.year = 1
            self.centralDate = Calendar.current.date(byAdding: components, to: self.centralDate)!
            self.setData()
        }
    }
    
    @objc func backButtonAction(sender: ASButtonNode) {
        switch self.selectedRange {
        case .week:
            var components = Calendar.current.dateComponents([.weekOfYear], from: self.centralDate)
            components.weekOfYear = -1
            self.centralDate = Calendar.current.date(byAdding: components, to: self.centralDate)!
            self.setData()
        case .month:
            var components = Calendar.current.dateComponents([.month], from: self.centralDate)
            components.month = -1
            self.centralDate = Calendar.current.date(byAdding: components, to: self.centralDate)!
            self.setData()
        case .year:
            var components = Calendar.current.dateComponents([.year], from: self.centralDate)
            components.year = -1
            self.centralDate = Calendar.current.date(byAdding: components, to: self.centralDate)!
            self.setData()
        }
    }
    
    // MARK: - Private actions
    private func selectValue(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        var dateString = "\(entry.x)"
        if let date = entry.data as? Date {
            dateString = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        }
        if self.chartXValueSelected != nil {
            dateString = self.chartXValueSelected!(self, entry.x, highlight)
        }
        
        var valueString = self.numberFormatter.string(from: NSNumber(value: entry.y)) ?? "\(Int(entry.y))"
        if self.chartYValueSelected != nil {
            valueString = self.chartYValueSelected!(self, entry.y, highlight)
        }
        
        self.valueNode.attributedText = NSAttributedString(string: valueString, attributes: self.valueAttributes)
        self.date.attributedText = NSAttributedString(string: dateString, attributes: self.dateAttributes)
        
        self.selectedXValue = dateString
        self.selectedYValue = valueString
    }
    
    private func setRangeButtons() {
        let weekAtributes: [NSAttributedString.Key: Any]
        let monthAtributes: [NSAttributedString.Key: Any]
        let yearAtributes: [NSAttributedString.Key: Any]
        switch self.selectedRange {
        case .week:
            weekAtributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.textTint]
            monthAtributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text]
            yearAtributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text]
        case .month:
            weekAtributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text]
            monthAtributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.textTint]
            yearAtributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text]
        case .year:
            weekAtributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text]
            monthAtributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text]
            yearAtributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.textTint]
        }
        
        self.weekButton.setAttributedTitle(NSAttributedString(string: Localizations.Analytics.Range.week, attributes: weekAtributes), for: .normal)
        self.monthButton.setAttributedTitle(NSAttributedString(string: Localizations.Analytics.Range.month, attributes: monthAtributes), for: .normal)
        self.yearButton.setAttributedTitle(NSAttributedString(string: Localizations.Analytics.Range.year, attributes: yearAtributes), for: .normal)
    }
    
    private func setRangeTitle() {
        let title: String
        let dateFormatter = DateFormatter()
        switch self.selectedRange {
        case .week:
            let interval = Calendar.current.dateInterval(of: .weekOfYear, for: self.centralDate)!
            title = "\(DateFormatter.localizedString(from: interval.start, dateStyle: .short, timeStyle: .none)) - \(DateFormatter.localizedString(from: interval.end, dateStyle: .short, timeStyle: .none))"
        case .month:
            dateFormatter.dateFormat = "MMMM"
            title = dateFormatter.string(from: self.centralDate)
        case .year:
            dateFormatter.dateFormat = "yyyy"
            title = dateFormatter.string(from: self.centralDate)
        }
        self.rangeTitle.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text])
    }
    
    private func setData() {
        self.newData.removeAll()
        switch self.selectedRange {
        case .week:
            var components = DateComponents()
            let weekStart = self.centralDate.startOfWeek(startDay: Database.manager.application.settings.weekStart)
            for i in 0...6 {
                components.day = i
                let newDate = Calendar.current.date(byAdding: components, to: weekStart)!
                newData.append(ChartDataEntry(x: Double(i), y: 0.0, data: newDate.center as AnyObject))
            }
        case .month:
            let interval = Calendar.current.dateInterval(of: .month, for: self.centralDate)!
            let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day!
            var components = DateComponents()
            for i in 0..<days {
                components.day = i
                let newDate = Calendar.current.date(byAdding: components, to: interval.start)!
                newData.append(ChartDataEntry(x: Double(i), y: 0.0, data: newDate.center as AnyObject))
            }
        case .year:
            let interval = Calendar.current.dateInterval(of: .year, for: self.centralDate)!
            let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day!
            var components = DateComponents()
            for i in 0..<days {
                components.day = i
                let newDate = Calendar.current.date(byAdding: components, to: interval.start)!
                newData.append(ChartDataEntry(x: Double(i), y: 0.0, data: newDate.center as AnyObject))
            }
        }
        
        for (i, d) in newData.enumerated() {
            if let date = d.data as? Date {
                if let entry = self.data.filter({$0.x >= date.start.timeIntervalSince1970 && $0.x <= date.end.timeIntervalSince1970}).first {
                    newData[i].y = entry.y
                }
            }
        }
        
        let dataSet = LineChartDataSet(values: newData, label: nil)
        dataSet.lineWidth = 1.0
        if self.selectedRange == .year {
            dataSet.circleRadius = 1.0
            dataSet.drawCircleHoleEnabled = false
            dataSet.drawCirclesEnabled = false
        } else {
            dataSet.circleRadius = 3.0
            dataSet.drawCircleHoleEnabled = true
            dataSet.drawCirclesEnabled = true
        }
        dataSet.drawValuesEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.setColor(UIColor.main)
        dataSet.setCircleColors(UIColor.selected)
        dataSet.mode = .horizontalBezier
        dataSet.highlightColor = highlightColor
        dataSet.highlightLineWidth = 1.0
        
        self.chart.animate(yAxisDuration: 0.4)
        self.chart.data = LineChartData(dataSet: dataSet)
        
        self.setRangeTitle()
    }
}
