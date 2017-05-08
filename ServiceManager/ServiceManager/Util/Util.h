//
//  Util.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-10.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonEntity.h"
#import "InterfaceInputParamsObjects.h"
#import "DataModelEntities.h"
#import "NetClientManager.h"
#import "QrCodeUtil.h"
#import "WZSwipeCell.h"

@interface Util : NSObject

//if str1 is equal to str2 or not
+ (BOOL)str:(NSString*)str1 isEqualTo:(NSString*)str2;

+ (NSString*)defaultStr:(NSString*)dftStr ifStrEmpty:(NSString*)srcStr;

+ (BOOL)isEmptyString:(NSString *)str;

//解析用户登录信息，并同步到本地存储
+ (BOOL)syncUserInfo:(id)resultData loginInfo:(LoginInputParams*)loginInfo;

//去APPSTORE给APP评分
+ (void)commentAppByAppId:(NSString *)appId;

//打电话
+ (void)makePhoneCallWithNumber:(NSString *)number;

+ (NSString*)isValidPasswordStr:(NSString*)pwdStr;

//弹出左边的|我的|视图
+ (void)showLeftMeVeiwController;

//用户从本地退出，不请求网络端
+ (void)logoutLocalUser;

//退到登录页
+ (void)startLoginViewController;

+ (UIButton*)makeVerticalBtn:(NSString*)iconName title:(NSString*)title size:(CGSize)size;

+ (NSString*)getErrorDescritpion:(HttpResponseData*)responseData otherError:(NSError*)error;

+ (void)showErrorToastIfError:(HttpResponseData*)responseData otherError:(NSError*)error;

//return show duration
+(NSTimeInterval)showToast:(NSString*)content toView:(UIView*)showOnView;
+(NSTimeInterval)showToast:(NSString*)content;

+ (void)showToast:(NSString *)content if:(BOOL)isTrue;

+ (void)showWaitingDialogToView:(UIView*)view;

+ (void)dismissWaitingDialogFromView:(UIView*)view;

//show to window
+ (void)showWaitingDialog;

//dismiss from window
+ (void)dismissWaitingDialog;

+ (void)showTopAlertView:(NSString*)message;

+ (void)showAlertView:(NSString*)title message:(NSString*)message;

+ (void)showAlertView:(NSString*)title message:(NSString*)message okAction:(VoidBlock)okAction;

// nothing to do when cancel button clicked
+ (UIAlertView*)confirmAlertView:(NSString*)title message:(NSString*)message confirmTitle:(NSString*)confirmTitle cancelTitle:(NSString*)cancelTitle confirmAction:(VoidBlock)confirmAction;

+ (UIAlertView*)confirmAlertView:(NSString*)title
                 message:(NSString*)message
            confirmTitle:(NSString*)confirmTitle
           confirmAction:(VoidBlock)confirmAction
             cancelTitle:(NSString*)cancelTitle
            cancelAction:(VoidBlock)cancelAction;

+ (void)confirmAlertView:(NSString*)message confirmAction:(VoidBlock)confirmAction;

//timeNumStr: "20150707163110"
//return: s
+ (NSTimeInterval)timeIntervalFromTimeNumStr:(NSString*)timeNumStr;

//timeNumStr: "20150707163110"
//return: WZDateStringFormat7
+ (NSString*)timeTextStringFromTimeNumStr:(NSString*)timeNumStr;

//dateStr : "20150707163110"
//format : @"yyyyMMddHHmmss"
//return : nsdate
+ (NSDate*)dateWithString:(NSString*)dateStr format:(NSString*)dateStrFormat;

// 2017-11-22 10:20
+ (NSString *) ymdhmWithDate:(NSDate *)date;

//input: ConfigItemInfo array
//return CheckItemModel array
+ (NSMutableArray *)convertConfigItemInfoArrayToCheckItemModelArray:(NSArray*)cfgArray;

//input: KeyValueModel array
//return CheckItemModel array
+ (NSMutableArray *)convertKeyValueModelArrayToCheckItemModelArray:(NSArray*)cfgArray;

//input: ConfigItemInfo array
//return KeyValueModel array
+ (NSMutableArray *)convertConfigItemsToKeyValueModels:(NSArray*)configItems;

//遍历文件夹获得文件夹大小，返回多少KB
+ (float)folderSizeAtPath:(NSString*)folderPath;
    
//单个文件的大小,返回多少B
+ (long long) fileSizeAtPath:(NSString*) filePath;

+ (CheckItemModel*)findItem:(NSString*)key FromCheckItemModelArray:(NSArray*)array;

//生成唯一码
+ (NSString*)genrateUniqueStringCode;

+ (MenuButtonModel*)makeMenuButtonModel:(kOrderOperationType)operateType;
@end
