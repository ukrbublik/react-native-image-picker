#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ModalAnimatedTransitioningType) {
    ModalAnimatedTransitioningTypePresent,
    ModalAnimatedTransitioningTypeDismiss
};

@interface BaseAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) ModalAnimatedTransitioningType transitionType;

- (void)animatePresentingInContext:(id<UIViewControllerContextTransitioning>)transitionContext toVC:(UIViewController *)toVC fromVC:(UIViewController *)fromVC;
- (void)animateDismissingInContext:(id<UIViewControllerContextTransitioning>)transitionContext toVC:(UIViewController *)toVC fromVC:(UIViewController *)fromVC;

@end
