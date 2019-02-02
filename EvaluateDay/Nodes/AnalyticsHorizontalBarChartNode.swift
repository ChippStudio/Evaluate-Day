//
//  AnalyticsHorizontalBarChartNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Charts

class AnalyticsHorizontalBarChartNode: ASCellNode, IAxisValueFormatter, IValueFormatter {

    // MARK: - UI
    var chart: HorizontalBarChartView!
    var chartNode: ASDisplayNode!
    var titleNode = ASTextNode()
    var shareButton = ASButtonNode()
    var emptyImageNode: ASImageNode!
    
    // MARK: - Variable
    var format = "%.0f"
    var chartDidLoad: (() -> Void)?
    var options: [AnalyticsChartNodeOptionsKey: Any]?
    
    // MARK: - Delegates handlers
    var chartStringForValue: ((_ node: AnalyticsHorizontalBarChartNode, _ value: Double, _ axis: AxisBase?) -> String)?
    
    // MARK: - Init
    init(title: String, data: [BarChartDataEntry], options: [AnalyticsChartNodeOptionsKey: Any]?) {
        super.init()
        
        self.options = options
        
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
        
        if data.isEmpty {
            self.emptyImageNode = ASImageNode()
            self.emptyImageNode.contentMode = .center
            self.emptyImageNode.image = UIImage(named: "empty\(3.random)")?.resizedImage(newSize: CGSize(width: 70.0, height: 70.0))
            self.emptyImageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        }
        
        self.chartNode = ASDisplayNode(viewBlock: { () -> UIView in
            self.chart = HorizontalBarChartView(frame: CGRect.zero)
            
            self.chart.chartDescription?.text = ""
            self.chart.legend.enabled = false
            self.chart.scaleYEnabled = false
            self.chart.scaleXEnabled = false
            self.chart.clipValuesToContentEnabled = true

            self.chart.xAxis.labelPosition = .bottom
            self.chart.xAxis.drawAxisLineEnabled = false
            self.chart.xAxis.drawGridLinesEnabled = false
            self.chart.xAxis.labelFont = UIFont.systemFont(ofSize: 9.0, weight: .regular)
            self.chart.xAxis.labelTextColor = UIColor.main
            self.chart.xAxis.valueFormatter = self
            self.chart.rightAxis.enabled = false
            self.chart.leftAxis.enabled = false
            self.chart.leftAxis.drawAxisLineEnabled = false
            self.chart.leftAxis.drawGridLinesEnabled = false
            self.chart.leftAxis.gridColor = UIColor.main
            self.chart.leftAxis.labelFont = UIFont.systemFont(ofSize: 9.0, weight: .regular)
            self.chart.leftAxis.labelTextColor = UIColor.main
            self.chart.leftAxis.axisMinimum = 0.0
            if let opt = options?[AnalyticsChartNodeOptionsKey.yLineNumber] as? Int {
                self.chart.xAxis.labelCount = opt
            }
            
            let dataSet = BarChartDataSet(values: data, label: nil)
            dataSet.drawValuesEnabled = true
            dataSet.valueTextColor = UIColor.text
            dataSet.valueFormatter = self
            dataSet.highlightEnabled = false
            dataSet.colors = [UIColor.main]
            
            self.chart.animate(xAxisDuration: 0.4)
            self.chart.data = BarChartData(dataSet: dataSet)
            
            return self.chart
        }, didLoad: { (_) in
            self.chartDidLoad?()
        })
        
        self.chartNode.style.preferredSize.height = CGFloat(data.count) * 40.0
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
        
        let topStack = ASStackLayoutSpec.vertical()
        topStack.children = [titleAndShare]
        
        let topInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 5.0, right: 10.0)
        let topInset = ASInsetLayoutSpec(insets: topInsets, child: topStack)
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 10.0
        cell.children = [topInset]
        if self.emptyImageNode != nil {
            self.emptyImageNode.style.preferredSize.height = 70.0
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
        if self.chartStringForValue != nil {
            return self.chartStringForValue!(self, value, axis)
        }
        
        return "\(Int(value))"
    }
    
    // MARK: - IValueFormatter
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: self.format, value)
    }
}
