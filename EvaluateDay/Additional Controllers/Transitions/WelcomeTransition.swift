//
//  WelcomeTransition.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class WelcomeTransition: Transition {
    func presentAnimation(interactive: Bool) {
        self.containerView.backgroundColor = UIColor.white
        self.toViewController.view.frame = self.containerView.frame
        self.containerView.addSubview(self.toViewController.view)
        self.toViewController.view.transform = CGAffineTransform(translationX: 0.0, y: self.containerView.bounds.size.height)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration, delay: 0.0, options: .allowUserInteraction, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.7, animations: {
                self.fromViewController.view.transform = CGAffineTransform(translationX: 0.0, y: -self.containerView.bounds.size.height)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 1.0, animations: {
                self.toViewController.view.transform = CGAffineTransform.identity
            })
        }) { (_) in
            self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
        }
    }
    
    func dismissAnimation(interactive: Bool) {
        self.containerView.backgroundColor = UIColor.white
        self.toViewController.view.frame = self.containerView.frame
        self.containerView.addSubview(self.toViewController.view)
        self.toViewController.view.transform = CGAffineTransform(translationX: 0.0, y: self.containerView.bounds.size.height)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration, delay: 0.0, options: .allowUserInteraction, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6, animations: {
                self.fromViewController.view.transform = CGAffineTransform(translationX: 0.0, y: -self.containerView.bounds.size.height)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 1.0, animations: {
                self.toViewController.view.transform = CGAffineTransform.identity
            })
        }) { (_) in
            self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
        }
    }
}
