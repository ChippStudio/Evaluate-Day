//
//  OnboardingViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 19/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OnboardingViewController: UIViewController {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var chatManager: OnChatManager!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = Localizations.Welcome.title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
        }
        
        // Set chat manager
        self.chatManager = OnChatManager(inViewController: self, with: self.tableView)
        
        self.chatManager.messageTitleColor = UIColor.tint
        self.chatManager.messageBubbleColor = UIColor.main
        
        self.chatManager.answerTitleColor = UIColor.tint
        self.chatManager.answerBubbleColor = UIColor.selected
        
        self.chatManager.animationImage = Images.Media.appIcon.image
        self.chatManager.animationImageTintColor = UIColor.main
        
        // Set chat flow
        if Database.manager.data.objects(Card.self).filter("isDeleted=%@", false).count != 0 {
            self.chatFlowForOldUser()
        } else {
            self.chatFlowForNewUser()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.chatManager.startChatFlow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
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
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            
            // TableView
            self.tableView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - Button Actions
    @objc func skipAction(sender: UIBarButtonItem) {
        // Skip onboarding
        let controller = UIStoryboard(name: Storyboards.split.rawValue, bundle: nil).instantiateInitialViewController()!
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func openProController(sender: UIButton) {
        let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Action
    func chatFlowForNewUser() {
        let firstActionView = ActionButtonView(frame: CGRect.zero)
        firstActionView.button.setTitle(Localizations.Welcome.next, for: .normal)
        let firstAction = OnChatAction(messages: [Localizations.Welcome.New.Intro.firstMessage, Localizations.Welcome.New.Intro.secondMessage, Localizations.Welcome.New.Intro.thirdMessage], actionView: firstActionView) { (action) in
            
            let new = action.answerMessage!
            action.resumeAction(withMessage: new)
            
            let skipButton = UIBarButtonItem(title: Localizations.General.skip, style: .plain, target: self, action: #selector(self.skipAction(sender:)))
            self.navigationItem.setRightBarButton(skipButton, animated: true)
        }
        
        let secondActionView = OnChatTextActionView(skipTitle: Localizations.General.skip, sendTitle: Localizations.General.send)
        secondActionView.button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        secondActionView.button.setTitleColor(UIColor.tint, for: .normal)
        
        secondActionView.textField.font = UIFont.preferredFont(forTextStyle: .body)
        secondActionView.textField.placeholder = Localizations.Welcome.New.User.placeholder
        secondActionView.textField.tintColor = UIColor.tint
        secondActionView.textField.textColor = UIColor.tint
        secondActionView.textField.backgroundColor = UIColor.positive
        secondActionView.textField.layer.borderColor = UIColor.tint.cgColor
        
        secondActionView.backgroundColor = UIColor.positive
        let secondAction = OnChatAction(messages: [Localizations.Welcome.New.User.firstMessage, Localizations.Welcome.New.User.secondMessage], actionView: secondActionView) { (action) in
            
            var new = action.answerMessage!
            try! Database.manager.app.write {
                Database.manager.application.user.name = new
            }
            
            if new.isEmpty {
                new = Localizations.Welcome.New.User.emptyName
            }
            
            action.resumeAction(withMessage: new)
        }
        
        let thirdActionView = ActionTwoButtonsView()
        thirdActionView.one.setTitle(Localizations.Welcome.New.Cards.one, for: .normal)
        thirdActionView.two.setTitle(Localizations.Welcome.New.Cards.two, for: .normal)
        let thirdAction = OnChatAction(messages: [Localizations.Welcome.New.Cards.firstMessage, Localizations.Welcome.New.Cards.secondMessage, Localizations.Welcome.New.Cards.thirdMessage, Localizations.Welcome.New.Cards.fourthMessage, Localizations.Welcome.New.Cards.fifthdMessage, Localizations.Welcome.New.Cards.seventhdMessage], actionView: thirdActionView) { (action) in
            
            // Set new cards if needed
            if action.answerMessage == Localizations.Welcome.New.Cards.one {
                // Set new collection
                let collection = Dashboard()
                collection.title = Localizations.Welcome.New.Cards.collection
                
                // Add productivity card
                let productivityCard = Card()
                productivityCard.type = .criterionHundred
                productivityCard.title = Localizations.Demo.Criterion.Hundred.title
                productivityCard.subtitle = Localizations.Demo.Criterion.Hundred.subtitle
                productivityCard.order = Database.manager.data.objects(Card.self).count
                productivityCard.dashboard = collection.id
                
                // Add phrase card
                let phraseCard = Card()
                phraseCard.title = Localizations.New.Phrase.title
                phraseCard.subtitle = Localizations.New.Phrase.subtitle
                phraseCard.type = .phrase
                phraseCard.order = Database.manager.data.objects(Card.self).count
                phraseCard.dashboard = collection.id
                
                // Make data
                var values = [TextValue]()
                var components = DateComponents()
                for (i, t) in defaultPhrases.enumerated() {
                    components.day = -i
                    if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                        let value = TextValue()
                        value.created = newDate
                        value.text = t
                        value.owner = phraseCard.id
                        values.append(value)
                    }
                }
                
                // Add counter card
                let counterCard = Card()
                counterCard.title = Localizations.Demo.Counter.title
                counterCard.subtitle = Localizations.Demo.Counter.subtitle
                counterCard.type = .counter
                counterCard.order = Database.manager.data.objects(Card.self).count
                counterCard.dashboard = collection.id
                
                try! Database.manager.data.write {
                    Database.manager.data.add(collection)
                    Database.manager.data.add(productivityCard)
                    Database.manager.data.add(phraseCard)
                    Database.manager.data.add(counterCard)
                    Database.manager.data.add(values)
                }
            }
            
            action.resumeAction(withMessage: action.answerMessage)
        }
        
        let fourthActionView = OnChatTextActionView(skipTitle: Localizations.General.skip, sendTitle: Localizations.General.send)
        fourthActionView.backgroundColor = UIColor.positive
        fourthActionView.button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        fourthActionView.button.setTitleColor(UIColor.tint, for: .normal)
        
        fourthActionView.textField.font = UIFont.preferredFont(forTextStyle: .body)
        fourthActionView.textField.placeholder = Localizations.Welcome.New.Email.placeholder
        fourthActionView.textField.keyboardType = .emailAddress
        fourthActionView.textField.autocapitalizationType = .none
        fourthActionView.textField.tintColor = UIColor.tint
        fourthActionView.textField.textColor = UIColor.tint
        fourthActionView.textField.backgroundColor = UIColor.positive
        fourthActionView.textField.layer.borderColor = UIColor.tint.cgColor
        let fourthAction = OnChatAction(messages: [Localizations.Welcome.New.Email.firstMessage, Localizations.Welcome.New.Email.secondMessage, Localizations.Welcome.New.Email.thirdMessage], actionView: fourthActionView) { (action) in
            
            // Send email to MailChimp
            
            let new = action.answerMessage!
            if new.isEmpty {
                action.resumeAction(withMessage: Localizations.Welcome.New.Email.empty)
            } else {
                
                // Send email to MailChimp
                var headers: HTTPHeaders = [:]
                
                if let authorizationHeader = Request.authorizationHeader(user: "API", password: mailChimpAPIKey) {
                    headers[authorizationHeader.key] = authorizationHeader.value
                }
                headers["Content-Type"] = "application/json"
                
                // JSON Body
                let body: [String : Any] = [
                    "status": "subscribed",
                    "email_address": action.answerMessage
                ]
                
                Alamofire.request("https://us14.api.mailchimp.com/3.0/lists/\(mailChimpListID)/members", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                    
                    let json = JSON(response.value!)
                    let answer: String
                    if let email = json["email_address"].string {
                        answer = email
                        try! Database.manager.app.write {
                            Database.manager.application.user.email = email
                        }
                    } else {
                        answer = Localizations.Welcome.New.Email.empty
                    }
                    action.resumeAction(withMessage: answer)
                }
            }
        }
        
        let fifthActionView = ActionProView()
        fifthActionView.proView.button.addTarget(self, action: #selector(self.openProController(sender:)), for: .touchUpInside)
        let fifthAction = OnChatAction(messages: [Localizations.Welcome.New.Pro.firstMessage, Localizations.Welcome.New.Pro.secondMessage], actionView: fifthActionView) { (action) in
            action.resumeAction(withMessage: action.answerMessage)
        }
        
        let sixthActionView = ActionButtonView(frame: CGRect.zero)
        sixthActionView.button.setTitle(Localizations.Welcome.New.All.enjoy, for: .normal)
        let sixthAction = OnChatAction(messages: [Localizations.Welcome.New.All.firstMessage, Localizations.Welcome.New.All.secondMessage], actionView: sixthActionView) { (action) in
            
            try! Database.manager.app.write {
                Database.manager.application.isShowWelcome = true
            }
            
            let controller = UIStoryboard(name: Storyboards.split.rawValue, bundle: nil).instantiateInitialViewController()!
            self.present(controller, animated: true, completion: nil)
        }
        
        self.chatManager.addAction(action: firstAction)
        self.chatManager.addAction(action: secondAction)
        self.chatManager.addAction(action: thirdAction)
        self.chatManager.addAction(action: fourthAction)
        self.chatManager.addAction(action: fifthAction)
        self.chatManager.addAction(action: sixthAction)
    }
    
    func chatFlowForOldUser() {
        let firstActionView = ActionButtonView(frame: CGRect.zero)
        firstActionView.button.setTitle(Localizations.Welcome.next, for: .normal)
        let firstAction = OnChatAction(messages: [Localizations.Welcome.New.Intro.firstMessage, Localizations.Welcome.New.Intro.secondMessage, Localizations.Welcome.New.Intro.thirdMessage], actionView: firstActionView) { (action) in
            
            let new = action.answerMessage!
            action.resumeAction(withMessage: new)
            
            let skipButton = UIBarButtonItem(title: Localizations.General.skip, style: .plain, target: self, action: #selector(self.skipAction(sender:)))
            self.navigationItem.setRightBarButton(skipButton, animated: true)
        }
        
        let secondActionView = OnChatTextActionView(skipTitle: Localizations.General.skip, sendTitle: Localizations.General.send)
        secondActionView.button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        secondActionView.button.setTitleColor(UIColor.tint, for: .normal)
        
        secondActionView.textField.font = UIFont.preferredFont(forTextStyle: .body)
        secondActionView.textField.placeholder = Localizations.Welcome.New.Email.placeholder
        secondActionView.textField.keyboardType = .emailAddress
        secondActionView.textField.autocapitalizationType = .none
        secondActionView.textField.tintColor = UIColor.tint
        secondActionView.textField.textColor = UIColor.tint
        secondActionView.textField.backgroundColor = UIColor.positive
        secondActionView.textField.layer.borderColor = UIColor.tint.cgColor
        
        secondActionView.backgroundColor = UIColor.positive
        let secondAction = OnChatAction(messages: [Localizations.Welcome.New.Email.firstMessage, Localizations.Welcome.New.Email.secondMessage, Localizations.Welcome.New.Email.thirdMessage], actionView: secondActionView) { (action) in
            
            // Send email to MailChimp
            
            let new = action.answerMessage!
            if new.isEmpty {
                action.resumeAction(withMessage: Localizations.Welcome.New.Email.empty)
            } else {
                
                // Send email to MailChimp
                var headers: HTTPHeaders = [:]
                
                if let authorizationHeader = Request.authorizationHeader(user: "API", password: mailChimpAPIKey) {
                    headers[authorizationHeader.key] = authorizationHeader.value
                }
                headers["Content-Type"] = "application/json"
                
                // JSON Body
                let body: [String : Any] = [
                    "status": "subscribed",
                    "email_address": action.answerMessage
                ]
                
                Alamofire.request("https://us14.api.mailchimp.com/3.0/lists/\(mailChimpListID)/members", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                    
                    let json = JSON(response.value!)
                    let answer: String
                    if let email = json["email_address"].string {
                        answer = email
                        try! Database.manager.app.write {
                            Database.manager.application.user.email = email
                        }
                    } else {
                        answer = Localizations.Welcome.New.Email.empty
                    }
                    action.resumeAction(withMessage: answer)
                }
            }
        }
        
        let thirdActionView = ActionProView()
        thirdActionView.proView.button.addTarget(self, action: #selector(self.openProController(sender:)), for: .touchUpInside)
        let thirdAction = OnChatAction(messages: [Localizations.Welcome.New.Pro.firstMessage, Localizations.Welcome.New.Pro.secondMessage], actionView: thirdActionView) { (action) in
            action.resumeAction(withMessage: action.answerMessage)
        }
        
        let fourthActionView = ActionButtonView(frame: CGRect.zero)
        fourthActionView.button.setTitle(Localizations.Welcome.New.All.enjoy, for: .normal)
        let fourthAction = OnChatAction(messages: [Localizations.Welcome.New.All.firstMessage, Localizations.Welcome.New.All.secondMessage], actionView: fourthActionView) { (action) in
            
            try! Database.manager.app.write {
                Database.manager.application.isShowWelcome = true
            }
            
            let controller = UIStoryboard(name: Storyboards.split.rawValue, bundle: nil).instantiateInitialViewController()!
            self.present(controller, animated: true, completion: nil)
        }
        
        self.chatManager.addAction(action: firstAction)
        self.chatManager.addAction(action: secondAction)
        if !Store.current.isPro {
            self.chatManager.addAction(action: thirdAction)
        }
        self.chatManager.addAction(action: fourthAction)
    }
}
