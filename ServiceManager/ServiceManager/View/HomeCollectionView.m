//
//  HomeCollectionView.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/21.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "HomeCollectionView.h"
#import "HomeCollectionViewLayout.h"
#import "HomeCollectionViewCell.h"
#import "HomeCollectionSectionHeaderView.h"

//feature view controllers
#import "OrderListViewController.h"
#import "PartTraceViewController.h"
#import "ServiceImproveViewController.h"
#import "TechnicalSupportViewController.h"
#import "LetvOrderListViewController.h"
#import "LetvTechnicalSupportViewController.h"
#import "FeatureConfigureHelper.h"
#import "ExtendServiceListViewController.h"
#import "EmployeeManageViewCodntroller.h"
#import "FeatureConfigureHelper.h"
#import "HistoryOrderListViewController.h"
#import "LetvHistoryOrderListViewController.h"
#import "SupportResourceViewController.h"

static NSString *sHomeCollectionViewCell = @"HomeCollectionViewCell";
static NSString *sHomeCollectionViewSectionHeader = @"sHomeCollectionViewSectionHeader";

@interface HomeCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong)TableViewDataSourceModel *dataSourceModel;
@end

@implementation HomeCollectionView

+ (id)genarator
{
    UICollectionViewFlowLayout *layout = [[HomeCollectionViewLayout alloc]init];
    return [[HomeCollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:( UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = kColorWhite;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:sHomeCollectionViewCell];
        [self registerClass:[HomeCollectionSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sHomeCollectionViewSectionHeader];
    }
    return self;
}

- (TableViewDataSourceModel *)dataSourceModel{
    if (nil == _dataSourceModel) {
        FeatureConfigureHelper *featureCfg = [FeatureConfigureHelper sharedInstance];
        NSArray *features = [featureCfg getDefualtFeatureItems];
        _dataSourceModel = [featureCfg convertToTableViewDataSourceModel:features onlyVisible:YES];
    }
    return _dataSourceModel;
}

- (void)reloadDataAndShow
{
    self.dataSourceModel = nil; //set as nil in order to reload data source
    [self reloadData];
}

#pragma mark app feature items setting (data source)

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.dataSourceModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSourceModel numberOfRowsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sHomeCollectionViewCell forIndexPath:indexPath];
    TableViewCellData *cellData = [self.dataSourceModel cellDataForSection:indexPath.section row:indexPath.row];
    FeatureConfigItem *featureItem = (FeatureConfigItem*)cellData.otherData;
    cell.imageView.image = [self makeImageByIcon:featureItem.itemIcon backgroundColorHex:featureItem.itemBackgroundColorHex];
    cell.textView.text = getHomePadFeatureItemName(featureItem.itemId);
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionSectionHeaderView *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sHomeCollectionViewSectionHeader forIndexPath:indexPath];
    
    TableViewSectionHeaderData *headerData = [self.dataSourceModel headerDataOfSection:indexPath.section];
    sectionHeader.textView.text = headerData.title;

    return sectionHeader;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    TableViewCellData *cellData = [self.dataSourceModel cellDataForSection:indexPath.section row:indexPath.row];
    FeatureConfigItem *featureItem = (FeatureConfigItem*)cellData.otherData;

    UIViewController *targetVc = [self makeViewControllerByFeature:featureItem];
    if (nil == targetVc) {
        [Util showToast:@"此功能正在开发中..."];
    }else {
        [self.viewController pushViewController:targetVc];
    }
}

- (UIImage*)makeImageByIcon:(NSString*)imageName backgroundColorHex:(NSString*)backGroundColorHex
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView.backgroundColor = ColorWithHex(backGroundColorHex);
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = ImageNamed(imageName);

    return [UIImage imageWithView:imageView];
}

- (ViewController*)makeViewControllerByFeature:(FeatureConfigItem*)featureItem
{
    ViewController *targetVc;
    Class targetVcClass;
    NSString *titleSuffix =  nil;
    
    switch (featureItem.featureSection) {
        case kHomeSectionItemTools:          //工具箱
        {
            switch (featureItem.itemId) {
                case kHomePadFeatureItemExtendService:
                    targetVcClass = [ExtendServiceListViewController class];
                    break;
                case kHomePadFeatureItemEmployeeManage:
                    targetVcClass = [EmployeeManageViewCodntroller class];
                    break;
                case kHomePadFeatureItemResource:
                    targetVcClass = [SupportResourceViewController class];
                    break;
                case kHomePadFeatureItemServicePrice:
                    break;
                default:
                    break;
            }
        }
            break;
        case kHomeSectionItemCommonBrands:   //长虹、启客、三洋、迎燕等品牌
        {
            switch (featureItem.itemId) {
                case kHomePadFeatureItemOrderManage:
                    targetVcClass = [OrderListViewController class];
                    break;
                case kHomePadFeatureItemTaskOrderHistory:
                    targetVcClass = [HistoryOrderListViewController class];
                    break;
                case kHomePadFeatureItemSupport:
                    targetVcClass = [TechnicalSupportViewController class];
                    break;
                case kHomePadFeatureItemPartTrace:
                    targetVcClass = [PartTraceViewController class];
                    break;
                case kHomePadFeatureItemImprovement:
                    targetVcClass = [ServiceImproveViewController class];
                    break;
                case kHomePadFeatureItemTaskManage:
                    targetVcClass = [OrderListViewController class];
                    break;
                default:
                    break;
            }
        }
            break;
        case kHomeSectionItemLetvBrand:      //乐视品牌
        {
            titleSuffix = @"乐视";
            switch (featureItem.itemId) {
                case kHomePadFeatureItemOrderManage:
                    targetVcClass = [LetvOrderListViewController class];
                    break;
                case kHomePadFeatureItemTaskOrderHistory:
                    targetVcClass = [LetvHistoryOrderListViewController class];
                    break;
                case kHomePadFeatureItemSupport:
                    targetVcClass = [LetvTechnicalSupportViewController class];
                    break;
                case kHomePadFeatureItemTaskManage:
                    targetVcClass = [LetvOrderListViewController class];
                    break;
                default:
                    break;
            }
        }
            break;
        case kHomeSectionItemMeiningBrand:   //美菱品牌
        {
            titleSuffix = @"美菱";
            targetVcClass = nil;
        }
            break;
        default:
            break;
    }

    //create view controller
    if (nil != targetVcClass) {
        targetVc = [[targetVcClass alloc]init];
        NSString *vcTitle = getHomePadFeatureItemName(featureItem.itemId);
        if (![Util isEmptyString:titleSuffix]) {
            vcTitle = [NSString stringWithFormat:@"%@ (%@)",vcTitle, titleSuffix];
        }
        targetVc.title = vcTitle;
    }
    return targetVc;
}

@end
