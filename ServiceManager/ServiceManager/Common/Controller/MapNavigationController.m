//
//  MapNavigationController.m
//  ServiceManager
//
//  Created by wangzhi on 15/7/2.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "MapNavigationController.h"

@implementation MapNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self navigateByAppleMap];
}

-(void)navigateByAppleMap
{
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.targetLocation addressDictionary:nil]];

    toLocation.name = self.targetAddress;
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
}

@end
