//
//  AppointmentPopMenuView.m
//  ServiceManager
//
//  Created by will.wang on 15/9/10.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "AppointmentPopMenuView.h"
#import "AppointmentViewController.h"
#import "AppointmentFailureViewController.h"

#define kAppointmentPopMenuDefaultWidth (ScreenWidth - 80)
#define kAppointmentPopMenuDefaultHeight (kTableViewCellLargeHeight*4)

@interface AppointmentPopMenuView()
@property(nonatomic, strong)UIView *contentView;

@property(nonatomic, strong)UIView *orderTitleView;
@property(nonatomic, strong)UILabel *orderTitleLabel;

@property(nonatomic, strong)UITableViewCell *callButton;
@property(nonatomic, strong)UITableViewCell *successBtn;
@property(nonatomic, strong)UITableViewCell *failureBtn;

@end

@implementation AppointmentPopMenuView

- (NSString*)getAppointmentOperateTypeKeyWord
{
    NSString *tempStr;
    switch (self.appointmentOperateType) {
        case kAppointmentOperateTypeChangeTime:
            tempStr = @"改";
            break;
        case kAppointmentOperateType1stTime:
        case kAppointmentOperateType2ndTime:
        default:
            tempStr = @"预";
            break;
    }
    return tempStr;
}

- (void)setDataToViews
{
    NSString *tempStr;

    tempStr = [NSString stringWithFormat:@"工单%@约 : %@",[self getAppointmentOperateTypeKeyWord], self.orderId];
    self.orderTitleLabel.text = tempStr;

    self.callButton.textLabel.text = [Util defaultStr:kNoName ifStrEmpty:self.customerName];
    self.callButton.detailTextLabel.text = [Util defaultStr:@"联系电话未知" ifStrEmpty:self.customerTels];
}

- (UITableViewCell*)makeTableviewCell:(NSString*)icon text:(NSString*)text action:(SEL)touchAction
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell.imageView.image = ImageNamed(icon);

    cell.textLabel.numberOfLines = 2;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = kColorDarkGray;
    cell.textLabel.font = SystemFont(14);
    cell.textLabel.text = text;

    [cell addLineTo:kFrameLocationBottom];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell addSingleTapEventWithTarget:self action:touchAction];
    return cell;
}

- (void)makeCustomSubViews
{
    NSString *tempStr;

    _orderTitleView = [[UILabel alloc]init];
    UIView *bottomLine = [_orderTitleView addLineTo:kFrameLocationBottom];
    [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@3);
    }];
    bottomLine.backgroundColor = kColorDefaultBlue;
    [self.contentView addSubview:_orderTitleView];
    
    _orderTitleLabel = [UILabel new];
    _orderTitleLabel.font = SystemFont(16);
    _orderTitleLabel.textColor = bottomLine.backgroundColor;
    _orderTitleLabel.adjustsFontSizeToFitWidth = YES;
    [_orderTitleView addSubview:_orderTitleLabel];
    
    _callButton = [self makeTableviewCell:@"phone-call-green" text:nil action:@selector(callButtonClicked:)];
    [self.contentView addSubview:_callButton];

    tempStr = [NSString stringWithFormat:@"%@约成功",[self getAppointmentOperateTypeKeyWord]];
    _successBtn = [self makeTableviewCell:@"deal-success-green" text:tempStr action:@selector(successButtonClicked:)];
    [self.contentView addSubview:_successBtn];

    tempStr = [NSString stringWithFormat:@"%@约失败",[self getAppointmentOperateTypeKeyWord]];
    _failureBtn = [self makeTableviewCell:@"deal-fail-red" text:tempStr action:@selector(failureButtonClicked:)];
    [self.contentView addSubview:_failureBtn];
}

- (void)layoutCustomSubViews
{
    [self.orderTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.orderTitleView).with.insets(UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding));
    }];
    
    NSArray *verticalViews = @[self.orderTitleView, self.callButton, self.successBtn, self.failureBtn];
    UIView *topView = nil;

    for (UIView *view in verticalViews) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (nil == topView) {
                make.top.equalTo(self.contentView);
            }else {
                make.top.equalTo(topView.mas_bottom);
            }
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@(kTableViewCellLargeHeight));
        }];
        topView = view;
    }
}

- (UIView *)contentView
{
    if (nil == _contentView) {
        CGRect frame = CGRectMake(0, 0, kAppointmentPopMenuDefaultWidth, kAppointmentPopMenuDefaultHeight);
        _contentView = [[UIView alloc]initWithFrame:frame];
        [_contentView circleCornerWithRadius:4];
        _contentView.layer.borderWidth = 1.0;
        _contentView.layer.borderColor = kColorLightGray.CGColor;
        _contentView.backgroundColor = kColorWhite;
    }
    return _contentView;
}

- (void)popupAppointmentPopMenuView
{
    WZModal *modal = [WZModal sharedInstance];

    [self makeCustomSubViews];
    [self setDataToViews];

    [self layoutCustomSubViews];

    modal.showCloseButton = NO;
    modal.tapOutsideToDismiss = YES;
    modal.onTapOutsideBlock = nil;
    modal.contentViewLocation = WZModalContentViewLocationMiddle;
    [modal showWithContentView:self.contentView andAnimated:YES];
}

- (void)callButtonClicked:(UIGestureRecognizer*)gesture
{
    NSArray *telArray = [self.customerTels componentsSeparatedByString:@","];
    [CallingHelper startCallings:telArray fromViewController:self.viewController];
}

- (void)successButtonClicked:(UIGestureRecognizer*)gesture
{
    [[WZModal sharedInstance]hideAnimated:YES];
    
    if ([self.delegate respondsToSelector:@selector(popMenuViewAppointSuccess:)]) {
        [self.delegate popMenuViewAppointSuccess:self];
    }
}

- (void)failureButtonClicked:(UIGestureRecognizer*)gesture
{
    [[WZModal sharedInstance]hideAnimated:YES];
    
    if ([self.delegate respondsToSelector:@selector(popMenuViewAppointFailure:)]) {
        [self.delegate popMenuViewAppointFailure:self];
    }
}

@end
