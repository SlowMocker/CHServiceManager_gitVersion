//
//  CallingHelper.m
//  ServiceManager
//
//  Created by will.wang on 15/9/23.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "CallingHelper.h"

@interface CallingHelper()<UIActionSheetDelegate>
{
    UIActionSheet *_actionSheet;
}
@property(nonatomic, strong)NSArray *telphoneArray;
@property(nonatomic, strong)ViewController *currentViewController;
@end

@implementation CallingHelper

+ (instancetype)sharedInstance
{
    static CallingHelper *sCallingHelper = nil;
    static dispatch_once_t sOnceToken;
    dispatch_once(&sOnceToken, ^{
        sCallingHelper = [[CallingHelper alloc]init];
    });
    return sCallingHelper;
}

+ (void)startCalling:(NSString*)telOrMobileNo fromViewController:(ViewController*)currentViewController
{
    ReturnIf([Util isEmptyString:telOrMobileNo]);
    
    if ([telOrMobileNo isEqualToString:currentViewController.user.mobile]) {
        [Util showToast:@"不能给自已拔打电话"];
    }else {
        [Util makePhoneCallWithNumber:telOrMobileNo];
    }
}

+ (void)startCallings:(NSArray*)telArray fromViewController:(ViewController*)currentViewController
{
    CallingHelper *helper = [CallingHelper sharedInstance];
    helper.currentViewController = currentViewController;

    [helper selectNumberAndCall:telArray fromViewController:currentViewController];
}

- (void)selectNumberAndCall:(NSArray*)telArray fromViewController:(ViewController*)currentViewController
{
    ReturnIf(!telArray ||telArray.count <= 0);
    
    self.telphoneArray = telArray;
    
    if (1 == telArray.count) {
        [[self class] startCalling:telArray[0] fromViewController:currentViewController];
    }else {
        _actionSheet = [[UIActionSheet alloc]initWithTitle:@"拨打电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSString *telNumber in telArray) {
            [_actionSheet addButtonWithTitle:telNumber];
        }

        [_actionSheet showFromRect:currentViewController.view.bounds inView:currentViewController.view animated:YES];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ReturnIf(buttonIndex == actionSheet.cancelButtonIndex);

    if (self.telphoneArray.count >= buttonIndex) {
        NSString *callNo = self.telphoneArray[buttonIndex-1];
        [[self class]startCalling:callNo fromViewController:self.currentViewController];
    }
}

@end
