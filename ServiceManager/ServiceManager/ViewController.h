//
//  ViewController.h
//  BaseProject
//
//  Created by wangzhi on 15-1-12.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpClientManager.h"

@interface ViewController : UIViewController
@property(nonatomic, strong)HttpClientManager *httpClient;
@end

