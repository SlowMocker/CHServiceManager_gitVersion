//
//  ExtendServiceProductCell.h
//  ServiceManager
//
//  Created by will.wang on 10/13/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtendServiceProductCell : UITableViewCell
@property(nonatomic, strong)ExtendProductContent *product;
@property(nonatomic, strong)UILabel *contentLabel;
@property(nonatomic, strong)UILabel *machineCodeLabel;
@end
