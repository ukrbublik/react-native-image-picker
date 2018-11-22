//
//  MiniToLargeViewInteractive.m
//  DraggableViewControllerDemo
//
//  Created by saiday on 11/19/15.
//  Copyright © 2015 saiday. All rights reserved.
//

#import "MiniToLargeViewInteractive.h"

@interface MiniToLargeViewInteractive ()

@property (nonatomic) BOOL shouldComplete;
@property (nonatomic, weak) UIView *swipeView;
@property (nonatomic, weak) UIView *miniView;

@end

@implementation MiniToLargeViewInteractive

- (void)attachToViewController:(UIViewController *)viewController withSwipeView:(UIView *)swipeView withMiniView:(UIView *)miniView presentViewController:(UIViewController *)presentViewController
{
    self.viewController = viewController;
    self.presentViewController = presentViewController;
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    self.swipeView = swipeView;
    self.miniView = miniView;
    [swipeView addGestureRecognizer:self.pan];
}

- (void)detach {
    self.viewController = nil;
    self.presentViewController = nil;
    if (self.swipeView) {
        [self.swipeView removeGestureRecognizer:self.pan];
    }
    self.swipeView = nil;
    self.pan = nil;
    self.miniView = nil;
}

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    //UIView* rootView = pan.view.superview;
    UIView* rootView = self.viewController.view;
    CGPoint translation = [pan translationInView:rootView];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            if (!self.presentViewController) {
                [self.viewController dismissViewControllerAnimated:YES completion:^{
                }];
            } else {
                [self.viewController presentViewController:self.presentViewController animated:YES completion:^{
                }];
            }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            const CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height - self.miniView.frame.size.height;
            const CGFloat DragAmount = !self.presentViewController ? screenHeight : - screenHeight;
            const CGFloat Threshold = .3f;
            CGFloat percent = translation.y / DragAmount;
            
            percent = fmaxf(percent, 0.f);
            percent = fminf(percent, 1.f);
            [self updateInteractiveTransition:percent];
            
            self.shouldComplete = percent > Threshold;
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (pan.state == UIGestureRecognizerStateCancelled || !self.shouldComplete) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)completionSpeed
{
    return 1.f - self.percentComplete;
}

@end
