//
//  HomePadItemTableViewCell.h
//  ServiceManager
//
//  Created by will.wang on 16/5/4.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  首页功能项CELL
 */

@interface HomePadItemTableViewCell : UITableViewCell
@property(nonatomic,assign)NSInteger maxmumItemsCount; //default is 4
@property(nonatomic, weak)UIViewController *viewController;

- (void)setItemDatas:(NSArray*)itemDatas itemSize:(CGSize)itemSize;

@end
