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
#import "SmartMiHistoryOrderListViewController.h"
#import "SupportResourceViewController.h"

#import "SmartMiOrderListViewController.h"

static NSString *sHomeCollectionViewCell = @"HomeCollectionViewCell";
static NSString *sHomeCollectionViewSectionHeader = @"sHomeCollectionViewSectionHeader";

@interface HomeCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

/**
 *  数据源句柄
 */
@property(nonatomic, strong)TableViewDataHandle *dataHandle;

@end

@implementation HomeCollectionView
#pragma mark
#pragma mark init
+ (id) homeCollectionView {
    UICollectionViewFlowLayout *layout = [[HomeCollectionViewLayout alloc]init];
    return [[HomeCollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
}

- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:( UICollectionViewLayout *)layout {
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
#pragma mark
#pragma mark public methods
- (void) reloadDataAndShow {
    self.dataHandle = nil; //set as nil in order to reload data source
    [self reloadData];
}

#pragma mark
#pragma mark UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataHandle numberOfSections];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataHandle numberOfRowsInSection:section];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sHomeCollectionViewCell forIndexPath:indexPath];
    TableViewCellData *cellData = [self.dataHandle cellDataForSection:indexPath.section row:indexPath.row];
    FeatureConfigItem *featureItem = (FeatureConfigItem*)cellData.otherData;
    cell.imageView.image = [self makeImageByIcon:featureItem.itemIcon backgroundColorHex:featureItem.itemBackgroundColorHex];
    cell.textView.text = getHomePadFeatureItemName(featureItem.itemId);
    
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionSectionHeaderView *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sHomeCollectionViewSectionHeader forIndexPath:indexPath];
    
    TableViewSectionHeaderData *headerData = [self.dataHandle headerDataOfSection:indexPath.section];
    sectionHeader.textView.text = headerData.title;

    return sectionHeader;
}
#pragma mark
#pragma mark UICollectionViewDelegate
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    TableViewCellData *cellData = [self.dataHandle cellDataForSection:indexPath.section row:indexPath.row];
    FeatureConfigItem *featureItem = (FeatureConfigItem*)cellData.otherData;

    UIViewController *targetVc = [self makeViewControllerByFeature:featureItem];
    if (nil == targetVc) {
        [Util showToast:@"此功能正在开发中..."];
    }else {
        [self.viewController pushViewController:targetVc];
    }
}
#pragma mark
#pragma mark private method
- (UIImage*) makeImageByIcon:(NSString*)imageName backgroundColorHex:(NSString*)backGroundColorHex {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView.backgroundColor = ColorWithHex(backGroundColorHex);
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = ImageNamed(imageName);
    return [UIImage imageWithView:imageView];
}
/**
 *  选择跳转的 vc
 *
 *  @param featureItem 功能项
 */
- (UIViewController *) viewControllerWithItem:(FeatureConfigItem *) feature {
    UIViewController *vc;
    return vc;
}
- (ViewController*) makeViewControllerByFeature:(FeatureConfigItem*)featureItem {
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
        case kHomeSectionItemSmartMiBrand:   //智米品牌
        {
            switch (featureItem.itemId) {
                case kHomePadFeatureItemOrderManage: // 工单处理
                    targetVcClass = [SmartMiOrderListViewController class];
                    break;
                case kHomePadFeatureItemTaskOrderHistory: // 历史工单
                    targetVcClass = [SmartMiHistoryOrderListViewController class];
                    break;
                case kHomePadFeatureItemSupport: // 技术点评
                    targetVcClass = [TechnicalSupportViewController class];
                    break;
//                case kHomePadFeatureItemPartTrace: // 备件跟踪
//                    targetVcClass = [PartTraceViewController class];
//                    break;
//                case kHomePadFeatureItemImprovement: // 服务改善
//                    targetVcClass = [ServiceImproveViewController class];
//                    break;
                case kHomePadFeatureItemTaskManage: // 任务处理,技术支持人员专项
                    targetVcClass = [OrderListViewController class];
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
#pragma mark
#pragma mark setters and getters
- (TableViewDataHandle *) dataHandle {
    if (nil == _dataHandle) {
        FeatureConfigureHelper *featureCfg = [FeatureConfigureHelper sharedInstance];
        NSArray *features = [featureCfg getDefualtFeatureItems];
        _dataHandle = [featureCfg convertToTableViewDataSourceModel:features onlyVisible:YES];
    }
    return _dataHandle;
}

@end
