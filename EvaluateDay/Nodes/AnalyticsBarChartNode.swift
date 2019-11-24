//
//  AnalyticsBarChartNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Charts

class AnalyticsBarChartNode: ASCellNode, IAxisValueFormatter, ChartViewDelegate {
    // MARK: - UI
    var chartNode: ASDisplayNode!
    var chart: BarChartView!
    var titleNode = ASTextNode()
    var shareButton = ASButtonNode()
    var valueNode = ASTextNode()
    var date = ASTextNode()
    var emptyImageNode: ASImageNode!
    
    private var dataAndDateAccessibility = ASDisplayNode()
    
    // MARK: - Variable
    var chartDidLoad: (() -> Void)?
    var options: [AnalyticsChartNodeOptionsKey: Any]?
    
    private var numberFormatter = NumberFormatter()
    
    private var valueAttributes: [NSAttributedString.Key: Any]!
    private var dateAttributes: [NSAttributedString.Key: Any]!
    
    private var selectedXValue: String?
    private var selectedYValue: String?
    
    // MARK: - Delegates handlers
    var chartStringForYValue: ((_ node: AnalyticsBarChartNode, _ value: Double, _ axis: AxisBase?) -> String)?
    var chartStringForXValue: ((_ node: AnalyticsBarChartNode, _ value: Double, _ axis: AxisBase?) -> String)?
    var chartXValueSelected: ((_ node: AnalyticsBarChartNode, _ value: Double, _ highlight: Highlight) -> String)?
    var chartYValueSelected: ((_ node: AnalyticsBarChartNode, _ value: Double, _ highlight: Highlight) -> String)?
    
    // MARK: - Init
    init(title: String, data: [BarChartDataEntry], options: [AnalyticsChartNodeOptionsKey: Any]?) {
        super.init()
        
        self.numberFormatter.numberStyle = .decimal
        self.numberFormatter.maximumFractionDigits = 2
        
        self.options = options
        
        var positive = true
        if let pos = self.options?[.positive] as? Bool {
            positive = pos
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
            self.selectedYValue = lastValueString
        }
        
        self.dateAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.main]
        self.date.attributedText = NSAttributedString(string: dateString, attributes: self.dateAttributes)
        
        var valueColor = UIColor.positive
        if !positive {
            valueColor = UIColor.negative
        }
        self.valueAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 45.0, weight: .medium), NSAttributedString.Key.foregroundColor: valueColor]
        self.valueNode.attributedText = NSAttributedString(string: lastValueString, attributes: self.valueAttributes)
        
        if data.isEmpty {
            self.emptyImageNode = ASImageNode()
            self.emptyImageNode.contentMode = .center
            self.emptyImageNode.image = UIImage(named: "empty\(3.random)")?.resizedImage(newSize: CGSize(width: 200.0, height: 200.0))
            self.emptyImageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        }
        
        self.chartNode = ASDisplayNode(viewBlock: { () -> UIView in
            self.chart = BarChartView()
            self.chart.chartDescription?.text = ""
            self.chart.legend.enabled = false
            self.chart.scaleYEnabled = false
            self.chart.clipValuesToContentEnabled = true
            
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
            
            if let opt = options?[AnalyticsChartNodeOptionsKey.yLineNumber] as? Int {
                self.chart.leftAxis.labelCount = opt
            }
            
            self.chart.delegate = self
            
            let dataSet = BarChartDataSet(entries: data, label: nil)
            dataSet.drawValuesEnabled = false
            dataSet.highlightEnabled = true
            var highlightColor = UIColor.positive
            if !positive {
                highlightColor = UIColor.negative
            }
            dataSet.highlightColor = highlightColor
            dataSet.highlightLineWidth = 1.0
            dataSet.colors = [UIColor.main]
            
            self.chart.data = BarChartData(dataSet: dataSet)
            
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
        self.shareButton.accessibilityValue = "\(self.titleNode.attributedText!.string), \(Localizations.Accessibility.Analytics.barChart)"
        
        self.dataAndDateAccessibility.isAccessibilityElement = true
        self.dataAndDateAccessibility.accessibilityLabel = "\(self.date.attributedText!.string), \(self.valueNode.attributedText!.string)"
        if !data.isEmpty {
            self.dataAndDateAccessibility.accessibilityValue = Localizations.Accessibility.Analytics.barChartData("\(data.count)")
        }
        
        self.date.isAccessibilityElement = false
        self.valueNode.isAccessibilityElement = false
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.titleNode.style.flexShrink = 1.0
        
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
        
        self.chartNode.style.preferredSize.height = 200.0
        let cell = ASStackLayoutSpec.vertical()
        cell.children = [topInset]
        if self.emptyImageNode != nil {
            self.emptyImageNode.style.preferredSize.height = 200.0
            cell.children?.append(self.emptyImageNode)
        } else {
            cell.children?.append(self.chartNode)
        }
        
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
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM"
            if let opt = self.options?[AnalyticsChartNodeOptionsKey.dateFormat] as? String {
                dateFormatter.dateFormat = opt
            }
            return dateFormatter.string(from: Date(timeIntervalSince1970: value))
        }
        
        return ""
    }
    
    // MARK: - ChartViewDelegate
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        Feedback.player.play(sound: .selectValue, impact: true)
        
        self.selectValue(chartView, entry: entry, highlight: highlight)
    }
    
    // MARK: - Private Actions
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
}
