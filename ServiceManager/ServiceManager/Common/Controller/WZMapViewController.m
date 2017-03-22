//
//  WZMapViewController.m
//  HouseMarket
//
//  Created by wangzhi on 15-3-6.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZMapViewController.h"

@interface WZMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (nonatomic, strong) BMKLocationService *locService;
@end

@implementation WZMapViewController

- (BOOL)isHouseHasLocation
{
    return (_pointAnnotation.coordinate.latitude != 0 || _pointAnnotation.coordinate.longitude != 0);
}

- (void)removeExistedAnnotation
{
    NSArray *array = [self.mapView annotations];
    if (nil != array && [array count] >0)
    {
        [self.mapView removeAnnotations:array];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.isLocate)
    {
        //如果经纬度都为0,则开启自动定位
        
        //设置定位精确度
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyHundredMeters];

        //设置最小更新距离
        [BMKLocationService setLocationDistanceFilter:kCLDistanceFilterNone];
        
         //启动LocationService
        [self.locService startUserLocationService];
    }

    [self setView: self.mapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_mapView viewWillAppear];
    [_mapView setDelegate:self]; // 此处记得不用的时候需要置nil，否则影响内存的释放
    if ([self isHouseHasLocation])
    {
        [self removeExistedAnnotation];
        [_mapView addAnnotation:_pointAnnotation];
        self.mapView.centerCoordinate = _pointAnnotation.coordinate;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

#pragma mark - -BMKLocationServiceDelegate Delegate

- (void)didStopLocatingUser
{
    DLog(@"定位结束");
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    DLog(@"定位成功");
    [self setRegion:userLocation.location.coordinate];
    [_locService stopUserLocationService];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    DLog(@"定位失败");
}

- (BMKMapView*)mapView
{
    if (nil == _mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (BMKLocationService *)locService
{
    if (nil == _locService) {
        _locService = [[BMKLocationService alloc]init];
         _locService.delegate = self;
    }
    return _locService;
}

- (void)setRegion:(CLLocationCoordinate2D)coordinate
{
    if (coordinate.longitude > 0 && 0 < coordinate.latitude)
    {
        _pointAnnotation = [[BMKPointAnnotation alloc]init];
        _pointAnnotation.coordinate = coordinate;
        
        //当从MeViewController进入的时候，是自动定位，title设置为"我在这儿"
        _pointAnnotation.title = @"我在这儿";
        
        [self removeExistedAnnotation];
        [self.mapView addAnnotation:_pointAnnotation];
        
        self.mapView.centerCoordinate = coordinate;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.locService = nil;
}
@end
