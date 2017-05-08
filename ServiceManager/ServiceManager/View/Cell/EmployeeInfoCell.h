//
//  EmployeeInfoCell.h
//  ServiceManager
//
//  Created by will.wang on 15/9/2.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeInfoCell : UITableViewCell
@property(nonatomic, strong)UIView *leftTagView; //left vertical line view
@property(nonatomic, strong)UIImageView *leftNumIcon;
@property(nonatomic, strong)UILabel *leftNumLabel;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *mobileLabel;
@property(nonatomic, strong)UILabel *taskCountLabel;
@property(nonatomic, strong)UILabel *infoLabel;

//用于派工
- (void)layoutCustomSubViews;

//用于申请技术支持
- (void)layoutCustomSubViews2;

@end
