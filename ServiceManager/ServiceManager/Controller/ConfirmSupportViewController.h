//
//  ConfirmSupportViewController.h
//  ServiceManager
//
//  Created by will.wang on 9/24/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

/**
 * 维修工确认支持
 */

#import "ViewController.h"
#import "WZTextView.h"
#import "WZTableView.h"

#define kConfirmSupportDetailsItemTelTag     0x47832
#define kConfirmSupportDetailsItemStarTag    0x47833
#define kConfirmSupportDetailsItemDescriptionTag    0x47834

@interface ConfirmSupportViewController : ViewController
@property(nonatomic, copy)NSString *orderId;
@property(nonatomic, strong)SupporterOrderContent *orderContent;
@property(nonatomic, assign)NSInteger orderStatus;

@property(nonatomic, strong)WZTableView *tableView;

@property(nonatomic, strong)UIView *customFooterView;
@property(nonatomic, strong)UIButton *confirmButton;
@property(nonatomic, strong)NSMutableArray *detailItemArray;
@property(nonatomic, assign)BOOL bEditMode;

//requestCallBackBlock, param 3, extData 为SupporterOrderContent类型
- (void)getSupportOrderConent:(RequestCallBackBlockV2)requestCallBackBlock;

- (void)commitTaskConfirm:(ConfirmSupportInputParams*)params;

@end
