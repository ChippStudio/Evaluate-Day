//
//  PhotoTransition.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/08/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class PhotoTransition: Transition {

    func presentAnimation(interactive: Bool) {
        self.toViewController.view.frame = self.containerView.frame
        self.containerView.addSubview(self.toViewController.view)
        
        guard let toViewController = self.toViewController as? PhotoViewController else {
            self.transitionContext.completeTransition(false)
            return
        }
        
        toViewController.backView.alpha = 0.0
        toViewController.infoCoverView.alpha = 0.0
        toViewController.closeButtonCover.alpha = 0.0
        
        toViewController.scrollView.transform = CGAffineTransform(translationX: 0.0, y: self.containerView.frame.size.height)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration, delay: 0.0, options: .allowUserInteraction, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                toViewController.backView.alpha = 1.0
                toViewController.infoCoverView.alpha = 1.0
                toViewController.closeButtonCover.alpha = 1.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                toViewController.scrollView.transform = CGAffineTransform.identity
            })
        }) { (_) in
            self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
        }
    }
    
    func dismissAnimation(interactive: Bool) {
        guard let fromViewController = self.fromViewController as? PhotoViewController else {
            self.transitionContext.completeTransition(false)
            return
        }
        
        UIView.animateKeyframes(withDuration: self.transitionDuration, delay: 0.0, options: .allowUserInteraction, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                fromViewController.backView.alpha = 0.0
                fromViewController.infoCoverView.alpha = 0.0
                fromViewController.closeButtonCover.alpha = 0.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                fromViewController.scrollView.transform = CGAffineTransform(translationX: 0.0, y: self.containerView.frame.height)
            })
        }) { (_) in
            self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
        }
    }
}
