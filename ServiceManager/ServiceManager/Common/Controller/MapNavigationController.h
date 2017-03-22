//
//  MapNavigationController.h
//  ServiceManager
//
//  Created by wangzhi on 15/7/2.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface MapNavigationController : ViewController

@property(nonatomic, copy)NSString *targetAddress;
@property(nonatomic, assign)CLLocationCoordinate2D targetLocation;
@end
