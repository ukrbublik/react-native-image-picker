#import "MiniToLargeViewAnimator.h"

static NSTimeInterval kAnimationDuration = .4f;


@interface MiniToLargeViewAnimator()

@property (nonatomic, strong) DummyView *fakeView;

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
    UIView* container = [transitionContext containerView];
    UIViewController* rootVC = fromVC;
    UIViewController* pickerVC = toVC;
    // setup initial & target frames
    CGRect rootRect = [transitionContext initialFrameForViewController:rootVC];
    CGRect pickerRectTo = rootRect;
    CGRect pickerRect = CGRectMake(rootRect.origin.x, rootRect.origin.y, rootRect.size.width, rootRect.size.height);
    pickerRect.origin.y = rootRect.size.height;
    [pickerVC.view setFrame:pickerRect];
    // replace original mini view to fake, move fake on top of picker
    self.fakeView = [self createFakeDummyViewForPresinting:YES];
    [self.fakeView.button setHighlighted:YES];
    self.fakeView.alpha = 1.0f;
    self.dummyView.alpha = 0.f;
    CGRect fakeRect = self.fakeView.frame;
    CGRect fakeRectTo = CGRectMake(fakeRect.origin.x, fakeRect.origin.y, fakeRect.size.width, fakeRect.size.height);
    fakeRect.origin.y = rootRect.size.height - self.fakeView.frame.size.height;
    fakeRectTo.origin.y = - self.fakeView.frame.size.height;
    [self.fakeView setFrame:fakeRect];
    // setup container
    [container addSubview:fromVC.view];
    [container addSubview:toVC.view];
    [container addSubview:self.fakeView];
     
    //tip: big delay is required to prevent unwanted presenting of VC at the beginning
    [UIView animateWithDuration:kAnimationDuration delay:(self.isOnTap ? 0 : 2.0) options:UIViewAnimationOptionCurveLinear animations:^{
        [pickerVC.view setFrame:pickerRectTo];
        [self.fakeView setFrame:fakeRectTo];
    } completion:^(BOOL finished) {
        self.dummyView.alpha = 1.f; // restore original mini
        [self.fakeView removeFromSuperview];
        self.fakeView = nil;
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
    UIViewController* pickerVC = fromVC;
    UIViewController* rootVC = toVC;
    // setup initial & target frames
    CGRect pickerRect = [transitionContext initialFrameForViewController:pickerVC];
    CGRect rootRect = rootVC.view.frame;
    CGRect pickerRectTo = CGRectMake(pickerRect.origin.x, pickerRect.origin.y, pickerRect.size.width, pickerRect.size.height);
    pickerRectTo.origin.y = pickerRect.size.height;
    self.fakeView = [self createFakeDummyViewForPresinting:NO];
    [self.fakeView.button setHighlighted:NO];
    CGRect fakeRect = self.fakeView.frame;
    fakeRect.origin.y = - self.fakeView.frame.size.height;
    CGRect fakeRectTo = CGRectMake(fakeRect.origin.x, fakeRect.origin.y, fakeRect.size.width, fakeRect.size.height);
    fakeRectTo.origin.y = rootRect.size.height - self.fakeView.frame.size.height;
    [self.fakeView setFrame:fakeRect];
    self.fakeView.alpha = 1.0f;
    self.dummyView.alpha = 0.f;
    // setup container
    [container addSubview:toVC.view];
    [container addSubview:fromVC.view];
    [container addSubview:self.fakeView];
    
    [UIView animateWithDuration:kAnimationDuration delay:(self.isOnTap ? 0 : 0.1) options:UIViewAnimationOptionCurveLinear animations:^{
        [pickerVC.view setFrame:pickerRectTo];
        [self.fakeView setFrame:fakeRectTo];
    } completion:^(BOOL finished) {
        self.dummyView.alpha = 1.f; // restore original mini
        [self.fakeView removeFromSuperview];
        self.fakeView = nil;
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
            //[toVC.view removeFromSuperview]; //?
        } else {
            [transitionContext completeTransition:YES];
        }
    }];
}

- (DummyView*) createFakeDummyViewForPresinting:(BOOL)forPresenting
{
    DummyView* dummyView = [self.dummyView cloneForPresinting:forPresenting];
    return dummyView;
}

@end
