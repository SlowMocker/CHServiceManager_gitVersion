//
//  FeeEditViewController.h
//  ServiceManager
//
//  Created by will.wang on 16/4/8.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "TableViewController.h"

@interface FeeEditViewController : TableViewController
@property(nonatomic, strong)SellFeeListInfos *feeInfos;

@property(nonatomic, copy)NSString *orderKeyId;
@property(nonatomic, copy)NSString *orderObjectId;
@property(nonatomic, copy)NSString *brandCode;
@property(nonatomic, copy)NSString *categoryCode;

- (void)editFeeOrder:(EditFeeOrderInputParams*)param;

//在子类中重写
- (void)dismissKeyBoard;
@end
