//
//  ComponentSelViewController.h
//  ServiceManager
//
//  Created by will.wang on 15/9/22.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"

@class ComponentSelViewController;

@protocol ComponentSelViewControllerDelegate <NSObject>
@optional
- (void)componentSelViewControllerFillFinished:(ComponentSelViewController*)viewController;
@end

@interface ComponentSelViewController : ViewController
@property(nonatomic, strong)CheckItemModel *typeItem;
@property(nonatomic, strong)CheckItemModel *subTypeItem;

@property(nonatomic, assign)id<ComponentSelViewControllerDelegate>delegate;
@end
