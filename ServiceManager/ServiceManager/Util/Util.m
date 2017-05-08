//
//  Util.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-10.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "Util.h"
#import "RSAForiOS.h"
#import "YRSideViewController.h"
#import "AppDelegate.h"
#import "ShareSdkManager.h"
#import <MBProgressHUD.h>
#import <UIAlertView+Blocks.h>

@implementation Util

+ (NSString*)defaultStr:(NSString*)dftStr ifStrEmpty:(NSString*)srcStr
{
    return [Util isEmptyString:srcStr] ? dftStr : srcStr;
}

+ (BOOL)isEmptyString:(NSString *)str
{
    return  str == nil || [str isKindOfClass:[NSNull class]] || str.length == 0 || [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 || [str stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0 || [str isEqualToString:@"null"];
}

//解析用户登录信息，并同步到本地存储
+ (BOOL)syncUserInfo:(id)resultData loginInfo:(LoginInputParams*)loginInfo
{
    BOOL updateSuccess = NO;

    ReturnIf(!resultData || ![resultData isKindOfClass:[NSDictionary class]])updateSuccess;

    NSDictionary *userDic = (NSDictionary*)resultData;
    UserInfoEntity *user = [UserInfoEntity sharedInstance];

    user.userName = loginInfo.userid;
    user.password = loginInfo.password;
    user.userRoleType = (kUserRoleType)[loginInfo.userrole integerValue];
    user.serverId = [userDic objForKey:@"sermanagerId"];
    user.tripleDesKey = [userDic objForKey:ksEncryptKey];
    user.userId = [userDic objForKey:@"userid"];
    user.lastLoginDate = [userDic doubleForKey:ksLastLoginDate];
    user.mobile = [userDic objForKey:@"telephone"];
    user.registerDate = [userDic doubleForKey:ksRegisterDate];
    user.nickName = [userDic objForKey:@"realname"];
    user.token = [userDic objForKey:ksToken];
    user.avatar = [userDic objForKey:ksAvatar];
    user.isCreate = (2 == [userDic integerForKey:@"isCreate"]);

    [user synchronize];

    return YES;
}

#pragma mark 拨打电话

+ (void)makePhoneCallWithNumber:(NSString *)number
{
    NSInteger length = number.length;
    NSString *realNumber = [NSString string];

    for (NSInteger i = 0 ; i <length; i++)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [number substringWithRange:range];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *subnum = [numberFormatter numberFromString:subString];
        if ( subnum || [subString isEqualToString:@"-"])
        {
            realNumber = [realNumber stringByAppendingString:subString];
        }
    }

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"tel://", realNumber]]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"tel://", realNumber]]];
    }
}

+ (NSString*)isValidPasswordStr:(NSString*)pwdStr
{
    if ([Util isEmptyString:pwdStr]) {
        return @"密码不能为空";
    }else {
        return [pwdStr isValidPassword];
    }
}

+ (void)commentAppByAppId:(NSString *)appId
{
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                     appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)showLeftMeVeiwController
{
    YRSideViewController *sideViewController= kAppDelegate.sideViewController;
    sideViewController.leftViewShowWidth = kLeftPopVcWidth;
    [sideViewController showLeftViewController:YES];
}

//用户从本地退出，不请求网络端
+ (void)logoutLocalUser
{
    //清除user数据
    [[UserInfoEntity sharedInstance]exitUser];

    //通知相关目标
    [[UserInfoEntity sharedInstance]postNotification:NotificationNameLogout];
}

+ (void)startLoginViewController
{
    [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:NO];

    [kAppDelegate startLoginViewController];
}

+ (UIButton*)makeVerticalBtn:(NSString*)iconName title:(NSString*)title size:(CGSize)size
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [button clearBackgroundColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:kColorDefaultOrange forState:UIControlStateNormal];
    button.titleLabel.font = SystemFont(13);
    [button setImage:ImageNamed(iconName) forState:UIControlStateNormal];

    [button layoutTopImageBottomTextButton];

    return button;
}

+ (BOOL)str:(NSString*)str1 isEqualTo:(NSString*)str2
{
    return (str1 == str2) || [str1 isEqualToString:str2];
}

+ (NSString*)getErrorDescritpion:(HttpResponseData*)responseData otherError:(NSError*)error
{
    NSString *errStr;
    
    do {
        if (nil != responseData) {
            if (kHttpReturnCodeSuccess == responseData.resultCode) {
                errStr = nil;
                break;
            }else {
                errStr = responseData.resultInfo;
            }
        }else if (nil != error) {
            errStr = error.localizedDescription;
        }
        errStr = [Util defaultStr:@"请求失败" ifStrEmpty:errStr];
    } while (NO);

    return errStr;
}

+ (void)showErrorToastIfError:(HttpResponseData*)responseData otherError:(NSError*)error
{
    ReturnIf(!error && kHttpReturnCodeSuccess == responseData.resultCode);

    NSString *errStr = [[self class] getErrorDescritpion:responseData otherError:error];
    if (errStr) {
        [[self class ]showToast:errStr];
    }
}

+(NSTimeInterval)showToast:(NSString*)content toView:(UIView*)showOnView
{
    ReturnIf([Util isEmptyString:content] || nil == showOnView) 0;
    
    NSTimeInterval duration = kToastShortDurationTime + content.length/10;
    MBProgressHUD *tipHUD = [[MBProgressHUD alloc] initWithView:showOnView];
    tipHUD.detailsLabelText = content;
    tipHUD.mode = MBProgressHUDModeText;
    tipHUD.detailsLabelFont = SystemFont(15);
    [showOnView addSubview:tipHUD];
    
    //show new
    [tipHUD show:YES];
    [tipHUD hide:YES afterDelay:duration];
    
    return duration;
}

+(NSTimeInterval)showToast:(NSString*)content
{
    return [self showToast:content toView:kAppDelegate.window];
}

+ (void)showToast:(NSString *)content if:(BOOL)isTrue
{
    if (isTrue) {
        [self showToast:content];
    }
}

+ (void)showWaitingDialogToView:(UIView*)view
{
    [MBProgressHUD hideHUDForView:view animated:NO];
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (void)dismissWaitingDialogFromView:(UIView*)view
{
    [MBProgressHUD hideHUDForView:view animated:NO];
}

+ (void)showWaitingDialog
{
    UIView *view = kAppDelegate.window;
    [[self class]showWaitingDialogToView:view];
}

+ (void)dismissWaitingDialog
{
    UIView *view = kAppDelegate.window;
    [[self class]dismissWaitingDialogFromView:view];
}

+ (void)showAlertView:(NSString*)title message:(NSString*)message
{
    [[self class]showAlertView:title message:message okAction:nil];
}

+ (void)showAlertView:(NSString*)title message:(NSString*)message okAction:(VoidBlock)okAction
{
    RIButtonItem *cancelBtn = [RIButtonItem itemWithLabel:@"确定" action:okAction];
    UIAlertView *configDialog = [[UIAlertView alloc]initWithTitle:title message:message cancelButtonItem:cancelBtn otherButtonItems:nil];
    [configDialog show];
}

+ (UIAlertView*)confirmAlertView:(NSString*)title message:(NSString*)message confirmTitle:(NSString*)confirmTitle cancelTitle:(NSString*)cancelTitle confirmAction:(VoidBlock)confirmAction
{
    return [[self class]confirmAlertView:title message:message confirmTitle:confirmTitle confirmAction:confirmAction cancelTitle:cancelTitle cancelAction:nil];
}

+ (UIAlertView*)confirmAlertView:(NSString*)title
                 message:(NSString*)message
            confirmTitle:(NSString*)confirmTitle
           confirmAction:(VoidBlock)confirmAction
             cancelTitle:(NSString*)cancelTitle
            cancelAction:(VoidBlock)cancelAction
{
    cancelTitle = [Util defaultStr:@"取消" ifStrEmpty:cancelTitle];
    confirmTitle = [Util defaultStr:@"确定" ifStrEmpty:confirmTitle];

    RIButtonItem *cancelBtn = [RIButtonItem itemWithLabel:cancelTitle action:cancelAction];
    RIButtonItem *confirmBtn = [RIButtonItem itemWithLabel:confirmTitle action:confirmAction];
    
    UIAlertView *configDialog = [[UIAlertView alloc]initWithTitle:title message:message cancelButtonItem:cancelBtn otherButtonItems:confirmBtn, nil];
    
    [configDialog show];
    
    return configDialog;
}

+ (void)confirmAlertView:(NSString*)message confirmAction:(VoidBlock)confirmAction
{
    [[self class]confirmAlertView:nil message:message confirmTitle:@"确定" cancelTitle:@"取消" confirmAction:confirmAction];
}


+ (NSTimeInterval)timeIntervalFromTimeNumStr:(NSString*)timeNumStr
{
    NSDate *date = [[self class]dateWithString:timeNumStr format:@"yyyyMMddHHmmss"];
    return [date timeIntervalSince1970];
}

+ (NSString*)timeTextStringFromTimeNumStr:(NSString*)timeNumStr
{
    ReturnIf([Util isEmptyString:timeNumStr])kUnknown;
    
    NSTimeInterval timeVal = [[self class]timeIntervalFromTimeNumStr:timeNumStr];
    return [NSString dateStringWithInterval:timeVal*1000 formatStr:WZDateStringFormat7];
}

+ (NSDate*)dateWithString:(NSString*)dateStr format:(NSString*)dateStrFormat
{
    ReturnIf([Util isEmptyString:dateStr] || [Util isEmptyString:dateStrFormat])nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    dateFormatter.dateFormat = dateStrFormat;

    return [dateFormatter dateFromString:dateStr];
}

+ (NSString *) ymdhmWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [dateFormatter stringFromDate:date];
}

+ (void)showTopAlertView:(NSString*)message
{
    [AlertView showMessage:message isError:NO];
}

+ (NSMutableArray *)convertConfigItemInfoArrayToCheckItemModelArray:(NSArray*)cfgArray
{
    ReturnIf(!cfgArray || cfgArray.count <= 0)nil;

    NSMutableArray *array = [[NSMutableArray alloc]init];

    for (ConfigItemInfo *model in cfgArray) {
        CheckItemModel *checkItem = [[CheckItemModel alloc]init];
        checkItem.key = model.code;
        checkItem.value = model.value;
        checkItem.extData = model.code;
        [array addObject:checkItem];
    }
    return array;
}

+ (NSMutableArray *)convertConfigItemsToKeyValueModels:(NSArray*)cfgArray
{
    ReturnIf(!cfgArray || cfgArray.count <= 0)nil;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (ConfigItemInfo *model in cfgArray) {
        [array addObject:[KeyValueModel modelWithValue:model.value forKey:model.code]];
    }
    return array;
}

+ (NSMutableArray *)convertKeyValueModelArrayToCheckItemModelArray:(NSArray*)cfgArray
{
    ReturnIf(!cfgArray || cfgArray.count <= 0)nil;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (KeyValueModel *model in cfgArray) {
        CheckItemModel *checkItem = [[CheckItemModel alloc]init];
        checkItem.key = model.key;
        checkItem.value = model.value;
        checkItem.extData = @(model.tag);
        [array addObject:checkItem];
    }
    return array;
}

+ (CheckItemModel*)findItem:(NSString*)key FromCheckItemModelArray:(NSArray*)array
{
    ReturnIf(array.count < 0 || [Util isEmptyString:key])nil;

    for (CheckItemModel *model in array) {
        ReturnIf([model.key isEqualToString:key]) model;
    }
    return nil;
}

+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (float)folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [[self class] fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0);
}

+ (NSString*)genrateUniqueStringCode
{
    return [NSString getUUIDString];
}

+ (MenuButtonModel*)makeMenuButtonModel:(kOrderOperationType)operateType
{
    MenuButtonModel *model = [MenuButtonModel new];
    model.title = getOrderOperationTypeStr(operateType);
    model.backgroundColor = getOrderOperationButtonColor(operateType);
    model.buttonTag = operateType;
    
    return model;
}

@end
