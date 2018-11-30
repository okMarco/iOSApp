//
//  HOTransitionNavigationController.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/30.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "HOTransitionNavigationController.h"
#import "HOViewControllerTransition.h"

@interface HOTransitionNavigationController ()<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate> {
    BOOL _interacting;
    UIPercentDrivenInteractiveTransition *_interactiveTransition;
    BOOL _shouldComplete;
}
@end

@implementation HOTransitionNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.transitioningDelegate = self;
        self.delegate = self;
        
        _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
        popRecognizer.edges = UIRectEdgeLeft;
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:popRecognizer];
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count >= 1) {
        HOTransitionNavigationController *transitionVc = [[HOTransitionNavigationController alloc] initWithRootViewController:viewController];
        transitionVc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        transitionVc.view.layer.shadowOpacity = 0.3;
        transitionVc.view.layer.shadowRadius = 5;
        [self presentViewController:transitionVc animated:YES completion:nil];
    }else {
        [super pushViewController:viewController animated:animated];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *popedVC = [super popViewControllerAnimated:animated];
    if (!popedVC) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return popedVC;
}

- (void)handlePopRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            _interacting = YES;
            _shouldComplete = NO;
            [self popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
            CGFloat fraction = translation.x / ScreenWidth;
            fraction = fmin(fmax(fraction, 0), 1.0);
            _shouldComplete = fraction > 0.5;
            [_interactiveTransition updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            _interacting = NO;
            _interactiveTransition.completionSpeed = 1.0 - _interactiveTransition.percentComplete;
            [_interactiveTransition cancelInteractiveTransition];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            _interacting = NO;
            _interactiveTransition.completionSpeed = 1.0 - _interactiveTransition.percentComplete;
            if (_shouldComplete) {
                [_interactiveTransition finishInteractiveTransition];
            }else {
                [_interactiveTransition cancelInteractiveTransition];
            }
        }
        default:
            break;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    HOViewControllerTransition *transition = [[HOViewControllerTransition alloc] init];
    transition.isPresenting = YES;
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    HOViewControllerTransition *transition = [[HOViewControllerTransition alloc] init];
    transition.isPresenting = NO;
    return transition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (_interacting) {
        return _interactiveTransition;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (_interacting) {
        return _interactiveTransition;
    }
    return nil;
}
@end
