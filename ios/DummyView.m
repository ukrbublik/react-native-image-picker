#import "DummyView.h"

const CGFloat MyButtonStayHightlightDelay = 0.5f;
const CGFloat MyButtonHightlightAlpha = 0.1f;

//----

// Simple impl of button that stays highlighed for 0.5s (to prevent quick changin of highlight on pan gesture recognizing)

@interface MyButton : UIButton
@end

@implementation MyButton

- (void)_setHighlighted:(NSNumber*)highlighted {
    [super setHighlighted:[highlighted boolValue]];
}

- (void)setHighlighted:(BOOL)highlighted {
    if (self.highlighted && !highlighted) {
        [super performSelector:@selector(_setHighlighted:) withObject:[NSNumber numberWithBool:highlighted] afterDelay:MyButtonStayHightlightDelay];
    } else {
        [super setHighlighted:highlighted];
    }
}

@end

//----

@interface DummyView ()
@end


@implementation DummyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

- (void)addMiniViewSnapshot:(UIImage*)img
{
    [self.button removeFromSuperview];
    MyButton *bottomButton = [MyButton buttonWithType:UIButtonTypeCustom];
    UIImage* img2 = [self.class colorizeImage:img withColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:MyButtonHightlightAlpha]];
    [bottomButton setImage:img forState:UIControlStateNormal];
    [bottomButton setImage:img2 forState:UIControlStateHighlighted];
    bottomButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bottomButton];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:bottomButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bottomButton.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:bottomButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomButton.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    self.button = bottomButton;
}

- (DummyView*)cloneForPresinting:(BOOL)forPresenting {
    DummyView* cl = [DummyView new];
    [cl setFrame:self.frame];
    MyButton *bottomButton = [MyButton buttonWithType:UIButtonTypeCustom];
    UIImage* img = [self.button imageForState:UIControlStateNormal];
    UIImage* img2 = [self.button imageForState:UIControlStateHighlighted];
    [bottomButton setImage:img forState:UIControlStateNormal];
    [bottomButton setImage:img2 forState:UIControlStateHighlighted];
    [cl addSubview:bottomButton];
    bottomButton.translatesAutoresizingMaskIntoConstraints = NO;
    [cl addConstraint:[NSLayoutConstraint constraintWithItem:bottomButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bottomButton.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [cl addConstraint:[NSLayoutConstraint constraintWithItem:bottomButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomButton.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    cl.button = bottomButton;
    return cl;
}

// https://stackoverflow.com/questions/12380288/ios-create-an-darker-version-of-uiimage-and-leave-transparent-pixels-unchanged
+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, area, image.CGImage);
    
    [color set];
    CGContextFillRect(context, area);
    
    CGContextRestoreGState(context);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    
    CGContextDrawImage(context, area, image.CGImage);
    
    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return colorizedImage;
}

@end
