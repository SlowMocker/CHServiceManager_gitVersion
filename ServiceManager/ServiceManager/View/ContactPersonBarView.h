//
//  ContactPersonBarView.h
//  HouseMarket
//
//  Created by wangzhi on 15-3-12.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactPersonBarView : UIView
@property(nonatomic, strong)UIImageView *avatar;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UIButton *callBtn;
@property(nonatomic, strong)UIButton *chatBtn;

@property(nonatomic, strong)UIButton *avatarButton;

- (void)layoutViews;
@end
