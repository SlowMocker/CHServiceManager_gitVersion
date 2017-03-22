//
//  UIViewController+ChEx.m
//  CH_IPP_SH_SDK
//
//  Created by Wu on 17/3/15.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "UIViewController+ChEx.h"

#import <objc/runtime.h>

@implementation UIViewController (ChEx)

+ (void)load {
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        Class class = [self class];
        
        SEL originalSel = @selector(viewDidAppear:);
        SEL newSel = @selector(ch_viewDidAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSel);
        Method newMethod = class_getInstanceMethod(class, newSel);
        method_exchangeImplementations(originalMethod, newMethod);
        
    });
}

- (void) ch_viewDidAppear:(BOOL)animated {
    [self ch_viewDidAppear:animated];
    NSLog(@"\n\n\n==================================================>当前显示 Vc : %@\n\n\n",[self class]);
}


@end
