//
//  LocationManager.h
//  ServiceManager
//
//  Created by will.wang on 15/9/16.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LocationCallBack)(BMKReverseGeoCodeResult *location);

@interface LocationManager : NSObject

+ (instancetype)sharedInstance;

- (void)startLocationWithResponse:(LocationCallBack)responseCallBack;

@end
