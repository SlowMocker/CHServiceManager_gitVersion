//
//  WZModal.m
//  WZModal
//
//  Created by David Keegan on 10/5/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "WZModal.h"
#import <QuartzCore/QuartzCore.h>

CGFloat const kWZFadeInAnimationDuration = 0.3;
CGFloat const kWZTransformPart1AnimationDuration = 0.2;
CGFloat const kWZTransformPart2AnimationDuration = 0.1;
NSString *const WZModalGradientViewTapped = @"WZModalGradientViewTapped";

NSString *const WZModalWillShowNotification = @"WZModalWillShowNotification";
NSString *const WZModalDidShowNotification = @"WZModalDidShowNotification";
NSString *const WZModalWillHideNotification = @"WZModalWillHideNotification";
NSString *const WZModalDidHideNotification = @"WZModalDidHideNotification";

@interface WZModalGradientView : UIView
@end

@interface WZModalContainerView : UIView
@property (weak, nonatomic) CALayer *styleLayer;
@property (strong, nonatomic) UIColor *modalBackgroundColor;
@end

@interface WZModalCloseButton : UIButton
@end

@interface WZModalViewController : UIViewController
@property (weak, nonatomic) WZModalGradientView *styleView;
@end

@interface WZModal()
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *contentViewController;
@property (weak, nonatomic) WZModalViewController *viewController;
@property (weak, nonatomic) WZModalContainerView *containerView;
@property (weak, nonatomic) WZModalCloseButton *closeButton;
@property (weak, nonatomic) UIView *contentView;

@end

@implementation WZModal

+ (instancetype)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    if(!(self = [super init])){
        return nil;
    }

    self.shouldRotate = YES;
    self.tapOutsideToDismiss = YES;
    self.animateWhenDismissed = YES;
    self.closeButtonLocation = WZModalCloseButtonLocationLeft;
    self.showCloseButton = YES;
    self.modalBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

    return self;
}

- (void)setShowCloseButton:(BOOL)showCloseButton{
    if(_showCloseButton != showCloseButton){
        _showCloseButton = showCloseButton;
        [self.closeButton setHidden:!self.showCloseButton];
    }
}

- (void)showWithContentView:(UIView *)contentView{
    [self showWithContentView:contentView andAnimated:YES];
}

- (void)showWithContentViewController:(UIViewController *)contentViewController{
    [self showWithContentViewController:contentViewController andAnimated:YES];
}

- (void)showWithContentViewController:(UIViewController *)contentViewController andAnimated:(BOOL)animated{
    self.contentViewController = contentViewController;
    [self showWithContentView:contentViewController.view andAnimated:YES];
}

- (void)showWithContentView:(UIView *)contentView andAnimated:(BOOL)animated {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;

    WZModalViewController *viewController = [[WZModalViewController alloc] init];
    self.window.rootViewController = viewController;
    self.viewController = viewController;

    CGRect containerViewRect = [self calculateContentViewRect:contentView];
    WZModalContainerView *containerView = [[WZModalContainerView alloc] initWithFrame:containerViewRect];
    containerView.modalBackgroundColor = self.modalBackgroundColor;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    contentView.frame = (CGRect){0, 0, contentView.bounds.size};
    [containerView addSubview:contentView];
    [viewController.view addSubview:containerView];
    self.containerView = containerView;

    WZModalCloseButton *closeButton = [[WZModalCloseButton alloc] init];

    if(self.closeButtonLocation == WZModalCloseButtonLocationRight){
        CGRect closeFrame = closeButton.frame;
        closeFrame.origin.x = CGRectGetWidth(containerView.bounds)-CGRectGetWidth(closeFrame);
        closeButton.frame = closeFrame;
    }

    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setHidden:!self.showCloseButton];
    [containerView addSubview:closeButton];
    self.closeButton = closeButton;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapCloseAction:)
                                                 name:WZModalGradientViewTapped object:nil];

    // The window has to be un-hidden on the main thread
    // This will cause the window to display
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:WZModalWillShowNotification object:self];
        [self.window makeKeyAndVisible];

        if(animated){
            [self addDefaultAnimation:containerView];
#if 0
            viewController.styleView.alpha = 0;
            [UIView animateWithDuration:kWZFadeInAnimationDuration animations:^{
                viewController.styleView.alpha = 1;
            }];

            containerView.alpha = 0;
            containerView.layer.shouldRasterize = YES;
            containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            [UIView animateWithDuration:kWZTransformPart1AnimationDuration animations:^{
                containerView.alpha = 1;
                containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kWZTransformPart2AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    containerView.alpha = 1;
                    containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                } completion:^(BOOL finished2) {
                    containerView.layer.shouldRasterize = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:WZModalDidShowNotification object:self];
                }];
            }];
#endif
        }
    });
    self.isShowing = YES;
}

- (void)closeAction:(id)sender{
    if (nil != self.onTapOutsideBlock) {
        self.onTapOutsideBlock();
    }
    [self hideAnimated:self.animateWhenDismissed];
}

- (void)tapCloseAction:(id)sender{
    if (nil != self.onTapOutsideBlock) {
        self.onTapOutsideBlock();
    }
    if(self.tapOutsideToDismiss){
        [self hideAnimated:self.animateWhenDismissed withCompletionBlock:nil];
    }
}

- (void)hide{
    [self hideAnimated:YES];
}

- (void)hideWithCompletionBlock:(void(^)())completion{
    [self hideAnimated:YES withCompletionBlock:completion];
}

- (void)hideAnimated:(BOOL)animated{
    [self hideAnimated:animated withCompletionBlock:nil];
}

- (void)hideAnimated:(BOOL)animated withCompletionBlock:(void(^)())completion{
    if(!animated){
        [self cleanup];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:WZModalWillHideNotification object:self];

#if 0
        [UIView animateWithDuration:kWZFadeInAnimationDuration animations:^{
            self.viewController.styleView.alpha = 0;
        }];

        self.containerView.layer.shouldRasterize = YES;
        [UIView animateWithDuration:kWZTransformPart2AnimationDuration animations:^{
            self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:kWZTransformPart1AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.containerView.alpha = 0;
                self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            } completion:^(BOOL finished2){
                [self cleanup];
                if(completion){
                    completion();
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:WZModalDidHideNotification object:self];
            }];
        }];
#else
        [UIView animateWithDuration:kWZFadeInAnimationDuration animations:^{
            self.viewController.styleView.alpha = 0;
        }];

        [UIView animateWithDuration:kWZFadeInAnimationDuration animations:^{
            self.containerView.frame = [self calculateContentViewBeginRect:self.containerView];
        } completion:^(BOOL finished) {
            [self cleanup];
            if(completion){
                completion();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:WZModalDidHideNotification object:self];
        }];
#endif
    });
}

- (void)cleanup{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.containerView removeFromSuperview];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
    [self.window removeFromSuperview];
    self.contentViewController = nil;
    self.window = nil;
    self.isShowing = NO;
}

- (void)addDefaultAnimation:(UIView*)contentView
{
    self.viewController.styleView.alpha = 0;
    [UIView animateWithDuration:kWZFadeInAnimationDuration animations:^{
        self.viewController.styleView.alpha = 1;
    }];

    self.containerView.frame = [self calculateContentViewBeginRect:contentView];
    [UIView animateWithDuration:kWZFadeInAnimationDuration animations:^{
        self.containerView.frame = [self calculateContentViewRect:contentView];
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WZModalDidShowNotification object:self];
    }];
}

- (CGRect)calculateContentViewBeginRect:(UIView*)contentView
{
    CGRect contentFrame = contentView.frame;

    switch (self.contentViewLocation) {
        case WZModalContentViewLocationTop:
            contentFrame.origin.y = -CGRectGetHeight(contentView.frame);
            break;
        case WZModalContentViewLocationBottom:
            contentFrame.origin.y = CGRectGetHeight(self.window.frame)+ CGRectGetHeight(contentView.frame);
            break;
        case WZModalContentViewLocationLeft:
            contentFrame.origin.x = -CGRectGetWidth(contentView.frame);
            break;
        case WZModalContentViewLocationRight:
            contentFrame.origin.x = CGRectGetWidth(self.window.frame)+ CGRectGetWidth(contentView.frame);
            break;
        case WZModalContentViewLocationMiddle:
        case WZModalContentViewLocationCustom:
            break;
        default:
            break;
    }

    return contentFrame;
}

- (CGRect)calculateContentViewRect:(UIView*)contentView
{
    CGSize wndSize = [[UIScreen mainScreen]bounds].size;
    CGRect contentFrame = contentView.frame;

    switch (self.contentViewLocation) {
        case WZModalContentViewLocationTop:
            contentFrame.origin.y = 0;
            break;
        case WZModalContentViewLocationLeft:
            contentFrame.origin.x = 0;
            break;
        case WZModalContentViewLocationBottom:
            contentFrame.origin.y = wndSize.height - CGRectGetHeight(contentView.frame);
            break;
        case WZModalContentViewLocationRight:
            contentFrame.origin.x = wndSize.width - CGRectGetWidth(contentView.frame);
            break;
        case WZModalContentViewLocationMiddle:
            contentFrame.origin.x = (wndSize.width - CGRectGetWidth(contentView.frame))/2;
            contentFrame.origin.y = (wndSize.height - CGRectGetHeight(contentView.frame))/2;
            break;
        case WZModalContentViewLocationCustom:
            break;
        default:
            break;
    }

    return contentFrame;
}

- (void)setModalBackgroundColor:(UIColor *)modalBackgroundColor{
    if(_modalBackgroundColor != modalBackgroundColor){
        _modalBackgroundColor = modalBackgroundColor;
        self.containerView.modalBackgroundColor = modalBackgroundColor;
    }
}

- (void)dealloc{
    [self cleanup];
}

@end

@implementation WZModalViewController

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    WZModalGradientView *styleView = [[WZModalGradientView alloc] initWithFrame:self.view.bounds];
    styleView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    styleView.opaque = NO;
    [self.view addSubview:styleView];
    self.styleView = styleView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return [[WZModal sharedInstance] shouldRotate];
}

- (BOOL)shouldAutorotate{
    return [[WZModal sharedInstance] shouldRotate];
}

@end

@implementation WZModalContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    if(!(self = [super initWithFrame:frame])){
        return nil;
    }

    CALayer *styleLayer = [[CALayer alloc] init];
    styleLayer.cornerRadius = 4;
    styleLayer.shadowColor= [[UIColor blackColor] CGColor];
    styleLayer.shadowOffset = CGSizeMake(0, 0);
    styleLayer.shadowOpacity = 0.5;
    styleLayer.borderWidth = 1;
    styleLayer.borderColor = [[UIColor whiteColor] CGColor];
    styleLayer.frame = CGRectInset(self.bounds, 12, 12);
    [self.layer addSublayer:styleLayer];
    self.styleLayer = styleLayer;

    return self;
}

- (void)setModalBackgroundColor:(UIColor *)modalBackgroundColor{
    if(_modalBackgroundColor != modalBackgroundColor){
        _modalBackgroundColor = modalBackgroundColor;
        self.styleLayer.backgroundColor = [modalBackgroundColor CGColor];
    }
}

@end

@implementation WZModalGradientView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:WZModalGradientViewTapped object:nil];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if([[WZModal sharedInstance] backgroundDisplayStyle] == WZModalBackgroundDisplayStyleSolid){
        [[UIColor colorWithWhite:0 alpha:0.55] set];
        CGContextFillRect(context, self.bounds);
    }else{
        CGContextSaveGState(context);
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        CGFloat gradColors[8] = {0, 0, 0, 0.3, 0, 0, 0, 0.8};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        CGColorSpaceRelease(colorSpace), colorSpace = NULL;
        CGPoint gradCenter= CGPointMake(round(CGRectGetMidX(self.bounds)), round(CGRectGetMidY(self.bounds)));
        CGFloat gradRadius = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient), gradient = NULL;
        CGContextRestoreGState(context);
    }
}

@end

@implementation WZModalCloseButton

- (instancetype)init{
    if(!(self = [super initWithFrame:(CGRect){0, 0, 32, 32}])){
        return nil;
    }
    static UIImage *closeButtonImage;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        closeButtonImage = [self closeButtonImage];
    });
    [self setBackgroundImage:closeButtonImage forState:UIControlStateNormal];
    return self;
}

- (UIImage *)closeButtonImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);

    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// Color Declarations
    UIColor *topGradient = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:0.9];
    UIColor *bottomGradient = [UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:0.9];

    //// Gradient Declarations
    NSArray *gradientColors = @[(id)topGradient.CGColor,
                                (id)bottomGradient.CGColor];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);

    //// Shadow Declarations
    CGColorRef shadow = [UIColor blackColor].CGColor;
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = 3;
    CGColorRef shadow2 = [UIColor blackColor].CGColor;
    CGSize shadow2Offset = CGSizeMake(0, 1);
    CGFloat shadow2BlurRadius = 0;


    //// Oval Drawing
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(4, 3, 24, 24)];
    CGContextSaveGState(context);
    [ovalPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(16, 3), CGPointMake(16, 27), 0);
    CGContextRestoreGState(context);

    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
    [[UIColor whiteColor] setStroke];
    ovalPath.lineWidth = 2;
    [ovalPath stroke];
    CGContextRestoreGState(context);


    //// Bezier Drawing
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(18.83, 15)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(16, 17.83)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(13.17, 15)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(16, 12.17)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
    [[UIColor whiteColor] setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);

    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
