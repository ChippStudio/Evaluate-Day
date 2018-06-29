//
//  TimeBottomViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

protocol TimeBottomViewControllerStyle {
    var timeBottomViewTintColor: UIColor { get }
}

@objc protocol TimeBottomViewControllerDelegate {
    @objc func didSelectTime(inDate date: Date)
}

class TimeBottomViewController: BottomViewController {

    // MARK: - UI
    var datePicker = UIDatePicker()
    
    // MARK: - Variable
    var date = Date()
    var pickerMode = UIDatePickerMode.time
    var minumumDate: Date?
    var maximumDate: Date?
    weak var delegate: TimeBottomViewControllerDelegate?
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let style = Themes.manager.bottomViewControllerStyle
        
        self.datePicker.datePickerMode = self.pickerMode
        self.datePicker.date = self.date
        self.datePicker.minimumDate = self.minumumDate
        self.datePicker.maximumDate = self.maximumDate
        self.datePicker.setValue(style.timeBottomViewTintColor, forKey: "textColor")
        self.datePicker.addTarget(self, action: #selector(timeSelect(sender:)), for: .valueChanged)
        
        self.contentView.addSubview(self.datePicker)
        self.datePicker.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.0)
            if self.view.traitCollection.userInterfaceIdiom == .phone {
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
            } else {
                make.centerX.equalToSuperview()
                make.width.equalTo(350.0)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    @objc func timeSelect(sender: UIDatePicker) {
        self.delegate?.didSelectTime(inDate: self.datePicker.date)
    }
}
