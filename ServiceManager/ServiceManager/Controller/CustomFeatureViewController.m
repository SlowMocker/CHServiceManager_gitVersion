//
//  CustomFeatureViewController.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/23.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "CustomFeatureViewController.h"
#import <objc/runtime.h>

#pragma mark - CustomFeatureCell

@interface CustomFeatureCell()
@property(nonatomic, assign)BOOL cancelChanging; //正在撤消值变化
@end

@implementation CustomFeatureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = kColorDarkGray;
        self.textLabel.font = SystemFont(15);
    }
    return self;
}

- (UISwitch *)switchView{
    if (nil == _switchView) {
        _switchView = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 40, 24)];
        _switchView.onTintColor = kColorDefaultOrange;
        _switchView.on = [ConfigInfoManager sharedInstance].bSavePassword;
        [_switchView addTarget:self action:@selector(swithViewValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.accessoryView = _switchView;
    }
    return _switchView;
}

- (void)setFeatureSection:(FeatureSectionItem *)featureSection
{
    if (featureSection != _featureSection) {
        _featureSection = featureSection;
        self.textLabel.text =  _featureSection.title;
        self.switchView.on = _featureSection.visible;
    }
}

- (void)swithViewValueChanged:(id)sender
{
    if (self.cancelChanging) {
        self.cancelChanging = NO;
    }else {
        BOOL allowChangeValue = YES;
        if (self.valueWillChangeBlock) {
            allowChangeValue = self.valueWillChangeBlock(self);
        }

        if (allowChangeValue) {
            self.featureSection.visible = self.switchView.isOn;
            [self postNotification:NotificationNameCustomFeatureChanged];
        }else {
            [Util showAlertView:@"提示" message:@"至少选择一项"];
            //cancel value changed
            self.switchView.on = !self.switchView.isOn;
            self.cancelChanging = YES;
        }
    }
}

@end

#pragma mark - CustomFeatureViewController

@interface CustomFeatureViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *featureSectionArray;
@end

@implementation CustomFeatureViewController

- (UITableView*)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView clearBackgroundColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundView = nil;
        _tableView.scrollEnabled = NO;
        [_tableView hideExtraCellLine];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    self.featureSectionArray = [[FeatureConfigureHelper sharedInstance]getDefualtFeatureItems];
}

- (void)registerNotifications
{
    [self doObserveNotification:UIApplicationDidEnterBackgroundNotification selector:@selector(handleDidEnterBackgroundNotification:)];
}

- (void)unregisterNotifications
{
    [self undoObserveNotification:UIApplicationDidEnterBackgroundNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //返回上一级页面时保存配置信息
    [self saveCustomFeatreus];
}

- (void)handleDidEnterBackgroundNotification:(id)sender
{
    //进入后台时保存配置信息
    [self saveCustomFeatreus];
}

- (void)saveCustomFeatreus
{
    [[FeatureConfigureHelper sharedInstance]resaveFeatureItems];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kDefaultSpaceUnit;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [UIView new];
    [sectionHeaderView clearBackgroundColor];
    return sectionHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.featureSectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kButtonDefaultHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CustomFeatureCell";
    CustomFeatureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[CustomFeatureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.valueWillChangeBlock = ^BOOL(CustomFeatureCell *inCell){
            if (!inCell.switchView.isOn) { //try to disable a feature
                return ![self isFeatureOnlyVisible:inCell.featureSection];
            }else {
                return YES;
            }
        };
    }
    FeatureSectionItem *featureSection = self.featureSectionArray[indexPath.row];
    cell.featureSection = featureSection;
    
    return cell;
}

- (BOOL)isFeatureOnlyVisible:(FeatureSectionItem*)featureSectoin
{
    for (FeatureSectionItem *feaSection in self.featureSectionArray) {
        if (feaSection == featureSectoin) {
            ContinueIf(feaSection.visible);
        }else {
            ContinueIf(!feaSection.visible);
        }
        return NO;
    }
    return YES;
}

@end
