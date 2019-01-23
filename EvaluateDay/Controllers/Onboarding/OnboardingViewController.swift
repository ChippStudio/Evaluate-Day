//
//  OnboardingViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 19/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

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
        
        let firstAction = OnChatAction(messages: ["first", "second", "third", "kjhghghjghj"], actionView: OnChatTextActionView()) { (action) in
            print("Done.......1")
            
            let new = action.answerMessage.uppercased()
            action.resumeAction(withMessage: new)
        }
        
        self.chatManager.addAction(action: firstAction)
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
            self.navigationController?.view.backgroundColor = UIColor.background
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.main
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            
            // TableView
            self.tableView.backgroundColor = UIColor.background
        }
    }
}
