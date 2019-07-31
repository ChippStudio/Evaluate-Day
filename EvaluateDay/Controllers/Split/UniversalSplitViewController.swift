//
//  UniversalSplitViewController.swift
//  SplitViewController-iOS9
//
//  Created by Konstantin Chistyakov on 21/04/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit
import SnapKit

let mainControllerWidth: CGFloat = 380.0

enum UniversalSplitControllerStateRules {
    case `default`
    case widthBase
    case onlyPad
    case custom(rule: (_ traitCollectio: UITraitCollection, _ viewSize: CGSize, _ mainWidth: CGFloat) -> (Bool))
    
    func stateValue(_ traitCollection: UITraitCollection, viewSize: CGSize, mainWidth: CGFloat) -> Bool {
        switch self {
        case .default: return traitCollection.horizontalSizeClass == .regular && viewSize.width >= mainWidth * 2
        case .widthBase: return viewSize.width >= mainWidth + 320.0
        case .onlyPad: return traitCollection.userInterfaceIdiom == .pad && traitCollection.horizontalSizeClass == .regular && viewSize.width > mainWidth
        case .custom(rule: let rule): return rule(traitCollection, viewSize, mainWidth)
        }
    }
}

class UniversalSplitViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - View Controllers
    fileprivate(set) var mainController: UINavigationController! {
        willSet {
            self.removeChildViewController(mainController)
        }
        didSet {
            self.setupMainViewController(mainController)
        }
    }
    
    private var previousSideViewController: UINavigationController?
    fileprivate(set) var sideController: UINavigationController? {
        willSet {
            self.previousSideViewController = self.sideController
            self.removeChildViewController(sideController)
        }
        didSet {
            self.setupSideViewController(sideController)
        }
    }
    
    fileprivate var mainControllerSize: CGSize = CGSize.zero
    fileprivate var sideControllerSize: CGSize = CGSize.zero
    
    // MARK: - Customization
    var isShowSideCloseButton = true
    var closeButtonTitle = "Close"
    var closeButtonImage: UIImage?
    var emptyView: UIView? {
        willSet {
            if self.emptyView != nil {
                self.emptyView!.removeFromSuperview()
            }
        }
        didSet {
            if self.emptyView != nil {
                self.addEmptyView()
            }
        }
    }
    
    // MARK: - Separator
    var separatorViewColor = UIColor.lightGray
    var separatorView: UIView!
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        let topView = UIView()
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(20.0)
        }
        _ = self.recalculateState(view.bounds.size)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - State
    var rules: UniversalSplitControllerStateRules = .widthBase
    
    fileprivate(set) var isSideOpen: Bool = false
    
    fileprivate var isControllerContaintsSideController: Bool = false
    
    // return yes if need to to cahnge
    func recalculateState(_ size: CGSize) -> Bool {
        let traitCollection = newCollection ?? self.traitCollection
        
        let newState = rules.stateValue(traitCollection, viewSize: size, mainWidth: mainControllerWidth)
        
        if newState != isControllerContaintsSideController {
            isControllerContaintsSideController = newState
            return true
        }
        
        return false
    }
    
    // MARK: - UIConttentConteiner
    fileprivate weak var newCollection: UITraitCollection?
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.newCollection = newCollection
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if self.sideController != nil {
            self.casheViewControllers = self.sideController!.viewControllers
        } else {
            
        }
        
        if recalculateState(size) {
            changeState(size, withTransitionCoordinator: coordinator)
            return
        }
        
        var rect = mainController.view.frame
        rect.size.height = size.height
        rect.size.width = isControllerContaintsSideController ? mainControllerWidth : size.width
        
        var sideRect = CGRect.zero
        
        mainControllerSize = rect.size
        sideControllerSize = sideRect.size
        
        if self.sideController != nil {
            sideRect = sideController!.view.frame
            
            sideRect.size.width = size.width - mainControllerSize.width
            sideRect.size.height = size.height
            
            sideControllerSize = sideRect.size
        }
        
        super.viewWillTransition(to: size, with: coordinator)
        
        self.animation({ 
            self.mainController.view.frame = rect
            if self.sideController != nil { self.sideController?.view.frame = sideRect }
            if self.emptyView != nil { self.emptyView?.frame = CGRect(x: mainControllerWidth, y: 0.0, width: size.width - mainControllerWidth, height: size.height) }
            }, withTransitionCoordinator: coordinator)
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container.isEqual(mainController) {
            return mainControllerSize
        }
        
        if container.isEqual(sideController) {
            return sideControllerSize
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
    
    // MARK: - State Change
    fileprivate var casheViewControllers = [UIViewController]()
    
    fileprivate func changeState(_ size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let bounds = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        
        if isControllerContaintsSideController {
            
            self.mainController.delegate = nil
            
            for _ in 0..<self.casheViewControllers.count {
                self.mainController.popViewController(animated: false)
            }
            
            if self.casheViewControllers.count != 0 {
                let navigationController = UINavigationController(rootViewController: self.casheViewControllers[0])
                for index in 1..<self.casheViewControllers.count {
                    navigationController.pushViewController(self.casheViewControllers[index], animated: false)
                }
                self.sideController = navigationController
                self.sideController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.isSideOpen = true
            }
            
            let mainRect = CGRect(x: 0.0, y: 0.0, width: mainControllerWidth, height: size.height)
            let sideRect = self.sideController != nil ? CGRect(x: mainControllerWidth, y: 0.0, width: size.width - mainControllerWidth, height: size.height) : CGRect.zero
            
            mainControllerSize = mainRect.size
            sideControllerSize = sideRect.size
            
            super.viewWillTransition(to: size, with: coordinator)
            
            animation({ 
                self.mainController.view.frame = mainRect
                self.sideController?.view.frame = sideRect
                }, withTransitionCoordinator: coordinator)
            
            self.addSeparator()
            self.addEmptyView(size: size)
        } else {
            self.removeSideCloseButton()
            
            for c in self.casheViewControllers {
                self.mainController.pushViewController(c, animated: false)
            }
            
            mainControllerSize = bounds.size
            sideControllerSize = CGSize.zero
            
            super.viewWillTransition(to: size, with: coordinator)
            
            animation({ 
                self.mainController.view.frame = bounds
                }, withTransitionCoordinator: coordinator)
            self.sideController = nil
            self.isSideOpen = false
            
            self.removeSeparator()
            self.removeEmptyView()
            self.mainController.delegate = self
        }
    }
    fileprivate func setupMainViewController(_ controller: UINavigationController?) {
        guard let controller = controller else {
            return
        }
        
        self.addChild(controller)
        controller.didMove(toParent: self)
        
        controller.view.frame = isControllerContaintsSideController ? CGRect(x: 0, y: 0, width: mainControllerWidth, height: UIScreen.main.bounds.size.height) : CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        controller.view.autoresizingMask = UIView.AutoresizingMask()
        mainControllerSize = controller.view.bounds.size
        self.view.addSubview(controller.view)
        
        self.mainController.delegate = self
        
        if self.isControllerContaintsSideController {
            self.addSeparator()
        }
    }
    
    fileprivate func setupSideViewController(_ controller: UINavigationController?) {
        guard let controller = controller else {
            return
        }
        
        var animationDuration: TimeInterval = 0.2
        if let prev = self.previousSideViewController {
            if prev.viewControllers.first == controller.viewControllers.first {
                animationDuration = 0.0
            }
        }
        
        if isControllerContaintsSideController {
            self.addChild(controller)
            self.didMove(toParent: self)
            controller.view.frame = CGRect(x: mainControllerSize.width, y: 0.0, width: self.view.frame.size.width - mainControllerSize.width, height: UIScreen.main.bounds.size.height)
            
            controller.view.autoresizingMask = UIView.AutoresizingMask()
            self.sideControllerSize = controller.view.bounds.size
            
            UIView.transition(with: self.view, duration: animationDuration, options: .transitionCrossDissolve, animations: {
                self.view.insertSubview(controller.view, belowSubview: self.mainController.view)
            }) { (_) in
                
            }
            
            self.addSideCloseButton()
        }
    }
    
    // MARK: - Separate action
    fileprivate func addSeparator() {
        addSeparator(self.view.bounds.size)
    }
    
    fileprivate func addSeparator(_ size: CGSize) {
        removeSeparator()
        separatorView = UIView(frame: CGRect(x: mainControllerWidth - 1, y: 0, width: 0.5, height: size.height))
        separatorView.autoresizingMask = .flexibleHeight
        separatorView.backgroundColor = separatorViewColor
        mainController.view.addSubview(separatorView)
    }
    
    fileprivate func removeSeparator() {
        separatorView?.removeFromSuperview()
    }
    
    // MARK: - Empty View
    private func addEmptyView(size: CGSize? = nil) {
        if self.emptyView != nil && self.isControllerContaintsSideController && self.sideController == nil {
            if size == nil {
                self.emptyView!.frame = CGRect(x: mainControllerSize.width, y: 0.0, width: self.view.frame.size.width - mainControllerSize.width, height: UIScreen.main.bounds.size.height)
            } else {
//                print(CGRect(x: mainControllerWidth, y: 0.0, width: size!.width - mainControllerWidth, height: size!.height))
                self.emptyView!.frame = CGRect(x: mainControllerWidth, y: 0.0, width: size!.width - mainControllerWidth, height: size!.height)
            }
            UIView.transition(with: self.view, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.view.addSubview(self.emptyView!)
            }) { (_) in
                
            }
        }
    }
    private func removeEmptyView() {
        if self.emptyView != nil {
            self.emptyView!.removeFromSuperview()
        }
    }
    // MARK: - Close button Actions
    fileprivate var closeSideButton: UIBarButtonItem!
    fileprivate func addSideCloseButton() {
        if !self.isShowSideCloseButton || self.sideController == nil {
            return
        }
        
        if let image = self.closeButtonImage {
            self.closeSideButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(closeButtonAction(_: )))
        } else {
            self.closeSideButton = UIBarButtonItem(title: self.closeButtonTitle, style: .plain, target: self, action: #selector(closeButtonAction(_: )))
        }
        if let topItem = self.sideController?.viewControllers.first?.navigationItem {
            topItem.leftBarButtonItem = self.closeSideButton
        }
    }
    fileprivate func removeSideCloseButton() {
        if let topView = self.sideController?.viewControllers.first?.navigationItem {
            topView.leftBarButtonItem = nil
        }
    }
    @objc fileprivate func closeButtonAction(_ sender: UIBarButtonItem) {
        self.popSideViewController()
    }
    
    // MARK: - Pushing and Poping Controllers
    func insertMainViewController(_ controller: UINavigationController) {
        self.mainController = controller
    }
    
    func pushSideViewController(_ controller: UIViewController, complition: (() -> Void)?) {
        self.removeEmptyView()
        if self.isControllerContaintsSideController {
            self.casheViewControllers.removeAll()
            let navigationController = UINavigationController(rootViewController: controller)
            self.sideController = navigationController
            self.casheViewControllers.append(controller)
            complition?()
        } else {
            self.mainController.pushViewController(controller, animated: true)
            self.casheViewControllers.append(controller)
            complition?()
        }
    }
    func pushInSideViewController(_ controller: UIViewController, complition: (() -> Void)?) {
        if self.isControllerContaintsSideController {
            if let nav = self.sideController {
                nav.pushViewController(controller, animated: true)
                self.casheViewControllers.append(controller)
                complition?()
            } else {
                self.pushSideViewController(controller, complition: complition)
            }
        } else {
            self.mainController.pushViewController(controller, animated: true)
            self.casheViewControllers.append(controller)
            complition?()
        }
    }
    func popViewController(complition: (() -> Void)?) {
        if self.isControllerContaintsSideController {
            guard let controller = self.sideController else {
                return
            }
            
            if !self.casheViewControllers.isEmpty {
                self.casheViewControllers.removeLast()
                controller.popViewController(animated: true)
                complition?()
            } else {
                self.casheViewControllers.removeAll()
                self.removeChildViewController(controller)
                self.sideController = nil
                complition?()
            }
        } else {
            if self.casheViewControllers.count != 0 {
                self.casheViewControllers.removeLast()
            }
            self.mainController.popViewController(animated: true)
            complition?()
        }
    }
    func popSideViewController() {
        
        if self.isControllerContaintsSideController {
            guard let controller = self.sideController else {
                return
            }
            
            self.casheViewControllers.removeAll()
            self.removeChildViewController(controller)
            self.sideController = nil
        } else {
            
            for _ in self.casheViewControllers {
                self.mainController.popViewController(animated: true)
            }
            self.casheViewControllers.removeAll()
        }
        
        self.addEmptyView()
    }

    // MARK: - Helpers
    
    fileprivate func removeChildViewController(_ viewController: UIViewController?) {
        if let viewController = viewController {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
    
    fileprivate func animation(_ animation: @escaping () -> Void, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            animation()
            }, completion: nil)
    }
}

extension UIViewController {
    var universalSplitController: UniversalSplitViewController? {
        var controller = self.parent
        
        while controller != nil {
            if let universal_Controller = controller as? UniversalSplitViewController {
                return universal_Controller
            }
            controller = controller?.parent
        }
        
        return nil
    }
}
