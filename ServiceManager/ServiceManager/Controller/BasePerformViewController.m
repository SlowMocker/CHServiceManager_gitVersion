//
//  BasePerformViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/6.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "BasePerformViewController.h"
#import "OrderListViewController.h"

@interface BasePerformViewController ()
@end

@implementation BasePerformViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //create table view
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kDefaultSpaceUnit, 0, kDefaultSpaceUnit));
    }];

    //location
    _latitude = 0; _longitude = 0;
    [self startLocateCurrentAddress];
    
    //reset navigation left button
    [self setOrUpdateNavLeftButton];
}

- (void)setOrUpdateNavLeftButton{
    UIButton *leftBtn = [[UIButton alloc]init];
    
    BOOL bBack = [self couldBackViewController];
    if (bBack) {
        [leftBtn setImage:ImageNamed(@"go_back_white") forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(navBarLeftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [leftBtn clearBackgroundColor];
    leftBtn.titleLabel.font = SystemFont(14);
    [leftBtn setTitleColor:bBack ? kColorWhite : kColorDefaultOrange forState:UIControlStateNormal];
    [leftBtn setTitle:self.orderId forState:UIControlStateNormal];
    [leftBtn sizeToFit];

    [self setNavBarLeftView:leftBtn];
}

- (void)navBarLeftButtonClicked:(UIButton *)defaultLeftButton
{
    [Util confirmAlertView:nil message:@"工单处理未完成，确认返回?" confirmTitle:@"确认" confirmAction:^{
        [super navBarLeftButtonClicked:defaultLeftButton];
    } cancelTitle:nil cancelAction:nil];
}

- (BOOL)couldBackViewController
{
    return YES;
}

- (NSMutableDictionary*)headerViewCache{
    if (nil == _headerViewCache) {
        _headerViewCache = [NSMutableDictionary new];
    }
    return _headerViewCache;
}

- (UITableViewCell*)locateCell{
    if (nil == _locateCell) {
        _locateCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _locateCell.imageView.image = ImageNamed(@"location_orange");
        _locateCell.textLabel.text = @"定位";
        _locateCell.selectionStyle = UITableViewCellSelectionStyleDefault;
        _locateCell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _locateCell;
}

- (ButtonTableViewCell*)signinButtonCell{
    if (nil == _signinButtonCell) {
        _signinButtonCell = [self makeButtonTableViewCell:@"上门签到" action:@selector(signinButtonClicked:)];
    }
    return _signinButtonCell;
}

- (NormalSelectTableViewCell*)issueCodeCell{
    if (nil == _issueCodeCell) {
        _issueCodeCell = [[NormalSelectTableViewCell alloc]initWithTitle:@"故障代码" reuseIdentifier:nil];
        [_issueCodeCell addLineTo:kFrameLocationBottom];
    }
    return _issueCodeCell;
}

- (TextSegmentTableViewCell*)makeTextSegmentCellWithTitle:(NSString *)title
{
    TextSegmentTableViewCell *cell = [[TextSegmentTableViewCell alloc]initWithSize:CGSizeMake(100, 30) reuseIdentifier:nil];
    cell.segment.tintColor = kColorDefaultOrange;
    cell.segment.selectedSegmentIndex = NSNotFound;
    cell.textLabel.text = title;
    [cell.textLabel adjustsFontSizeToFitWidth];

    return cell;
}

- (UITableViewCell*)makeButtonCell:(UIButton*)button action:(SEL)action
{
    button.backgroundColor = kColorWhite;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell.contentView addSubview:button];
    [cell clearBackgroundColor];
    [cell.contentView clearBackgroundColor];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsMake(kDefaultSpaceUnit, 0, kDefaultSpaceUnit, 0));
    }];
    return cell;
}

- (void)insertSegmentItems:(NSArray*)items toSegment:(TextSegmentTableViewCell*)segmentCell segWidth:(CGFloat)width
{
    segmentCell.segmentItems = items;
    segmentCell.segment.frame = CGRectMake(0, 0, width, 28);
}

- (ButtonTableViewCell*)makeButtonTableViewCell:(NSString*)title action:(SEL)selector
{
    UIEdgeInsets insets = UIEdgeInsetsMake(kDefaultSpaceUnit, 0, kDefaultSpaceUnit, 0);
    ButtonTableViewCell *cell = [[ButtonTableViewCell alloc]initWithButtonEdge:insets reuseIdentifier:nil];
    [cell.button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [cell.button setTitle:title forState:UIControlStateNormal];
    [cell clearBackgroundColor];
    [cell.contentView clearBackgroundColor];
    cell.button.backgroundColor = kColorWhite;
    
    return cell;
}

- (NSInteger)getValuedSegmentIndex:(NSArray*)segDataArry key:(NSString*)selectKey
{
    for (KeyValueModel *model in segDataArry) {
        if ([model.key isEqualToString:selectKey]) {
            return [segDataArry indexOfObject:model];
        }
    }
    return NSNotFound;
}

- (NSInteger)getValuedSegmentIndex:(NSArray*)segDataArry value:(NSString*)selectValue
{
    for (KeyValueModel *model in segDataArry) {
        if ([model.value isEqualToString:selectValue]) {
            return [segDataArry indexOfObject:model];
        }
    }
    return NSNotFound;
}

- (WZTableView*)tableView
{
    if (nil == _tableView) {
        _tableView = [[WZTableView alloc]initWithStyle:UITableViewStyleGrouped delegate:nil];
        _tableView.tableView.headerHidden = NO;
        _tableView.tableView.footerHidden = YES;
        _tableView.pageInfo.pageSize = MAXFLOAT;
        [_tableView clearBackgroundColor];
        [_tableView.tableView clearBackgroundColor];
        _tableView.tableView.backgroundView = nil;
        _tableView.tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableView.headerHidden = YES;
    }
    return _tableView;
}

- (UITableViewCell*)makeLeftTitleRightButtonCell:(UIButton*)rightBtn action:(SEL)action
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.textColor = kColorDarkGray;
    cell.textLabel.font = SystemFont(14);
    [cell clearBackgroundColor];
    [cell.contentView clearBackgroundColor];
    
    [rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 180, 30);
    cell.accessoryView = rightBtn;
    
    return cell;
}

- (TextFieldTableViewCell*)makeTextFieldCell:(NSString*)placeHolder
{
    TextFieldTableViewCell *editCell = [[TextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    editCell.textField.placeholder = placeHolder;
    editCell.textField.adjustsFontSizeToFitWidth = YES;
    editCell.textField.textColor = kColorDefaultBlue;
    [editCell addLineTo:kFrameLocationBottom];
    
    return editCell;
}

- (void)startLocateCurrentAddress
{
    __block NSString *locateStr;
    self.locateCell.selected = YES;
    
    self.locateCell.textLabel.text = @"正在定位...";
    [MiscHelper locateCurrentAddressWithComplete:^(BMKReverseGeoCodeResult *location) {
        self.locateCell.selected = NO;
        
        if (nil == location) {
            locateStr = @"定位失败，再试一次";
            _longitude = 0;
            _latitude = 0;
            _signinAddress = nil;
        }else {
            locateStr = location.address;
            _longitude = location.location.longitude;
            _latitude = location.location.latitude;
            _signinAddress = [location.address copy];
            if (_isSignin) {
                [self.signinButtonCell.button setTitle:@"重新签到" forState:UIControlStateNormal];
            }
        }
        self.locateCell.textLabel.text = locateStr;
    }];
}

- (void)signinButtonClicked:(UIButton*)sender
{
    if (0 == _latitude || 0 == _longitude) {
        [Util showToast:@"请先定位您的位置"];
    }else {
        [self repairSignIn];
    }
}

- (void)repairSigninWithResponse:(RequestCallBackBlock)requestCallBackBlock
{
    UNIMPLEMENTED;
}

- (void)repairSignIn
{
    [self repairSigninWithResponse:^(NSError *error, HttpResponseData *responseData) {
        _isSignin = (!error && kHttpReturnCodeSuccess == responseData.resultCode);
        if (_isSignin){
            [self.signinButtonCell.button setTitle:@"签到成功" forState:UIControlStateNormal];
            self.signinButtonCell.button.enabled = NO;
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (UIView*)customFooterView
{
    if (nil == _customFooterView) {
        self.confirmButton = [UIButton redButton:@"确定"];
        [self.confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _customFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 2 *kTableViewLeftPadding, kButtonDefaultHeight + 4* kDefaultSpaceUnit)];
        [_customFooterView addSubview:self.confirmButton];
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_customFooterView);
            make.height.equalTo(@(kButtonDefaultHeight));
            make.center.equalTo(_customFooterView);
        }];
    }
    return _customFooterView;
}

- (void)confirmButtonClicked:(UIButton*)button
{
    UNIMPLEMENTED;
}

- (KeyValueModel*)maintanceTimeRangeItem:(kWarrantyRangeDate)rangeDate
{
    NSString *rangeDateStr = [NSString intStr:rangeDate];
    return [KeyValueModel modelWithValue:getWarrantyDateStrById(rangeDateStr) forKey:rangeDateStr];
}

- (void)popToTopOrderListViewController
{
    if (self.orderListViewController) {
        [self popTo:self.orderListViewController];
    }else {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[OrderListViewController class]]) {
                [self popTo:vc];
            }
        }
    }
}

- (TextViewCell*)makeTextViewCell:(NSString*)placeHolder maxWords:(NSInteger)maxWords
{
    CGRect textviewFrame = CGRectMake(0, 0, ScreenWidth - kDefaultSpaceUnit * 2, 100);
    TextViewCell *textCell = [[TextViewCell alloc]initWithFrame:textviewFrame maxWords:maxWords];
    textCell.textView.placeholder = placeHolder;
    
    return textCell;
}

- (void)setIssueCodeToView:(NSString*)code value:(NSString*)value
{    
    if ([Util isEmptyString:code]) {
        [self.issueCodeCell setSelectedItemValue:nil];
    }else {
        AttributeStringAttrs *item1 = [AttributeStringAttrs new];
        item1.text = [NSString stringWithFormat:@"(%@)", code];
        item1.textColor = kColorDefaultOrange;
        item1.font = SystemFont(13);
        
        AttributeStringAttrs *item2 = [AttributeStringAttrs new];
        item2.text = value;
        item2.textColor = kColorBlack;
        item2.font = SystemFont(13);
        [self.issueCodeCell setSelectedItemValueWithAttrStr:[NSString makeAttrString:@[item1, item2]]];
    }
}

@end
