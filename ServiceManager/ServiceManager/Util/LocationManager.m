//
//  LocationManager.m
//  ServiceManager
//
//  Created by will.wang on 15/9/16.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "LocationManager.h"
#import "BMapKit.h"

@interface LocationManager()<BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
@property(nonatomic, strong)BMKLocationService *locateService;
@property(nonatomic, strong)BMKGeoCodeSearch *searchService;

@property(nonatomic, strong)LocationCallBack locateResponseCallBack;
@end

@implementation LocationManager

+ (instancetype)sharedInstance
{
    static LocationManager *sLocationManager = nil;
    static dispatch_once_t sOnceToken;
    dispatch_once(&sOnceToken, ^{
        sLocationManager = [[LocationManager alloc]init];
    });

    return sLocationManager;
}

- (void)startLocationWithResponse:(LocationCallBack)responseCallBack
{
    self.locateResponseCallBack = responseCallBack;

    [self.locateService startUserLocationService];
}

- (BMKLocationService*)locateService
{
    if (nil == _locateService) {
        _locateService = [[BMKLocationService alloc]init];
        _locateService.delegate = self;
    }
    return _locateService;
}

- (BMKGeoCodeSearch*)searchService
{
    if (nil == _searchService) {
        _searchService = [[BMKGeoCodeSearch alloc]init];
        _searchService.delegate = self;
    }
    return _searchService;
}

#pragma mark - BMKLocationServiceDelegate

- (void)didStopLocatingUser
{
    DLog(@"定位结束");
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    DLog(@"定位成功,即将反解析地址...");
    [self.locateService stopUserLocationService];

    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = userLocation.location.coordinate;
    [self.searchService reverseGeoCode:option];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    DLog(@"定位失败");
    [self.locateService stopUserLocationService];

    MAIN(^{
        self.locateResponseCallBack(nil);
    });
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    DLog(@"定位到 %@", result.address);
    MAIN(^{
        self.locateResponseCallBack(result);
    });
}

@end
