//
//  SplitSettingsTransition.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 09/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class SplitSettingsTransition: Transition {
    func presentAnimation(interactive: Bool) {
        self.toViewController.view.frame = self.containerView.frame
        self.containerView.addSubview(self.toViewController.view)
        
        guard let toViewController = self.toViewController as? SettingsSplitViewController else {
            self.transitionContext.completeTransition(false)
            return
        }
        
        toViewController.view.backgroundColor = UIColor.clear
        toViewController.mainController.view.transform = CGAffineTransform(translationX: -toViewController.mainController.view.frame.size.width, y: 0.0)
        toViewController.sideController.view.transform = CGAffineTransform(translationX: toViewController.sideController.view.frame.size.width, y: 0.0)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration, delay: 0.0, options: .allowUserInteraction, animations: {
            toViewController.mainController.view.transform = CGAffineTransform.identity
            toViewController.sideController.view.transform = CGAffineTransform.identity
        }) { (_) in
            self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
        }
    }
    
    func dismissAnimation(interactive: Bool) {
        
        self.toViewController.view.frame = self.containerView.frame
        self.containerView.insertSubview(toViewController.view, at: 0)
        
        guard let fromViewController = fromViewController as? SettingsSplitViewController else {
            self.transitionContext.completeTransition(false)
            return
        }
        
        UIView.animateKeyframes(withDuration: self.transitionDuration, delay: 0.0, options: .allowUserInteraction, animations: {
            fromViewController.mainController.view.transform = CGAffineTransform(translationX: -fromViewController.mainController.view.frame.size.width, y: 0.0)
            fromViewController.sideController.view.transform = CGAffineTransform(translationX: fromViewController.sideController.view.frame.size.width, y: 0.0)
        }) { (_) in
            self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
        }
    }
}
