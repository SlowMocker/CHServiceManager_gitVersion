//
//  OrderTraceCell.h
//  ServiceManager
//
//  Created by will.wang on 15/9/11.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZSwipeCell.h"

@interface OrderTraceCell : WZSwipeCell

@property(nonatomic, strong)UILabel *orderIdLabel;
@property(nonatomic, strong)UIButton *statusButton;
@property(nonatomic, strong)UILabel *partNameLabel;
@property(nonatomic, strong)UILabel *partNoLabel;   //编号
@property(nonatomic, strong)UILabel *partCodeLabel; //条码

@property(nonatomic, strong)OrderTraceInfos *traceInfo;

@property(nonatomic, strong)VoidBlock_id statusButtonClickedBlock;

@end
