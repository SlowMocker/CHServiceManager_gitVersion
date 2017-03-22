//
//  AddComponentMaintainViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/8/27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "AddComponentMaintainViewController.h"
#import "WZTableView.h"
#import "ComponentMaintainItemCell.h"
#import "EditComponentMaintainViewController.h"
#import "WZTableViewSessionHeaderView.h"

static NSString *sComponentMaintainItemCellId = @"ComponentMaintainItemCell";

@interface AddComponentMaintainViewController()<WZTableViewDelegate, WZSwipeCellDelegate, EditComponentMaintainVCDelegate>
{
    RequestCallBackBlock commitCallBackBlock;
}
@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)NSMutableArray *componentArray;
@property(nonatomic, strong)WZTableViewSessionFooterView *footerView;
@end

@implementation AddComponentMaintainViewController

- (void)setComponents:(NSArray *)components{
    _components = [components copy];
    [self.componentArray setArray:components];
}

- (NSMutableArray*)componentArray{
    if (_componentArray == nil) {
        _componentArray = [[NSMutableArray alloc]init];
    }
    return _componentArray;
}

- (WZTableViewSessionFooterView*)footerView
{
    if (nil == _footerView) {
        _footerView = [WZTableViewSessionFooterView new];
        _footerView.titleLabel.text = @"说明:已添加的备件项，如果有\"未同步\"标志,会在工单执行时同步至CRM服务器。";
        [_footerView.titleLabel clearBackgroundColor];
        _footerView.backgroundColor = kColorDefaultBackGround;
    }
    return _footerView;
}

- (WZTableView*)tableView
{
    if (nil == _tableView) {
        _tableView = [[WZTableView alloc]initWithStyle:UITableViewStylePlain delegate:self];
        _tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableView.showsHorizontalScrollIndicator = NO;
        [_tableView.tableView clearBackgroundColor];
        _tableView.showWaitingDialog = NO;
        [_tableView.tableView registerClass:[ComponentMaintainItemCell class] forCellReuseIdentifier:sComponentMaintainItemCellId];
        _tableView.tableView.backgroundView = nil;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self setNavBarRightButton:@"添加" clicked:@selector(addButtonClicked:)];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self.tableView refreshTableViewData];
}

- (void)addButtonClicked:(UIButton*)rightNavBtn{
    EditComponentMaintainViewController *addVc = [[EditComponentMaintainViewController alloc]init];
    addVc.componentArray = self.orderDetails.tDispatchParts;
    addVc.productInfo = self.productInfo;
    addVc.delegate = self;
    addVc.maintainContent.object_id = self.orderDetails.object_id;
    addVc.orderDetails = self.orderDetails;
    addVc.title = @"添加备件";
    [self pushViewController:addVc];
}

#pragma mark - data source & delegate

- (void)tableView:(WZTableView *)tableView requestListDatas:(PageInfo *)pageInfo
{
    [tableView didRequestTableViewListDatasWithCount:self.orderDetails.tDispatchParts.count totalCount:self.orderDetails.tDispatchParts.count page:pageInfo response:nil error:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.componentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kDefaultSpaceUnit;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComponentMaintainItemCell *cell = [tableView dequeueReusableCellWithIdentifier:sComponentMaintainItemCellId];
    PartMaintainContent *part = self.componentArray[indexPath.section];
    [self setCell:cell withData:part];
    
    NSLog(@"wf: %f", [cell fitHeight]);

    return [cell fitHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComponentMaintainItemCell *cell = [tableView dequeueReusableCellWithIdentifier:sComponentMaintainItemCellId];
    PartMaintainContent *part = self.componentArray[indexPath.section];
    return [self setCell:cell withData:part];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger lastSectionIndex = [self numberOfSectionsInTableView:tableView] - 1;
    return (lastSectionIndex == section) ? 60 : 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSInteger lastSectionIndex = [self numberOfSectionsInTableView:tableView] - 1;
    return (lastSectionIndex == section) ? self.footerView : nil;
}

- (ComponentMaintainItemCell*)setCell:(ComponentMaintainItemCell*)cell withData:(PartMaintainContent*)data
{
    cell.partInfo = data;
    cell.delegate = self;
    return cell;
}

//新加或编辑了备件，刷新列表
- (void)componentMaintainEditCellDidEdit:(PartMaintainContent *)data
{
    if (![self.componentArray containsObject:data]) {
        [self.componentArray addObject:data];
    }
    if ([self.delegate respondsToSelector:@selector(addComponentMaintainFinished:updated:)]) {
        [self.delegate addComponentMaintainFinished:self updated:self.componentArray];
    }
    [self.tableView refreshTableViewData];
}

//删除了备件，刷新列表
- (void)deleteComponentMaintainItemFromServer:(PartMaintainContent*)data
{
    //delete from server
    RepairerDeletePartInputParams *input = [RepairerDeletePartInputParams new];
    input.dispatchparts_id = data.dispatch_parts_id;

    [Util showWaitingDialog];
    [self.httpClient repairer_deletePart:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            [self.componentArray removeObject:data];

            if ([self.delegate respondsToSelector:@selector(addComponentMaintainFinished:updated:)]) {
                [self.delegate addComponentMaintainFinished:self updated:self.componentArray];
            }
            [self.tableView refreshTableViewData];
            [self postNotification:NotificationOrderDetailsChanged];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

#pragma mark - cell's delegate

- (void)swipeCell:(WZSwipeCell *)swipeCell menuButtonSelected:(NSInteger)menuButtonTag
{
    ComponentMaintainItemCell* cell = (ComponentMaintainItemCell*)swipeCell;
    kComponentMaintainHandleType handleType = (kComponentMaintainHandleType)menuButtonTag;
    
    switch (handleType) {
        case kComponentMaintainHandleTypeView:
            break;
        case kComponentMaintainHandleTypeEdit:
        {
            EditComponentMaintainViewController *editVc = [[EditComponentMaintainViewController alloc]init];
            editVc.componentArray = self.orderDetails.tDispatchParts;
            editVc.productInfo = self.productInfo;
            editVc.maintainContent = cell.partInfo;
            editVc.delegate = self;
            editVc.orderDetails = self.orderDetails;
            editVc.title = @"编辑备件";
            [self pushViewController:editVc];
        }
            break;
        case kComponentMaintainHandleTypeDelete:
        {
            [Util confirmAlertView:@"您确定要删除吗？" confirmAction:^{
                [self deleteComponentMaintainItemFromServer:cell.partInfo];
            }];
        }
            break;
        default:
            break;
    }
}

@end
