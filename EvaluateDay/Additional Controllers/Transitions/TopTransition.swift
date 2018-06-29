//
//  TopTransition.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class TopTransition: Transition {
    
    func presentAnimation(interactive: Bool) {
        self.toViewController.view.frame = self.containerView.frame
        self.containerView.addSubview(self.toViewController.view)
        
        guard let toViewController = self.toViewController as? TopViewController else {
            self.transitionContext.completeTransition(false)
            return
        }
        
        let maskAlpha = toViewController.maskView.alpha
        toViewController.maskView.alpha = 0.0
        toViewController.contentView.transform = CGAffineTransform(translationX: 0.0, y: -self.containerView.frame.size.height/2)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration, delay: 0.0, options: .allowUserInteraction, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                toViewController.contentView.transform = CGAffineTransform.identity
                toViewController.maskView.alpha = maskAlpha
            })
        }) { (_) in
            self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
        }
    }
    
    func dismissAnimation(interactive: Bool) {
        
        guard let fromViewController = self.fromViewController as? TopViewController else {
            self.transitionContext.completeTransition(false)
            return
        }
        
        UIView.animateKeyframes(withDuration: self.transitionDuration, delay: 0.0, options: .allowUserInteraction, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                fromViewController.contentView.transform = CGAffineTransform(translationX: 0.0, y: -fromViewController.contentView.frame.size.height)
                fromViewController.maskView.alpha = 0.0
            })
        }) { (_) in
            self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
        }
    }

}
