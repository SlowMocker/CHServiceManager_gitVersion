//
//  BasePerformViewController.h
//  ServiceManager
//
//  Created by will.wang on 16/5/6.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "WZTableView.h"
#import "ButtonTableViewCell.h"
#import "TextSegmentTableViewCell.h"
#import "TextViewCell.h"
#import "NormalSelectTableViewCell.h"


static CGFloat kNoteEditTextCellHeight = 130;
static CGFloat kPerformOrderViewCellLineHeight = 44;

/**
 *  完工执行基类
 *  1，子类化此类后，可以重写公开的所有方法，以便做特殊处理
 */
@interface BasePerformViewController : ViewController
{
@public
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
    NSString *_signinAddress;
    NSArray *_streets;
    CheckItemModel *_clientStreet;
    BOOL _isSignin; //是否已签到
}
@property(nonatomic, copy)NSString *orderId;

@property(nonatomic, weak)ViewController *orderListViewController;

@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)UITableViewCell *locateCell;    //定位
@property(nonatomic, strong)ButtonTableViewCell *signinButtonCell;//签到
@property(nonatomic, strong)NSMutableDictionary *headerViewCache;

@property(nonatomic, strong)UIButton *confirmButton;
@property(nonatomic, strong)UIView *customFooterView; //确认
@property(nonatomic, strong)NSMutableArray *maintanceTimeArray; //保修期

@property(nonatomic, strong)NormalSelectTableViewCell *issueCodeCell;//故障代码


- (TextSegmentTableViewCell*)makeTextSegmentCellWithTitle:(NSString*)title;

//items: KeyValueModel array
- (void)insertSegmentItems:(NSArray*)items toSegment:(TextSegmentTableViewCell*)segmentCell segWidth:(CGFloat)width;

- (ButtonTableViewCell*)makeButtonTableViewCell:(NSString*)title action:(SEL)selector;

- (UITableViewCell*)makeLeftTitleRightButtonCell:(UIButton*)rightBtn action:(SEL)action;

- (TextFieldTableViewCell*)makeTextFieldCell:(NSString*)placeHolder;

- (void)startLocateCurrentAddress;

- (NSInteger)getValuedSegmentIndex:(NSArray*)segDataArry key:(NSString*)selectKey;
- (NSInteger)getValuedSegmentIndex:(NSArray*)segDataArry value:(NSString*)selectValue;

//提交按钮被触发
- (void)confirmButtonClicked:(UIButton*)button;

//签到请求,子类需要重写
- (void)repairSigninWithResponse:(RequestCallBackBlock)requestCallBackBlock;

//能否返回到上一级
- (BOOL)couldBackViewController;

//return to previous orderlist view controller
- (void)popToTopOrderListViewController;

- (TextViewCell*)makeTextViewCell:(NSString*)placeHolder maxWords:(NSInteger)maxWords;

- (void)setIssueCodeToView:(NSString*)code value:(NSString*)value;

@end
