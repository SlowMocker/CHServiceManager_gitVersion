//
//  KeyValueTableView.h
//  ServiceManager
//
//  Created by wangzhi on 15-5-27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

//单行默认高
#define kDefaultKeyValueTableViewItemHeight (40)

@interface KeyValueTableView : UITableView
@property(nonatomic, strong)NSArray *cellDataArray; //ITEM: KeyValueModel

- (instancetype)initWithDefault;

@property(nonatomic, assign)CGFloat constHeight; //定高。为0时，自动适配高
@end
