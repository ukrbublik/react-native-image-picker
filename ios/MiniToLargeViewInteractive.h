#import <UIKit/UIKit.h>
#import "DummyView.h"

@interface MiniToLargeViewInteractive : UIPercentDrivenInteractiveTransition

@property (nonatomic) UIViewController *viewController;
@property (nonatomic) UIViewController *presentViewController;
@property (nonatomic) UIPanGestureRecognizer *pan;

- (void)attachToViewController:(UIViewController *)viewController withSwipeView:(UIView *)swipeView withMiniView:(DummyView *)miniView presentViewController:(UIViewController *)presentViewController;
- (void)detach;

@end
