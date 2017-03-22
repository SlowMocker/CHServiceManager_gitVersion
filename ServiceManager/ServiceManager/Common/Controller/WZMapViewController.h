//
//  WZMapViewController.h
//  HouseMarket
//
//  Created by wangzhi on 15-3-6.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "BMapKit.h"

@interface WZMapViewController : ViewController
@property(nonatomic, strong)BMKMapView *mapView;
@property(nonatomic, strong)BMKPointAnnotation *pointAnnotation;

//位置
@property(nonatomic, assign)CLLocationCoordinate2D region;

//是否定位
@property(nonatomic, assign)BOOL isLocate;

@end
