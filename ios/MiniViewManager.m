#import <React/RCTBridge.h>
#import <React/RCTConvert.h>
#import <React/RCTUIManager.h>
#import "MiniViewManager.h"
#import "MiniView.h"
#import "ImagePickerManager.h"

@implementation MiniViewManager


RCT_EXPORT_MODULE();

//- (dispatch_queue_t)methodQueue
//{
//    return dispatch_get_main_queue();
//}

- (UIView *)view
{
    return [[MiniView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(onUsed, RCTBubblingEventBlock)

RCT_EXPORT_METHOD(use:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        MiniView* view = (MiniView*) viewRegistry[reactTag];
        view.alpha = 1;
        ImagePickerManager* manager = [self.bridge moduleForClass:ImagePickerManager.class];
        dispatch_async(dispatch_get_main_queue(), ^{
            // replace
            [manager setMiniView:view];
            // hide orig
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
                view.alpha = 0;
            });
            // don't render anymore
            if (view.onUsed)
                view.onUsed(@{});
        });
    }];
}

@end
