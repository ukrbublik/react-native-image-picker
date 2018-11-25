#import "BaseAnimator.h"
#import "DummyView.h"

@interface MiniToLargeViewAnimator : BaseAnimator

@property (nonatomic, weak) DummyView* dummyView;
@property (nonatomic) BOOL isOnTap;

@end
