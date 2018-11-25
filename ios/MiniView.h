#import <React/UIView+React.h>
#import <React/RCTView.h>

@interface MiniView : RCTView

@property (nonatomic, copy) RCTBubblingEventBlock onUsed;

@end
