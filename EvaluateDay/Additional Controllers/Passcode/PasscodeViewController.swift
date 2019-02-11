//
//  PasscodeViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 28/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import LocalAuthentication

class PasscodeViewController: UIViewController {

    // MARK: - UI
    @IBOutlet weak var messageLabel: UILabel!
    var heightView: UIView = UIView()
    
    // MARK: - Variable
    private let passcodeKey = "ED_passcode"
    var passcode: String = "" {
        didSet {
            for v in self.view.subviews {
                if v as? UIButton == nil && v as? UILabel == nil {
                    v.backgroundColor = UIColor.background
                }
            }
            for i in 0..<passcode.count {
                for v in self.view.subviews {
                    if v as? UIButton == nil && v as? UILabel == nil {
                        if v.tag == i {
                            v.backgroundColor = UIColor.main
                        }
                    }
                }
            }
            
            if passcode.count == 4 {
                if self.navigationController == nil {
                    let keychainPasscode = KeychainWrapper.standard.string(forKey: self.passcodeKey)
                    if keychainPasscode == self.passcode {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.passcode = ""
                        for v in self.view.subviews {
                            if v as? UIButton == nil && v as? UILabel == nil {
                                v.backgroundColor = UIColor.background
                            }
                        }
                    }
                } else {
                    if Database.manager.application.settings.passcode {
                        let keychainPasscode = KeychainWrapper.standard.string(forKey: self.passcodeKey)
                        if keychainPasscode == self.passcode {
                            // Delete passcode
                            let deleted = KeychainWrapper.standard.removeObject(forKey: self.passcodeKey)
                            if deleted {
                                try! Database.manager.app.write {
                                    Database.manager.application.settings.passcode = false
                                }
                                sendEvent(.deletePasscode, withProperties: nil)
                                self.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            self.passcode = ""
                            for v in self.view.subviews {
                                if v as? UIButton == nil && v as? UILabel == nil {
                                    v.backgroundColor = UIColor.background
                                }
                            }
                        }
                    } else {
                        if self.tempPasscode == nil {
                            self.tempPasscode = passcode
                            self.messageLabel.text = Localizations.Settings.Passcode.reenter
                            self.passcode = ""
                            for v in self.view.subviews {
                                if v as? UIButton == nil && v as? UILabel == nil {
                                    v.backgroundColor = UIColor.background
                                }
                            }
                        } else {
                            if self.tempPasscode == passcode {
                                // Save passcode in keychain
                                print("Save \(passcode) in keychain")
                                let saved = KeychainWrapper.standard.set(passcode, forKey: self.passcodeKey)
                                if saved {
                                    try! Database.manager.app.write {
                                        Database.manager.application.settings.passcode = true
                                    }
                                    
                                    sendEvent(.setPasscode, withProperties: nil)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            } else {
                                self.tempPasscode = nil
                                self.messageLabel.text = Localizations.Settings.Passcode.Enter.new
                                self.passcode = ""
                                for v in self.view.subviews {
                                    if v as? UIButton == nil && v as? UILabel == nil {
                                        v.backgroundColor = UIColor.background
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    private var tempPasscode: String!
    private var letters = [String: String]()
    var firstLoad: Bool = true
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLetters()
        
        // Navigation item
        if self.navigationController != nil {
            self.navigationItem.title = Localizations.Settings.Passcode.title
        }
        
        for v in self.view.subviews {
            if let button = v as? UIButton {
                if button.tag == 101 {
                    // Delete title
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
                    button.setTitleColor(UIColor.text, for: .normal)
                    button.setTitleColor(UIColor.tint, for: .highlighted)
                } else if button.tag == 111 {
                    // Touch ID or Face ID icon
                    if Database.manager.application.settings.passcodeBiometric && Database.manager.application.settings.passcode {
                        var authError: NSError?
                        let context = LAContext()
                        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                            if #available(iOS 11.0, *) {
                                var image: UIImage?
                                if context.biometryType == .faceID {
                                    image = #imageLiteral(resourceName: "faceid").withRenderingMode(.alwaysOriginal)
                                    button.accessibilityLabel = "Face ID"
                                } else if context.biometryType == .touchID {
                                    image = #imageLiteral(resourceName: "touchid").withRenderingMode(.alwaysOriginal)
                                    button.accessibilityLabel = "Touch ID"
                                }
                                if image != nil {
                                    button.setImage(image!, for: .normal)
                                    button.imageView?.layer.masksToBounds = true
                                    button.imageView?.layer.cornerRadius = 5.0
                                }
                            } else {
                                // Fallback on earlier versions
                                button.setImage(#imageLiteral(resourceName: "touchid").withRenderingMode(.alwaysOriginal), for: .normal)
                                button.imageView?.layer.masksToBounds = true
                                button.imageView?.layer.cornerRadius = 5.0
                            }
                        } else {
                            button.alpha = 0.0
                            button.isEnabled = false
                        }
                    } else {
                        button.alpha = 0.0
                        button.isEnabled = false
                    }
                } else {
                    var subtitle = self.letters["\(button.tag)"]!
                    if subtitle != "" {
                        subtitle = "\n" + subtitle
                    }
                    let center = NSMutableParagraphStyle()
                    center.alignment = .center
                    let title = NSMutableAttributedString(string: "\(button.tag)" + subtitle, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20.0, weight: .light), NSAttributedStringKey.foregroundColor: UIColor.text, NSAttributedStringKey.paragraphStyle: center])
                    title.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0, weight: .light), NSAttributedStringKey.foregroundColor: UIColor.main], range: (title.string as NSString).range(of: subtitle))
                    button.titleLabel?.numberOfLines = 2
                    button.setAttributedTitle(title, for: .normal)
                }
            } else if let label = v as? UILabel {
                // Set label
                if self.navigationController != nil {
                    if Database.manager.application.settings.passcode {
                        label.text = Localizations.Settings.Passcode.Enter.old
                    } else {
                        label.text = Localizations.Settings.Passcode.Enter.new
                    }
                } else {
                    label.text = Localizations.Settings.Passcode.unlock(Localizations.General.evaluateday)
                }
                label.textColor = UIColor.text
                label.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
            } else {
                v.layer.cornerRadius = 20/2
                v.layer.borderWidth = 1.0
                v.layer.borderColor = UIColor.main.cgColor
                v.backgroundColor = UIColor.background
            }
        }
        
        // set notifications
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(sender:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("NEW SIZE - \(size)")
        if size.height <= 550 {
            self.setHeightView()
        } else {
            self.heightView.removeFromSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
        if self.view.frame.size.height <= 550 {
            // Set height view
            self.setHeightView()
        } else {
            self.heightView.removeFromSuperview()
        }
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        
        let duration: TimeInterval = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            //set NavigationBar
            self.navigationController?.navigationBar.barTintColor = UIColor.background
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.main
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.text]
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.text]
            }
            
            self.view.backgroundColor = UIColor.background
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let settings = Database.manager.application.settings!
        
        if !self.firstLoad {
            if self.navigationController == nil {
                if Database.manager.application.lastStopDate.minutes(to: Date()) < settings.passcodeDelay.rawValue {
                    self.dismiss(animated: true, completion: nil)
                    return
                }
            }
            
            if settings.passcode && settings.passcodeBiometric && settings.passcodePromptBiometric {
                self.promtBiometric()
            }
        }
        
        if settings.passcode && settings.passcodeBiometric && settings.passcodePromptBiometric && self.navigationController == nil {
            self.promtBiometric()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        (UIApplication.shared.delegate as! AppDelegate).openFromNotification()
        (UIApplication.shared.delegate as! AppDelegate).openFromQuickAction()
        Store.current.openDetailsController()
    }
    
    // MARK: - Actions
    @objc func applicationDidBecomeActive(sender: Notification) {
        let settings = Database.manager.application.settings!
        
        if self.navigationController == nil {
            if Database.manager.application.lastStopDate.minutes(to: Date()) < settings.passcodeDelay.rawValue {
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        
        if settings.passcode && settings.passcodeBiometric && settings.passcodePromptBiometric {
            self.promtBiometric()
        }
    }
    
    @IBAction func touchStartAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        }
    }
    
    @IBAction func keyboardButtonAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform.identity
        }
        
        if sender.tag == 101 {
            // Delete
            let newCode = String(self.passcode.dropLast())
            self.passcode = newCode
        } else if sender.tag == 111 {
            // Touch ID or Face ID
            self.promtBiometric()
        } else {
            if self.passcode.count < 4 {
                var newCode = self.passcode
                newCode += "\(sender.tag)"
                self.passcode = newCode
            }
        }
    }
    
    @IBAction func touchCancelAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform.identity
        }
    }
    
    func promtBiometric() {
        var authError: NSError?
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: Localizations.Settings.Passcode.unlock(Localizations.General.evaluateday), reply: { (done, _) in
                if done {
                    OperationQueue.main.addOperation {
                        if let pass = KeychainWrapper.standard.string(forKey: self.passcodeKey) {
                            self.passcode = pass
                        }
                    }
                }
            })
        }
    }
    
    func setHeightView() {
        self.heightView.removeFromSuperview()
        self.heightView = UIView()
        self.heightView.backgroundColor = UIColor.background
        let descLabel = UILabel()
        descLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descLabel.numberOfLines = 0
        descLabel.textColor = UIColor.main
        descLabel.textAlignment = .center
        descLabel.text = Localizations.Settings.Passcode.rotate
        self.heightView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.leading.greaterThanOrEqualTo(self.heightView.safeAreaLayoutGuide).offset(20.0)
                make.trailing.lessThanOrEqualTo(self.heightView.safeAreaLayoutGuide).offset(-20.0)
            } else {
                // Fallback on earlier versions
                make.trailing.lessThanOrEqualToSuperview().offset(-20.0)
                make.leading.greaterThanOrEqualToSuperview().offset(20.0)
            }
        }
        self.view.addSubview(self.heightView)
        self.heightView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func setLetters() {
        self.letters["0"] = "  "
        self.letters["1"] = "  "
        self.letters["2"] = "ABC"
        self.letters["3"] = "DEF"
        self.letters["4"] = "GHI"
        self.letters["5"] = "JKL"
        self.letters["6"] = "MNO"
        self.letters["7"] = "PQRS"
        self.letters["8"] = "TUV"
        self.letters["9"] = "WXYZ"
    }
}
