//
//  NewsletterViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 01/03/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsletterViewController: UIViewController, UITextFieldDelegate {

    // MARK: - UI
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var underline: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var skipButton: UIBarButtonItem!
    
    // MARK: - Variables
    private let proSegue = "proSegue"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        //set NavigationBar
        self.navigationController?.navigationBar.barTintColor = UIColor.background
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.main
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = Localizations.Onboarding.Newsletter.title
        self.skipButton = UIBarButtonItem(title: Localizations.General.skip, style: .plain, target: self, action: #selector(self.skipButtonAction(sender:)))
        self.navigationItem.rightBarButtonItem = self.skipButton
        
        self.textField.placeholder = Localizations.Onboarding.Newsletter.placeholder
        self.textField.textColor = UIColor.text
        self.textField.tintColor = UIColor.text
        
        self.descriptionLabel.textColor = UIColor.main
        self.descriptionLabel.text = Localizations.Onboarding.Newsletter.description
        
        self.subscribeButton.layer.cornerRadius = 10.0
        self.subscribeButton.backgroundColor = UIColor.main
        self.subscribeButton.setTitle(Localizations.Onboarding.Newsletter.button, for: .normal)
        self.subscribeButton.setTitleColor(UIColor.textTint, for: .normal)
        
        self.textField.becomeFirstResponder()
        
        // Backgrounds
        self.view.backgroundColor = UIColor.background
        
        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(sender:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: - Actions
    @objc func skipButtonAction(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: self.proSegue, sender: self)
    }
    @IBAction func subscribeButtonAction(_ sender: UIButton) {
        guard let text = self.textField.text else {
            return
        }
        
        if text.isEmpty {
            return
        }
        // Send email to MailChimp
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: "API", password: mailChimpAPIKey) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        headers["Content-Type"] = "application/json"
        
        // JSON Body
        let body: [String : Any] = [
            "status": "subscribed",
            "email_address": text
        ]
        
        Alamofire.request("https://us14.api.mailchimp.com/3.0/lists/\(mailChimpListID)/members", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            sendEvent(Analytics.subscribeNewsletter, withProperties: nil)
            self.performSegue(withIdentifier: self.proSegue, sender: self)
        }
    }
    
    // MARK: - Keyboard actions
    @objc func keyboardWillShow(sender: Notification) {
        let height = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size.height
        self.bottomConstraint.constant = height + 5
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardDidHide(sender: Notification) {
        self.bottomConstraint.constant = 20
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
