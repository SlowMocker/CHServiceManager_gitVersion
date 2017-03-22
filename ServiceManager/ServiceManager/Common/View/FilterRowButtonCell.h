//
//  FilterRowButtonCell.h
//  ServiceManager
//
//  Created by will.wang on 16/9/8.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterRowButtonCell : UITableViewCell
- (instancetype)initWithMaxButtonCount:(NSInteger)maxButtonCount reuseIdentifier:(NSString *)reuseIdentifier;

//param1 : KeyValueModel
@property(nonatomic, strong)VoidBlock_id onCellItemButtonClicked;
//itemDatas: KeyValueModel
@property(nonatomic, strong)NSArray *itemDatas;
@end
