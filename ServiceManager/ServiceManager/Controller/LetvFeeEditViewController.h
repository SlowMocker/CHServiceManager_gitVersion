//
//  LetvFeeEditViewController.h
//  ServiceManager
//
//  Created by will.wang on 16/5/24.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "WZTableViewController.h"

@interface LetvFeeEditViewController : WZTableViewController
@property(nonatomic, strong)LetvSellFeeListInfos *letvFeeInfos;

@property(nonatomic, copy)NSString *machineModelCode;

@property(nonatomic, copy)NSString *orderKeyId;
@property(nonatomic, copy)NSString *orderObjectId;
@property(nonatomic, copy)NSString *brandCode;
@property(nonatomic, copy)NSString *categoryCode;
@end
