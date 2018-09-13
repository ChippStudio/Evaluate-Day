//
//  SettingsSplitViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 09/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class SettingsSplitViewController: UIViewController, UINavigationControllerDelegate {
    // MARK: - Controllers
    var mainController: UINavigationController!
    var sideController: UINavigationController!
    
    // MARK: - Variables
    private let mainWidth: CGFloat = 360.0
    private let sideMinimumWidth: CGFloat = 360.0
    
    private var casheViewControllers = [UIViewController]()
    
    var mainFrame: CGRect {
        get {
            if self.view.bounds.size.width - self.mainWidth >= self.sideMinimumWidth {
                var newFrame = self.view.bounds
                newFrame.size.width = self.mainWidth
                return newFrame
            }
            
            return self.view.bounds
        }
    }
    var sideFrame: CGRect {
        
        if self.view.bounds.size.width - self.mainWidth >= self.sideMinimumWidth {
            var newFrame = self.view.bounds
            newFrame.size.width = self.view.bounds.size.width - self.mainWidth
            newFrame.origin.x = self.mainWidth
            return newFrame
        }
        
        var newFrame = self.view.bounds
        newFrame.origin.x = self.view.bounds.width
        return newFrame
    }
    
    // MARK: - Cache
    var sideControllersCache = [UIViewController]()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set controllers
        self.mainController = UIStoryboard(name: Storyboards.settings.rawValue, bundle: nil).instantiateInitialViewController() as? UINavigationController
        self.sideController = UINavigationController(rootViewController: UIStoryboard(name: Storyboards.settings.rawValue, bundle: nil).instantiateViewController(withIdentifier: "aboutSegue"))
        if #available(iOS 11.0, *) {
            self.sideController.navigationBar.prefersLargeTitles = true
            self.sideController.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        self.mainController.delegate = self
        
        self.insert(self.mainController, frame: self.mainFrame)
        self.insert(self.sideController, frame: self.sideFrame)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if mainController == nil || sideController == nil {
             return
        }
        
        if newCollection.horizontalSizeClass == .compact {
            self.mainController.delegate = self
            self.casheViewControllers = self.sideController.viewControllers
            self.sideController.viewControllers.removeAll()
            for vc in self.casheViewControllers {
                self.mainController.pushViewController(vc, animated: false)
            }
        } else {
            if !self.casheViewControllers.isEmpty {
                self.mainController.delegate = nil
                self.mainController.popToRootViewController(animated: false)
                for vc in self.casheViewControllers {
                    self.sideController.pushViewController(vc, animated: false)
                }
                self.casheViewControllers.removeAll()
            } else {
                self.sideController.viewControllers = [UIStoryboard(name: Storyboards.settings.rawValue, bundle: nil).instantiateViewController(withIdentifier: "aboutSegue")]
            }
        }
        
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if mainController == nil || sideController == nil {
            return
        }
        if self.traitCollection.userInterfaceIdiom == .pad {
            
        }
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (_) in
            self.mainController.view.frame = self.mainFrame
            self.sideController.view.frame = self.sideFrame
        }, completion: nil)
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container.isEqual(self.mainController) {
            return self.mainFrame.size
        }
        
        if container.isEqual(self.sideController) {
            return self.sideFrame.size
        }
        
        return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if self.casheViewControllers.count != 0 && navigationController == self.mainController {
            if !navigationController.viewControllers.contains(self.casheViewControllers.last!) {
                self.casheViewControllers.removeLast()
            } else {
                if !self.casheViewControllers.contains(viewController) {
                    self.casheViewControllers.append(viewController)
                }
            }
        }
    }
    
    // MARK: - Actions
    func push(sideController controller: UINavigationController, animated: Bool = false) {
        if self.view.bounds.size.width - self.mainWidth >= self.sideMinimumWidth {
            self.remove(sideController)
            self.sideController = controller
            self.insert(self.sideController, frame: self.sideFrame)
            self.animateControllersFrames(completion: nil)
        } else {
            self.casheViewControllers.append(controller.topViewController!)
            self.mainController.pushViewController(controller.topViewController!, animated: true)
        }
    }
    
    // MARK: - Private Actions
    private func animateControllersFrames(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.mainController.view.frame = self.mainFrame
            self.sideController.view.frame = self.sideFrame
        }) { (_) in
            completion?()
        }
    }
    private func insert(_ controller: UIViewController, frame: CGRect, atIndex index: Int? = nil) {
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
        controller.view.frame = frame
        if index == nil {
            self.view.addSubview(controller.view)
        } else {
            self.view.insertSubview(controller.view, at: index!)
        }
    }
    
    private func remove(_ controller: UIViewController) {
        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
}

extension UIViewController {
    var splitSettingsController: SettingsSplitViewController? {
        var controller = self.parent
        
        while controller != nil {
            if let universalController = controller as? SettingsSplitViewController {
                return universalController
            }
            controller = controller?.parent
        }
        
        return nil
    }
}
