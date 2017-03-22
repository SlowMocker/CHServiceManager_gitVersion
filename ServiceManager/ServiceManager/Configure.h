//
//  Configure.h
//  BaseProject
//
//  Created by wangzhi on 15-1-12.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#ifndef BaseProject_Configure_h
#define BaseProject_Configure_h

#pragma mark - 编译目标

//0 for debug, 1 for release
#define Build_For_Release  0

#pragma mark - 功能子模块

//乐视技术支持功能模块
#define Module_TecSupport

//乐视智能销售功能模块
#define Module_SmartSells

#pragma mark - Getui Push Ids

//开启PUSH推送功能
#define ENABLE_FEATURE_PUSH

#if Build_For_Release
//Release
#define kGetuiPushAppId @"8zjRn9TYDm9WCzQAMQbVe8"
#define kGetuiPushAppKey @"xzBQ71fmxq7Nyya9cElbZ8"
#define kGetuiPushAppSecret @"xvaLuO1tQP7PXYXN0P0k19"
#else
//Debug
#define kGetuiPushAppId @"rGLk2Jr2JM74YwLZ3kNXY1"
#define kGetuiPushAppKey @"460PQcb9oV5HKykHIoFv49"
#define kGetuiPushAppSecret @"8Uq9nFdQS18wsQCHU8nOsA"
#endif

#pragma mark - 配置服务器地址

//[local]
//#define kLetvServerBaseUrl @"http://10.9.44.225:8080"   //yi chu
//#define kServerBaseUrl @"http://10.9.50.59:8080/"

//[test address for debug]
//#define kLetvServerBaseUrl @"http://172.17.123.134:81"
//#define kServerBaseUrl @"http://111.9.116.148:81/"

//[production address for release]
//#define kServerBaseUrl      @"http://shgj.kydls.com/"
//#define kLetvServerBaseUrl  @"http://lsshgj.kydls.com"
#if (Build_For_Release)
#define kServerBaseUrl      @"http://shgj.kydls.com/"
#define kLetvServerBaseUrl  @"http://lsshgj.kydls.com"
#else
//[test]
#define kLetvServerBaseUrl @"http://test.lsshgj.kydls.com:81"
#define kServerBaseUrl @"http://test.shgj.kydls.com:81"

#endif

//Qiniu云
#if (Build_For_Release)
#define kQiniuYunImageAccessDomain @"http://images.kydls.cn"
#else
#define kQiniuYunImageAccessDomain @"http://olcxvnpk6.bkt.clouddn.com"
#endif

//长虹发布平台APPKEY
#define kAppKeyInChangHongPublishPlatform @"7bd75cd7f2354cf9b00f56c77bfaa916"

//APP ID号
#define kAppIdInAppStore @" "

//网络内存缓存
#define kNetWorkDataMemoryCache (5 *1024 * 1024)

//网络DISK缓存
#define kNetWorkDataDiskCache   (5 * 1024 * 1024)

//网络超时
#define kNetWorkRequestTimeOut  (60)
#define kNetWorkRequestMainConfigInfoTimeout (60 * 20)

#define kSupportResourceURL @"http://jsfw.kydls.com/mt-index.html"

#pragma mark - ShareSdk分享
//分享ShareSdk
//#define ENABLE_SHARE_SDK

#ifdef ENABLE_SHARE_SDK
#define kShareSdkAppKey @"88c398897420"
#endif

#define kToastShortDurationTime (1.5)

//FONT
#define kFontSizeCellTitle     [UIFont systemFontOfSize:15]
#define kFontSizeTextButton    [UIFont systemFontOfSize:15]
#define kFontSizeAgentTitle    [UIFont systemFontOfSize:20]
#define kFontSizeAgentSubTitle [UIFont systemFontOfSize:14]

//Color
#define kColorLightOrange   [UIColor colorWithHexString:@"#ff892b"]
#define kColorDefaultOrange [UIColor colorWithHexString:@"#fb994c"]
#define kColorDefaultYellow [UIColor colorWithHexString:@"#fec200"]
#define kColorLightGreen    [UIColor colorWithHexString:@"#27ae61"]
#define kColorDefaultGreen  [UIColor colorWithHexString:@"#099e49"]
#define kColorDefaultBlue   [UIColor colorWithHexString:@"#063296"]
#define kColorDefaultRed    [UIColor colorWithHexString:@"#fe6052"]
#define kColorLightGray     [UIColor colorWithHexString:@"#bdc3c7"]
#define kColorDefaultGray   [UIColor colorWithHexString:@"#222222"]
#define kColorDarkGray   [UIColor darkGrayColor]
#define kColorDefaultLightBlack [UIColor colorWithHexString:@"#2a2e35"]
#define kColorWhite [UIColor whiteColor]
#define kColorBlack [UIColor blackColor]
#define kColorClear [UIColor clearColor]
#define kColorBlue  [UIColor blueColor]
#define kColorMyOrderListCellBGColor [UIColor colorWithHexString:@"#DDE4EA"]

#define kTableViewSectionHeaderHeight   (36)
#define kTableViewLeftPadding   (16)
#define kTableViewCellDefaultHeight (44.0f)
#define kTableViewCellLargeHeight (54.0f)

//VC 默认背景色
#define kColorDefaultBackGround [UIColor colorWithHexString:@"#f4f4f4"]

//普通button默认高度
#define kButtonDefaultHeight    (40)

//大button高度
#define kButtonLargeHeight  (49)

#define kDefaultSpaceUnit (10)

//左边栏弹出VC的宽度
#define kLeftPopVcWidth (([UIScreen mainScreen].bounds.size.width)-53)

//百度地图KEY(企业版)
#define kBaiduAppkey @"iEXOpG6UppHnSBBZ8YfpVRst"

//des default key
#define kDefaultDesKey @"BOTWAVEE"

//400 tel
#define kServiceManager400Tel @"4008111666"

//repaiert initial password
#define kRepairerInitialPassword @"123456"

//配置列表默认分页大小
#define kDefaultListPageSize   (15)

#endif
