//
//  TwoKeyValueTableView.h
//  ServiceManager
//
//  Created by wangzhi on 15/7/20.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwoKeyValueTableView : UITableView
@property(nonatomic, strong)NSArray *cellDataArray; //ITEM: KeyValueModel

- (instancetype)initWithDefault;

@property(nonatomic, assign)CGFloat constHeight; //定高。为0时，自动适配高
@end
