#import <UIKit/UIKit.h>

@interface DummyView : UIView

@property (nonatomic, weak) UIButton *button;

- (void)addMiniViewSnapshot:(UIImage*)img;
- (DummyView*)cloneForPresinting:(BOOL)forPresenting;

@end
