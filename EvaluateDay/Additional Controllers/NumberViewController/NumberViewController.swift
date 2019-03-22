//
//  NumberViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 05/02/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

@objc protocol NumberViewControllerDelegate {
    @objc optional func numberController(controller: NumberViewController, willCloseWith value: Double, forProperty property: String)
}

private enum Operation: Int {
    case plus = 100
    case minus = 101
    case multiple = 200
    case devide = 201
}

class NumberViewController: UIViewController {

    // MARK: - UI
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet var numButtons: [UIButton]!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet var operatorButtons: [UIButton]!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var expresionLabel: UILabel!
    
    // MARK: - Variables
    var property: String = ""
    var value: Double = 0.0
    
    private var expression: String = ""
    private let numberFormatter = NumberFormatter()
    
    // MARK: - Delegate
    weak var delegate: NumberViewControllerDelegate?
    
    // MARK: - Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .overFullScreen
        self.transition = NumberControllerTransition(animationDuration: 0.4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.modalPresentationStyle = .overFullScreen
        self.transition = NumberControllerTransition(animationDuration: 0.4)
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set formatter
        self.numberFormatter.numberStyle = .decimal
//        self.numberFormatter.minimumFractionDigits = 2
        self.numberFormatter.maximumFractionDigits = 2

        // Content view
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 20.0
        self.contentView.backgroundColor = UIColor.background
        
        // Mask view
        self.maskView.backgroundColor = UIColor.main
        self.maskView.alpha = 0.8
        
        // Label
        self.resultLabel.textColor = UIColor.text
        self.expresionLabel.textColor = UIColor.text
        
        self.resultLabel.text = self.numberFormatter.string(from: NSNumber(value: self.value))
        if self.value != 0.0 {
            self.expression = "\(self.value)"
        }
        self.formatExpressionStringAndCalculateValue()
        
        // Buttons
        for button in self.numButtons {
//            button.backgroundColor = UIColor.main
            button.setTitleColor(UIColor.main, for: .normal)
//            button.layer.borderColor = UIColor.main.cgColor
//            button.layer.borderWidth = 1.0
//            button.layer.masksToBounds = true
//            button.layer.cornerRadius = 10.0
            if button.tag == 101 {
                button.setTitle(self.numberFormatter.decimalSeparator, for: .normal)
            }
        }
//        self.clearButton.backgroundColor = UIColor.negative
        self.clearButton.setTitleColor(UIColor.negative, for: .normal)
//        self.clearButton.layer.masksToBounds = true
//        self.clearButton.layer.cornerRadius = 10.0
        for button in self.operatorButtons {
//            button.backgroundColor = UIColor.selected
            button.setTitleColor(UIColor.text, for: .normal)
//            button.layer.masksToBounds = true
//            button.layer.cornerRadius = 10.0
        }
        
        self.saveButton.setTitle(Localizations.General.save, for: .normal)
        self.saveButton.setTitleColor(UIColor.main, for: .normal)
        self.closeButton.setTitle(Localizations.General.cancel, for: .normal)
        self.closeButton.setTitleColor(UIColor.main, for: .normal)
        
    }
    
    // MARK: - Actions
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.delegate?.numberController?(controller: self, willCloseWith: self.value, forProperty: self.property)
        Feedback.player.select()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {
        Feedback.player.impact()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func numberButtonAction(_ sender: UIButton) {
        if sender.tag == 101 {
            // Control and add decimal separator
            if let last = self.expression.last {
                if last == "+" || last == "-" || last == "*" || last == "/" {
                    self.expression.append("0.")
                    self.formatExpressionStringAndCalculateValue()
                    return
                }
                
                var addDecimal = true
                for c in self.expression.reversed() {
                    if c == "." {
                        return
                    }
                    
                    if c == "+" || c == "-" || c == "*" || c == "/" {
                        self.expression.append(".")
                        self.formatExpressionStringAndCalculateValue()
                        addDecimal = false
                        break
                    }
                }
                
                if addDecimal {
                    self.expression.append(".")
                    self.formatExpressionStringAndCalculateValue()
                }
            }
            
            if self.expression.isEmpty {
                self.expression.append("0.")
            }
            
            self.formatExpressionStringAndCalculateValue()
            return
        }
        
        self.expression.append("\(sender.tag)")
        self.formatExpressionStringAndCalculateValue()
    }
    
    @IBAction func operationButtonAction(_ sender: UIButton) {
        guard let operation = Operation(rawValue: sender.tag) else {
            return
        }
        
        if self.expression.isEmpty {
            return
        }
        
        if let last = self.expression.last {
            if last == "+" || last == "-" || last == "*" || last == "/" {
                self.expression.removeLast()
            }
        }
        
        switch operation {
        case .plus:
            self.expression.append("+")
        case .minus:
            self.expression.append("-")
        case .multiple:
            self.expression.append("*")
        case .devide:
            self.expression.append("/")
        }
        
        self.formatExpressionStringAndCalculateValue()
    }
    
    @IBAction func clearButtonAction(_ sender: UIButton) {
        if self.expression.isEmpty {
            return
        }
        
        self.expression.removeLast()
        if self.expression.isEmpty {
            self.value = 0.0
        }
        self.formatExpressionStringAndCalculateValue()
    }
    
    // MARK: - Private Actions
    private func formatExpressionStringAndCalculateValue() {
        
        if let last = self.expression.last {
            if last != "+" && last != "-" && last != "*" && last != "/" && last != "." {
                // Calculate Value
                let exp = NSExpression(format: self.expression, [])
                let calculatedValue = exp.expressionValue(with: nil, context: nil)
                if let newValue = calculatedValue as? Double {
                    self.value = newValue
                }
            }
        }
        self.resultLabel.text = self.numberFormatter.string(from: NSNumber(value: self.value))
        
        // Format Expression
        let decSeparator = self.expression.replacingOccurrences(of: ".", with: self.numberFormatter.decimalSeparator, options: .literal, range: nil)
        let devider = decSeparator.replacingOccurrences(of: "/", with: " ÷ ", options: .literal, range: nil)
        let multiple = devider.replacingOccurrences(of: "*", with: " × ", options: .literal, range: nil)
        let plus = multiple.replacingOccurrences(of: "+", with: " + ", options: .literal, range: nil)
        let minus = plus.replacingOccurrences(of: "-", with: " − ", options: .literal, range: nil)
        
        self.expresionLabel.text = minus
    }
}
