//
//  CallingHelper.h
//  ServiceManager
//
//  Created by will.wang on 15/9/23.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface CallingHelper : NSObject

+ (void)startCalling:(NSString*)telOrMobileNo fromViewController:(ViewController*)currentViewController;

+ (void)startCallings:(NSArray*)telArray fromViewController:(ViewController*)currentViewController;
@end
