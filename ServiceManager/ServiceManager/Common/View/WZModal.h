//
//  WZModal.h
//  WZModal
//
//  Created by David Keegan on 10/5/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const WZModalWillShowNotification;
extern NSString *const WZModalDidShowNotification;
extern NSString *const WZModalWillHideNotification;
extern NSString *const WZModalDidHideNotification;

typedef NS_ENUM(NSUInteger, WZModalContentViewLocation)
{
    WZModalContentViewLocationMiddle = 0,
    WZModalContentViewLocationTop,
    WZModalContentViewLocationLeft,
    WZModalContentViewLocationBottom,
    WZModalContentViewLocationRight,
    WZModalContentViewLocationCustom   //use content view's frame
};

typedef NS_ENUM(NSUInteger, WZModalBackgroundDisplayStyle){
    WZModalBackgroundDisplayStyleGradient,
    WZModalBackgroundDisplayStyleSolid
};

typedef NS_ENUM(NSUInteger, WZModalCloseButtonLocation){
    WZModalCloseButtonLocationLeft,
    WZModalCloseButtonLocationRight
};

@interface WZModal : NSObject

// Determines the content view' location
@property (nonatomic) WZModalContentViewLocation contentViewLocation;

// Determines if the modal should dismiss if the user taps outside of the modal view
// Defaults to YES
@property (nonatomic) BOOL tapOutsideToDismiss;

//call it when user tap out side or click close button
@property (nonatomic, strong)VoidBlock onTapOutsideBlock;

// Determines if the close button or tapping outside the modal should animate the dismissal
// Defaults to YES
@property (nonatomic) BOOL animateWhenDismissed;

// Determines if the close button is shown
// Defaults to YES
@property (nonatomic) BOOL showCloseButton;

// Determines whether close button will display on the left or right
// Defaults to left
@property (nonatomic) WZModalCloseButtonLocation closeButtonLocation;

// The background color of the modal window
// Defaults black with 0.5 opacity
@property (strong, nonatomic) UIColor *modalBackgroundColor;

// The background display style, can be a transparent radial gradient or a transparent black
// Defaults to gradient, this looks better but takes a bit more time to display on the retina iPadk
@property (nonatomic) WZModalBackgroundDisplayStyle backgroundDisplayStyle;

// Determines if the modal should rotate when the device rotates
// Defaults to YES, only applies to iOS5
@property (nonatomic) BOOL shouldRotate;

// whether view is showing or not
@property (nonatomic) BOOL isShowing;

// The shared instance of the modal
+ (instancetype)sharedInstance;

// Set the content view to display in the modal and display with animations
- (void)showWithContentView:(UIView *)contentView;

// Set the content view to display in the modal and whether the modal should animate in
- (void)showWithContentView:(UIView *)contentView andAnimated:(BOOL)animated;

// Set the content view controller to display in the modal and display with animations
- (void)showWithContentViewController:(UIViewController *)contentViewController;

// Set the content view controller to display in the modal and whether the modal should animate in
- (void)showWithContentViewController:(UIViewController *)contentViewController andAnimated:(BOOL)animated;

// Hide the modal with animations
- (void)hide;

// Hide the modal with animations,
// run the completion after the modal is hidden
- (void)hideWithCompletionBlock:(void(^)())completion;

// Hide the modal and whether the modal should animate away
- (void)hideAnimated:(BOOL)animated;

// Hide the modal and whether the modal should animate away,
// run the completion after the modal is hidden
- (void)hideAnimated:(BOOL)animated withCompletionBlock:(void(^)())completion;

@end
