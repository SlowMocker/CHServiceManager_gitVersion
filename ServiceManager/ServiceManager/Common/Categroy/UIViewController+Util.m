//
//  UIViewController+Util.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "UIViewController+Util.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"
#import <UIAlertView+Blocks.h>

@implementation UIViewController (Util)

- (void)setBackGroundColor:(UIColor *)backGroundColor
{
    [self.view setBackgroundColor:backGroundColor];
}

- (UIColor*)backGroundColor
{
    return self.view.backgroundColor;
}

- (BOOL)setBackGroundImage:(UIImage *)backGroundImage
{
    ReturnIf(nil == backGroundImage) NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:backGroundImage];
    return YES;
}

-(void)pushViewController:(UIViewController*)vc
{
    if (nil != vc) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(UIViewController*)popViewController
{
    return [self popViewControllerWithAnimate:YES];
}

-(UIViewController*)popViewControllerWithAnimate:(BOOL)animated
{
    NSArray *vcs = self.navigationController.viewControllers;

    if (vcs.count > 1) {
        UIViewController *layer2Vc = [vcs objectAtIndex:1];
        if (layer2Vc == self) {
            UIViewController *layer1Vc = [vcs objectAtIndex:0];
            layer1Vc.hidesBottomBarWhenPushed = NO;
        }
    }
    return [self.navigationController popViewControllerAnimated:animated];
}

-(NSArray*)popToRootViewController
{
    UIViewController *vc = [self.navigationController.viewControllers firstObject];
    vc.hidesBottomBarWhenPushed = NO;
    return [self.navigationController popToRootViewControllerAnimated:YES];
}

-(NSArray*)popTo:(UIViewController*)popVc
{
    NSArray *vcs = self.navigationController.viewControllers;

    if (popVc == [vcs objectAtIndex:0]) {
        popVc.hidesBottomBarWhenPushed = NO;
    }

    return [self.navigationController popToViewController:popVc animated:YES];
}

- (void)setNavBarBackgroundColor:(UIColor*)color
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.translucent = NO;
    [navigationBar setBarTintColor:color];
}

- (void)setNavBarLeftView:(UIView*)customLeftView
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customLeftView];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)clearNavBarLeftView
{
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)setNavBarTitleView:(UIView*)customTitleView
{
    self.navigationItem.titleView = customTitleView;
}

- (void)setNavBarRightView:(UIView*)customRightView
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customRightView];

    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)setNavBarLeftButton:(UIImage*)normalImage highlighted:(UIImage*)pressedImage clicked:(SEL)selector
{
    CGRect frame = CGRectMake(0, 0, 40, 44);
    UIButton *defaultLeftButton = [[UIButton alloc]initWithFrame:frame];
    ClearBackgroundColor(defaultLeftButton);

    [defaultLeftButton setImage:normalImage forState:UIControlStateNormal];
    [defaultLeftButton setImage:pressedImage forState:UIControlStateHighlighted];

    if (nil != selector) {
        [defaultLeftButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }

    [self setNavBarLeftView:defaultLeftButton];
}

- (UIButton*)setNavBarRightButton:(UIImage*)normalImage highlighted:(UIImage*)pressedImage clicked:(SEL)selector
{
    return [self setNavBarRightButton:normalImage highlighted:pressedImage selected:pressedImage clicked:selector];
}

- (UIButton*)setNavBarRightButton:(UIImage*)normalImage highlighted:(UIImage*)pressedImage selected:(UIImage*)selectImage clicked:(SEL)selector
{
    CGRect frame = CGRectMake(0, 0, 40, 44);
    UIButton *defaultRightButton = [[UIButton alloc]initWithFrame:frame];
    ClearBackgroundColor(defaultRightButton);

    [defaultRightButton setImage:normalImage forState:UIControlStateNormal];
    [defaultRightButton setImage:pressedImage forState:UIControlStateHighlighted];
    [defaultRightButton setImage:selectImage forState:UIControlStateSelected];

    if (nil != selector) {
        [defaultRightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }

    [self setNavBarRightView:defaultRightButton];

    return defaultRightButton;
}

- (UIButton*)setNavBarLeftButton:(NSString*)title clicked:(SEL)selector
{
    CGRect frame = CGRectMake(0, 0, 40, 44);
    UIButton *defaultLeftButton = [[UIButton alloc]initWithFrame:frame];
    ClearBackgroundColor(defaultLeftButton);
    [defaultLeftButton.titleLabel setFont:SystemFont(15)];
    [defaultLeftButton setTitle:title forState:UIControlStateNormal];
    [defaultLeftButton setTitleColor:kColorDefaultOrange forState:UIControlStateNormal];
    if (nil != selector) {
        [defaultLeftButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    [defaultLeftButton sizeToFit];

    [self setNavBarLeftView:defaultLeftButton];
    
    return defaultLeftButton;
}

- (UIButton*)setNavBarRightButton:(NSString*)title clicked:(SEL)selector
{
    CGRect frame = CGRectMake(0, 0, 80, 44);
    UIButton *defaultRightButton = [[UIButton alloc]initWithFrame:frame];
    ClearBackgroundColor(defaultRightButton);
    defaultRightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [defaultRightButton.titleLabel setFont:SystemFont(15)];
    [defaultRightButton setTitle:title forState:UIControlStateNormal];
    [defaultRightButton setTitleColor:kColorWhite forState:UIControlStateNormal];
    [defaultRightButton setTitleColor:kColorLightGray forState:UIControlStateDisabled];
    if (nil != selector) {
        [defaultRightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    [defaultRightButton sizeToFit];

    [self setNavBarRightView:defaultRightButton];
    
    return defaultRightButton;
}

- (void)setNavBarRightButton:(NSString*)title titleColor:(UIColor *)color clicked:(SEL)selector;
{
    CGRect frame = CGRectMake(0, 0, 100, 44);
    UIButton *defaultRightButton = [[UIButton alloc]initWithFrame:frame];
    ClearBackgroundColor(defaultRightButton);
    defaultRightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [defaultRightButton.titleLabel setFont:SystemFont(15)];
    [defaultRightButton setTitle:title forState:UIControlStateNormal];
    [defaultRightButton setTitleColor:color forState:UIControlStateNormal];
    if (nil != selector) {
        [defaultRightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self setNavBarRightView:defaultRightButton];
}

- (void)setTitleColor:(UIColor*)color
{
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc]init];
    [attrs setObject:color forKey:NSForegroundColorAttributeName];

    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
}

- (UIBarButtonItem*)makeImageButtonItem:(NSString*)imageName target:(id)target action:(SEL)action
{
    UIButton *itemButton;
    
    itemButton = [UIButton imageButtonWithNorImg:imageName selImg:imageName size:CGSizeMake(28, 40) target:target action:action];
    
    return [[UIBarButtonItem alloc]initWithCustomView:itemButton];
}

@end
