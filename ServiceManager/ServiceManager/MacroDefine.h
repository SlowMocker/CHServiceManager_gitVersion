//
//  MacroDefine.h
//  BaseProject
//
//  Created by wangzhi on 15-1-12.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#ifndef BaseProject_MacroDefine_h
#define BaseProject_MacroDefine_h

#import <Foundation/Foundation.h>

//获取屏幕 宽度、高度
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

//IOS系统版本(doubel)
#define SystemVersion ([[UIDevice currentDevice].systemVersion doubleValue])

//DEBUG模式下打印日志
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define UNIMPLEMENTED NSLog(@"%s unimplemented", __FUNCTION__);

//DEBUG模式下,弹框式日志
#ifdef DEBUG
#define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#define ULog(...)
#endif

//定义UIImage对象
#define ImageNamed(imageName) [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]

//读取本地图片
#define LoadImage(file) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:nil]]

// 获取RGB颜色
#define ColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define ColorWithRGB(r,g,b) RGBA(r,g,b,1.0f)
#define ColorWithHex(hexStr) [UIColor colorWithHexString:hexStr]
#define ClearBackgroundColor(view) (view.backgroundColor = [UIColor clearColor])

//主线程
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//后台线程
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

//Break,Return
#define BreakIf(x)  if(x)break
#define ContinueIf(x)   if(x)continue
#define ReturnIf(x) if(x)return

//Font
#define SystemFont(size) [UIFont systemFontOfSize:size]
#define SystemBoldFont(size) [UIFont boldSystemFontOfSize:size]


//weakSelf
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


//Block
typedef void(^VoidBlock)();
typedef BOOL(^BoolBlock)();
typedef int (^IntBlock) ();
typedef id  (^IDBlock)  ();

typedef void(^VoidBlock_int)(int);
typedef BOOL(^BoolBlock_int)(int);
typedef int (^IntBlock_int) (int);
typedef id  (^IDBlock_int)  (int);

typedef void(^VoidBlock_string)(NSString*);
typedef BOOL(^BoolBlock_string)(NSString*);
typedef int (^IntBlock_string) (NSString*);
typedef id  (^IDBlock_string)  (NSString*);

typedef void(^VoidBlock_id)(id);
typedef BOOL(^BoolBlock_id)(id);
typedef int (^IntBlock_id) (id);
typedef id  (^IDBlock_id)  (id);

#define kDoubleComparePrecision 1e-6

#define kDoubleCompare(x)  fabs(x) < kDoubleComparePrecision ? YES : NO

#define kItemLabelleftGap (15)

#define kAppDelegate ((AppDelegate*)[[UIApplication sharedApplication]delegate])


//单例化一个类, 使用时用sharedInstance获取
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)sharedInstance \
{ \
    @synchronized(self) \
    { \
        if (shared##classname == nil) \
        { \
            shared##classname = [[self alloc] init]; \
        } \
    } \
    \
    return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
    @synchronized(self) \
    { \
        if (shared##classname == nil) \
        { \
            shared##classname = [super allocWithZone:zone]; \
            return shared##classname; \
        } \
    } \
    \
    return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return self; \
}

#endif
