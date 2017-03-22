//
//  OrderFilterPopView.h
//  ServiceManager
//
//  Created by will.wang on 16/9/8.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderFilterPopView;

@protocol OrderFilterPopViewDelegate <NSObject>
@optional
- (void)filterPopView:(OrderFilterPopView*)filterView changed:(id)filterOutItems;
@end

@interface OrderFilterPopView : UIView
@property(nonatomic, weak)ViewController *viewController;
@property(nonatomic, weak)id<OrderFilterPopViewDelegate>delegate;
@property(nonatomic, strong)OrderFilterConditionItems *filterCondition;
@property(nonatomic, strong)VoidBlock_id filterValueChangedBlock;

- (void)resetAllFilterConditions;
- (void)show;
- (void)hide;
@end
