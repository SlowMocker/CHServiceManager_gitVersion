//
//  TextSegmentTableViewCell.h
//  ServiceManager
//
//  Created by will.wang on 16/5/5.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  左边文本，右边分段选择器
 *  左边文本就是 textLabel
 */

@interface TextSegmentTableViewCell : UITableViewCell
@property(nonatomic, strong)UISegmentedControl *segment;

//type: KeyValueModel array
@property(nonatomic, strong)NSArray *segmentItems;

@property(nonatomic, assign)NSString *selectedItemKey;

//请使用此方法初始化
- (instancetype)initWithSize:(CGSize)segmentSize reuseIdentifier:(NSString *)reuseIdentifier;
@end
