//
//  UserWidgetView.m
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-4-27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "UserWidgetView.h"
#import "UserInfoEntity.h"
#import <UIButton+AFNetworking.h>

@interface UserWidgetView()
//@property (nonatomic, strong) UIButton *nameBtn;
@property (nonatomic, strong) UIButton *headImageBtn;
@end

@implementation UserWidgetView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _nameBtn = [UIButton transparentTextButton:nil];
//        [_nameBtn setFrame:CGRectMake(0, 0, 100, 32)];
//        _nameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [_nameBtn addTarget:self action:@selector(clickUserNameButton:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *nameBtnItem = [[UIBarButtonItem alloc]initWithCustomView:_nameBtn];

        _headImageBtn = [[UIButton alloc]init];
        [_headImageBtn setFrame:CGRectMake(0, 0, 32, 32)];
        [_headImageBtn circleView];
        [_headImageBtn setBackgroundColor:kColorDefaultOrange];
        [_headImageBtn addTarget:self action:@selector(clickUserIconButton:) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *headImgItem = [[UIBarButtonItem alloc]initWithCustomView:_headImageBtn];

//        _barItemArray = [NSArray arrayWithObjects:headImgItem, nameBtnItem,nil];

        _barItemArray = [NSArray arrayWithObjects:headImgItem,nil];
        [self updateUserNameAndIcon];

        [self registerNotifications];
    }
    return self;
}

//点击了用户名称
- (void)clickUserNameButton:(UIButton*)nameBtn
{
    [Util showLeftMeVeiwController];
}

//点击了用户头像
- (void)clickUserIconButton:(UIButton*)nameBtn
{
    [Util showLeftMeVeiwController];
}

- (void)dealloc
{
    [self unregisterNotifications];
}

- (void)registerNotifications
{
    [self doObserveNotification:NotificationNameLogined selector:@selector(userLogined)];
    [self doObserveNotification:NotificationNameLogout selector:@selector(userLogout)];
    [self doObserveNotification:NotificationUserInfoChanged selector:@selector(userInfoChanged)];
}

- (void)unregisterNotifications
{
    [self undoObserveNotification:NotificationNameLogined];
    [self undoObserveNotification:NotificationNameLogout];
    [self undoObserveNotification:NotificationUserInfoChanged];
}

- (void)userLogined
{
    [self updateUserNameAndIcon];
}

- (void)userLogout
{
    [self updateUserNameAndIcon];
}

- (void)userInfoChanged
{
    [self updateUserNameAndIcon];
}

- (void)updateUserNameAndIcon
{
    UserInfoEntity *selfUser = [UserInfoEntity sharedInstance];

    if ([selfUser isLogined]) {
//        [self.nameBtn setTitleForAllStatus:selfUser.nickName];

        [self.headImageBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:selfUser.avatar] placeholderImage:ImageNamed(@"01_nav_user")];
    }else {
//        [self.nameBtn setTitleForAllStatus:nil];
        [self.headImageBtn setBgImageForAllStatus:@"01_nav_user"];
    }
}

@end
