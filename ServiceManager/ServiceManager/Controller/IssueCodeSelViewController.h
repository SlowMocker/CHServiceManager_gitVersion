//
//  IssueCodeSelViewController.h
//  ServiceManager
//
//  Created by will.wang on 9/29/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "ViewController.h"

@class IssueCodeSelViewController;

@protocol IssueCodeSelViewControllerDelegate <NSObject>
@optional
- (void)issueCodeSelViewControllerFillFinished:(IssueCodeSelViewController*)viewController;
@end

@interface IssueCodeSelViewController : ViewController
@property(nonatomic, strong)OrderContentDetails *orderDetails;
@property(nonatomic, strong)CheckItemModel *issueTypeItem;
@property(nonatomic, strong)CheckItemModel *issueSubTypeItem;

@property(nonatomic, assign)id<IssueCodeSelViewControllerDelegate>delegate;
@end
