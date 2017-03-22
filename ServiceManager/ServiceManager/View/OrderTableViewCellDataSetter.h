//
//  OrderTableViewCellDataSetter.h
//  ServiceManager
//
//  Created by will.wang on 16/5/12.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderTableViewCell.h"

@interface OrderTableViewCellDataSetter : NSObject
+(void)setOrderContentModel:(OrderContentModel*)order toCell:(OrderTableViewCell*)cell;

+(void)setLetvOrderContentModel:(LetvOrderContentModel*)order toCell:(OrderTableViewCell*)cell;

+ (NSAttributedString*)buildOrderAttrStr:(NSString*)processType catgory:(NSString*)category customer:(NSString*)customerName;
@end
