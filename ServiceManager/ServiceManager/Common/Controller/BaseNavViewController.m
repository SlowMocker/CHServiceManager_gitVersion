//
//  BaseNavViewController.m
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-5-21.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController() <UIGestureRecognizerDelegate>
@end

@implementation BaseNavViewController

-(id)initWithSubViewController:(UIViewController *)subviewcontroller {
    if (self = [super init]) {
        self->navController = [[UINavigationController alloc] initWithRootViewController:subviewcontroller];
        self->navController.interactivePopGestureRecognizer.enabled = YES;
        self->navController.interactivePopGestureRecognizer.delegate = self;
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL isInTop = (self->navController.viewControllers.count == 1);

    return !isInTop;
}

-(void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (self->navController != nil) {
        [self.view addSubview:self->navController.view];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.hidesBottomBarWhenPushed = NO;
    [self->navController viewWillAppear:animated];
    NSLog(@"%@ viewWillAppear", self.title);
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self->navController viewDidAppear:animated];
    NSLog(@"%@ viewDidAppear", self.title);
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.hidesBottomBarWhenPushed = YES;
    [self->navController viewWillDisappear:animated];
    NSLog(@"%@ viewWillDisappear", self.title);
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self->navController viewDidDisappear:animated];
    NSLog(@"%@ viewDidDisappear", self.title);
}

@end
