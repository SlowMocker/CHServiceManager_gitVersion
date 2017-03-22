//
//  WZSingleCheckListPopView.h
//  ServiceManager
//
//  Created by will.wang on 15/9/16.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZSingleCheckListView.h"

typedef void(^CheckListSingleCheckedCallBack)(NSInteger checkIndex);

@interface WZSingleCheckListPopView : UIView

- (instancetype)initWithCheckItems:(NSArray *)checkItems
                             title:(NSString*)title
                        checkIndex:(NSInteger)checkIndex
                     checkedAction:(CheckListSingleCheckedCallBack)action;
- (void)show;

@end
