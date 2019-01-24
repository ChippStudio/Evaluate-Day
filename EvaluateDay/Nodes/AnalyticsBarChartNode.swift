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
    
    private var dataAndDateAccessibility = ASDisplayNode()
    
    // MARK: - Variable
    var chartDidLoad: (() -> Void)?
    var topOffset: CGFloat = 0.0
    var leftOffset: CGFloat = 40.0
    var options: [AnalyticsChartNodeOptionsKey: Any]?
    
    private var valueAttributes: [NSAttributedStringKey: Any]!
    private var dateAttributes: [NSAttributedStringKey: Any]!
    
    private var selectedXValue: String?
    private var selectedYValue: String?
    
    // MARK: - Delegates handlers
    var chartStringForValue: ((_ node: AnalyticsBarChartNode, _ value: Double, _ axis: AxisBase?) -> String)?
    var chartValueSelected: ((_ node: AnalyticsBarChartNode, _ chartView: ChartViewBase, _ entry: ChartDataEntry, _ highlight: Highlight) -> String)?
    
    // MARK: - Init
    init(title: String, data: [BarChartDataEntry], options: [AnalyticsChartNodeOptionsKey: Any]?) {
        super.init()
        
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
        
        self.titleNode.attributedText = NSAttributedString(string: titleString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedStringKey.foregroundColor: UIColor.text])
        
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
        
        self.dateAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.main]
        self.date.attributedText = NSAttributedString(string: dateString, attributes: self.dateAttributes)
        
        var valueColor = UIColor.positive
        if !positive {
            valueColor = UIColor.negative
        }
        self.valueAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 45.0, weight: .medium), NSAttributedStringKey.foregroundColor: valueColor]
        self.valueNode.attributedText = NSAttributedString(string: lastValueString, attributes: self.valueAttributes)
        
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
            self.chart.leftAxis.gridColor = UIColor.main
            self.chart.leftAxis.labelFont = UIFont.systemFont(ofSize: 9.0, weight: .regular)
            self.chart.leftAxis.labelTextColor = UIColor.main
            self.chart.leftAxis.axisMaxLabels = 3
            
            if let opt = options?[AnalyticsChartNodeOptionsKey.yLineNumber] as? Int {
                self.chart.leftAxis.labelCount = opt
            }
            
            self.chart.delegate = self
            
            let dataSet = BarChartDataSet(values: data, label: nil)
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
        cell.children = [topInset, self.chartNode]
        
        let cellInsets = UIEdgeInsets(top: self.topOffset, left: 0.0, bottom: 20.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - IAxisValueFormatter
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if self.chartStringForValue != nil {
            return self.chartStringForValue!(self, value, axis)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        if let opt = self.options?[AnalyticsChartNodeOptionsKey.dateFormat] as? String {
            dateFormatter.dateFormat = opt
        }
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
    
    // MARK: - ChartViewDelegate
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        Feedback.player.play(sound: .selectValue, impact: true)
        
        var dateString = "\(entry.x)"
        if let date = entry.data as? Date {
            dateString = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        }
        if self.chartValueSelected != nil {
            dateString = self.chartValueSelected!(self, chartView, entry, highlight)
        }
        
        self.valueNode.attributedText = NSAttributedString(string: "\(Int(entry.y))", attributes: self.valueAttributes)
        self.date.attributedText = NSAttributedString(string: dateString, attributes: self.dateAttributes)
        
        self.selectedXValue = dateString
        self.selectedYValue = "\(Int(entry.y))"
    }
}
