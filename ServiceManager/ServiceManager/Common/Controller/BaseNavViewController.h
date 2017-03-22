//
//  BaseNavViewController.h
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-5-21.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavViewController : UIViewController
{
@public
    UINavigationController *navController;
}

-(id)initWithSubViewController:(UIViewController *)subviewcontroller;

@end
