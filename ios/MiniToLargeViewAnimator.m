//
//  MiniToLargeViewAnimator.m
//  DraggableViewControllerDemo
//
//  Created by saiday on 11/19/15.
//  Copyright © 2015 saiday. All rights reserved.
//

#import "MiniToLargeViewAnimator.h"

#import "DummyView.h"

static NSTimeInterval kAnimationDuration = .4f;


@interface MiniToLargeViewAnimator()

@property (nonatomic, strong) UIView *fakeView;

@end


@implementation MiniToLargeViewAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kAnimationDuration;
}

- (void)animatePresentingInContext:(id<UIViewControllerContextTransitioning>)transitionContext toVC:(UIViewController *)toVC fromVC:(UIViewController *)fromVC
{
    // fromVC - root window
    // toVC - picker VC
    
    UIView *container = [transitionContext containerView];
    // setup initial & target frames
    CGRect fromVCRect = [transitionContext initialFrameForViewController:fromVC];
    CGRect toVCRect = fromVCRect;
    toVCRect.origin.y = toVCRect.size.height - self.initialY;
    toVC.view.frame = toVCRect;
    // replace original mini view to fake
    self.fakeView = [self createFakeMiniView];
    [toVC.view addSubview:self.fakeView];
    self.fakeView.alpha = 1.0f;
    self.miniView.alpha = 0.f;
    // add fake on top of picker
    CGRect pickerFrame = toVC.view.frame;
    pickerFrame.origin.y += self.fakeView.frame.size.height;
    pickerFrame.size.height += self.fakeView.frame.size.height;
    [toVC.view setFrame:pickerFrame];
    CGRect fakeFrame = self.fakeView.frame;
    fakeFrame.origin.y = 0 - self.fakeView.frame.size.height;
    [self.fakeView setFrame:fakeFrame];
    // setup container
    [container addSubview:fromVC.view]; //?
    [container addSubview:toVC.view];
    
    
    [UIView animateWithDuration:kAnimationDuration delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        toVC.view.frame = fromVCRect;
        // fakeView.alpha = 0.f; //no need to hide
    } completion:^(BOOL finished) {
        self.miniView.alpha = 1.f; // restore original mini
       // [self.fakeView removeFromSuperview]; //don't remove, we'll use it on dismiss
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        } else {
            [transitionContext completeTransition:YES];
        }
    }];
}

- (void)animateDismissingInContext:(id<UIViewControllerContextTransitioning>)transitionContext toVC:(UIViewController *)toVC fromVC:(UIViewController *)fromVC
{
    // fromVC - picker VC
    // toVC - root window
    
    UIView *container = [transitionContext containerView];
    // setup initial & target frames
    CGRect fromVCRect = [transitionContext initialFrameForViewController:fromVC];
    fromVCRect.origin.y = fromVCRect.size.height - 0;
    // tip: there is already fake view on top of picker
    self.miniView.alpha = 0.f;
    // setup container
    [container addSubview:toVC.view];
    [container addSubview:fromVC.view];
    
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        fromVC.view.frame = fromVCRect;
    } completion:^(BOOL finished) {
        self.miniView.alpha = 1.f; // restore original mini
        [self.fakeView removeFromSuperview];
        self.fakeView = nil;
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
            [toVC.view removeFromSuperview];
        } else {
            [transitionContext completeTransition:YES];
        }
    }];
}

- (UIView *)createFakeMiniView
{
    UIView* dummyView = [[UIImageView alloc] initWithImage:[self.class makeSnapshotOfView:self.miniView]];
    return dummyView;
}

+ (UIImage*)makeSnapshotOfView:(UIView*)sourceView {
    
    UIGraphicsBeginImageContext(sourceView.bounds.size);
    
    [sourceView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

@end
