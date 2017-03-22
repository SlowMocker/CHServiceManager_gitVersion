//
//  RefuseOrderViewController.h
//  ServiceManager
//
//  Created by will.wang on 17/03/2017.
//  Copyright © 2017 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "WZTableView.h"
#import "WZTextView.h"

/**
 * 拒绝工单, 包括拒绝原因选择和备注描述
 */

@interface RefuseOrderViewController : ViewController
@property(nonatomic, strong)OrderContent *order;
@property(nonatomic, strong)VoidBlock_id confirmBlock;

//read only
@property(nonatomic, strong)CheckItemModel *checkedReasonItem;
@property(nonatomic, strong)WZTextView *textView;

@end
