//
//  HOViewControllerTransition.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/30.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "HOViewControllerTransition.h"

@implementation HOViewControllerTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    [containerView addSubview:toVC.view];
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
    
    fromVC.view.transform = CGAffineTransformIdentity;
    if (_isPresenting) {
        toVC.view.transform = CGAffineTransformMakeTranslation(toFrame.size.width, 0);
        [containerView bringSubviewToFront:toVC.view];
    }else {
        toVC.view.transform = CGAffineTransformMakeTranslation(toFrame.size.width * 0.3 * -1, 0);
        [containerView bringSubviewToFront:fromVC.view];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:_isPresenting ? 0 : UIViewAnimationOptionCurveLinear animations:^{
        if (self.isPresenting) {
            toVC.view.transform = CGAffineTransformIdentity;
            fromVC.view.transform = CGAffineTransformMakeTranslation(fromFrame.size.width * 0.3 * -1, 0);
        }else {
            toVC.view.transform = CGAffineTransformIdentity;
            fromVC.view.transform = CGAffineTransformMakeTranslation(fromFrame.size.width, 0);
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        toVC.view.transform = fromVC.view.transform = CGAffineTransformIdentity;
    }];
}

@end
