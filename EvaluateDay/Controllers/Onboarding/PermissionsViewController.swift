//
//  PermissionsViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PermissionsViewController: UIViewController, ASTableDataSource, ASTableDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    var nextButton = NextButton()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set table node
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.tableNode.view.separatorStyle = .none
        self.tableNode.backgroundColor = UIColor.white
        self.tableNode.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0)
        self.view.insertSubview(self.tableNode.view, at: 0)
        
        self.view.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints { (make) in
            make.height.equalTo(60.0)
            make.width.equalTo(60.0)
            make.trailing.equalTo(self.view).offset(-30.0)
            make.bottom.equalTo(self.view).offset(-20.0)
        }
        self.nextButton.addTarget(self, action: #selector(nextButtonAction(sender: )), for: .touchUpInside)
        self.nextButton.alpha = 0.0
        self.nextButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        self.nextButton.isAccessibilityElement = true
        self.nextButton.accessibilityLabel = Localizations.permission.description.title
        self.nextButton.accessibilityHint = Localizations.accessibility.onboarding.hint
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.view.traitCollection.userInterfaceIdiom == .pad && self.view.frame.size.width >= maxCollectionWidth {
            self.tableNode.frame = CGRect(x: self.view.frame.size.width / 2 - maxCollectionWidth / 2, y: 0.0, width: maxCollectionWidth, height: self.view.frame.size.height)
        } else {
            self.tableNode.frame = self.view.bounds
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.0, delay: 2.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.nextButton.alpha = 1.0
            self.nextButton.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return 4
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        if indexPath.section == 0 {
            return {
                let node = WelcomePermissionTitleNode()
                node.selectionStyle = .none
                return node
            }
        }
        
        var title = ""
        var subtitle = ""
        var set = false
        var image = #imageLiteral(resourceName: "done")
        if indexPath.row == 0 {
            title = Localizations.permission.notification.title
            subtitle = Localizations.permission.notification.description
            if Permissions.defaults.notificationStatus == .authorized {
                set = true
            } else {
                image = #imageLiteral(resourceName: "notification")
            }
        } else if indexPath.row == 1 {
            title = Localizations.permission.location.title
            subtitle = Localizations.permission.location.description
            if Permissions.defaults.locationStatus == .authorizedWhenInUse {
                set = true
            } else {
                image = #imageLiteral(resourceName: "location")
            }
        } else if indexPath.row == 2 {
            title = Localizations.permission.camera.title
            subtitle = Localizations.permission.camera.description
            if Permissions.defaults.cameraStatus == .authorized {
                set = true
            } else {
                image = #imageLiteral(resourceName: "cameraRoll")
            }
        } else if indexPath.row == 3 {
            title = Localizations.permission.photos.title
            subtitle = Localizations.permission.photos.description
            if Permissions.defaults.photoStatus == .authorized {
                set = true
            } else {
                image = #imageLiteral(resourceName: "photos")
            }
        }
        
        return {
            let node = WelcomePermissionButtonNode(title: title, subtitle: subtitle, image: image, set: set)
            node.selectionStyle = .none
            return node
        }
    }

    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            return
        }
        
        if indexPath.row == 0 {
            Permissions.defaults.notificationAutorize(completion: {
                sendEvent(.onboardingSetPermission, withProperties: ["type": "Notification"])
                self.tableNode.reloadRows(at: [indexPath], with: .fade)
            })
        } else if indexPath.row == 1 {
            Permissions.defaults.locationAuthorize(completion: {
                sendEvent(.onboardingSetPermission, withProperties: ["type": "Location"])
                self.tableNode.reloadRows(at: [indexPath], with: .fade)
            })
        } else if indexPath.row == 2 {
            Permissions.defaults.cameraAutorize(completion: {
                sendEvent(.onboardingSetPermission, withProperties: ["type": "Camera"])
                self.tableNode.reloadRows(at: [indexPath], with: .fade)
            })
        } else if indexPath.row == 3 {
            Permissions.defaults.photoAutorize(completion: {
                sendEvent(.onboardingSetPermission, withProperties: ["type": "Photo"])
                self.tableNode.reloadRows(at: [indexPath], with: .fade)
            })
        }
    }
    
    // MARK: - Actions
    @objc func nextButtonAction(sender: NextButton) {
        if Store.current.isPro {
            let presentingController = UIStoryboard(name: Storyboards.tab.rawValue, bundle: nil).instantiateInitialViewController()!
            presentingController.transition = WelcomeTransition(animationDuration: 0.6)
            try! Database.manager.app.write {
                Database.manager.application.isShowWelcome = true
            }
            sendEvent(.finishOnboarding, withProperties: nil)
            self.present(presentingController, animated: true, completion: nil)
        } else {
            let presentingController = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
            let navController = UINavigationController(rootViewController: presentingController)
            navController.transition = WelcomeTransition(animationDuration: 0.6)
            self.present(navController, animated: true, completion: nil)
        }
    }
}
