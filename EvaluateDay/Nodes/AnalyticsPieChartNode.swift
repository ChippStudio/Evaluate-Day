//
//  AnalyticsPieChartNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 31/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Charts

class AnalyticsPieChartNode: ASCellNode, IValueFormatter {
    
    // MARK: - UI
    var chart: PieChartView!
    var chartNode: ASDisplayNode!
    var titleNode = ASTextNode()
    var shareButton = ASButtonNode()
    
    // MARK: - Variable
    var chartDidLoad: (() -> Void)?
    var options: [AnalyticsChartNodeOptionsKey: Any]?
    
    // MARK: - Delegates handlers
    var chartStringForValue: ((_ value: Double, _ entry: ChartDataEntry, _ dataSetIndex: Int, _ viewPortHandler: ViewPortHandler?) -> String)?
    
    // MARK: - Init
    init(title: String, data: [PieChartDataEntry], options: [AnalyticsChartNodeOptionsKey: Any]?) {
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
        
        self.chartNode = ASDisplayNode(viewBlock: { () -> UIView in
            self.chart = PieChartView()
            self.chart.backgroundColor = UIColor.background
            self.chart.holeColor = UIColor.background
            self.chart.chartDescription?.text = ""
            self.chart.legend.enabled = false
            self.chart.rotationEnabled = false
            
            let dataSet = PieChartDataSet(values: data, label: nil)
            dataSet.valueFormatter = self
            dataSet.valueColors = [UIColor.black]
            dataSet.colors.removeAll()
            for entry in data {
                if let color = entry.data as? UIColor {
                    dataSet.colors.append(color)
                }
            }
            self.chart.data = PieChartData(dataSet: dataSet)
            
            return self.chart
        }, didLoad: { (_) in
            self.chartDidLoad?()
        })
        
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
        
        self.chartNode.style.preferredSize.height = constrainedSize.max.width //400.0
        let topInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 5.0, right: 10.0)
        let topInset = ASInsetLayoutSpec(insets: topInsets, child: topStack)
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 10.0
        cell.children = [topInset, self.chartNode]
        
        let cellInsets = UIEdgeInsets(top: 50.0, left: 0.0, bottom: 20.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - IValueFormatter
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        if self.chartStringForValue != nil {
            return self.chartStringForValue!(value, entry, dataSetIndex, viewPortHandler)
        }
        
        return String(format: "%.0f", value)
    }
}
