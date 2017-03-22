//
//  TBHomePadViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/3.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "TBHomePadViewController.h"
//#import "HomePadItemTableViewCell.h"
//
//#import "OrderListViewController.h"
//#import "PartTraceViewController.h"
//#import "ServiceImproveViewController.h"
//#import "TechnicalSupportViewController.h"
//
////Letv
//#import "LetvOrderListViewController.h"
//#import "LetvTechnicalSupportViewController.h"
//
//#import "WZWebViewController.h"
//
//#pragma mark - QuestionnaireSurveyEntryView
//
//@interface QuestionnaireSurveyEntryView : UIView
//@property(nonatomic, strong)UILabel *label;
//@property(nonatomic, strong)UIButton *button;
//@end
//
//@implementation QuestionnaireSurveyEntryView
//-(instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = ColorWithHex(@"#149817");
//        
//        _label = [UILabel new];
//        _label.textColor = ColorWithHex(@"#fbc534");
//        _label.font = SystemFont(14);
//        [self addSubview:_label];
//        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@(kTableViewLeftPadding));
//            make.centerY.equalTo(self);
//        }];
//        
//        _button = [UIButton transparentTextButton:@"参与"];
//        _button.titleLabel.font = SystemFont(14);
//        [_button setTitleColor:kColorWhite forState:UIControlStateNormal];
//        [_button circleCornerWithRadius:10.0];
//        _button.layer.borderColor = kColorWhite.CGColor;
//        _button.layer.borderWidth = 1.0;
//        _button.userInteractionEnabled = NO;
//        [self addSubview:_button];
//        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(@(-kTableViewLeftPadding));
//            make.centerY.equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(38, 20));
//        }];
//    }
//    return self;
//}
//@end
//
//#pragma mark - TBHomePadViewController
//
//@interface TBHomePadViewController ()<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
//@property(nonatomic, strong)UITableView *tableView;
//@property(nonatomic, strong)TableViewDataSourceModel *dataSourceModel;
//@property(nonatomic, strong)QuestionnaireSurveyEntryView *surveyView;
//
//@end
//
@implementation TBHomePadViewController
//
//- (QuestionnaireSurveyEntryView*)surveyView{
//    if (nil == _surveyView) {
//        _surveyView = [[QuestionnaireSurveyEntryView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kButtonLargeHeight)];
//        [_surveyView addSingleTapEventWithTarget:self action:@selector(questionnaireSurveyEntryViewClicked:)];
//        _surveyView.label.text = @"售后管家用户体验调查问卷";
//    }
//    return _surveyView;
//}
//
//- (UITableView*)tableView
//{
//    if (nil == _tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        [_tableView clearBackgroundColor];
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.showsHorizontalScrollIndicator = NO;
//        _tableView.backgroundView = nil;
//        [_tableView hideExtraCellLine];
//    }
//    return _tableView;
//}

//- (TableViewCellData*)makeTableViewCellData:(kHomePadFeatureItem)feature isLetv:(BOOL)isLetv
//{
//    TableViewCellData *cellData;
//
//    cellData = [TableViewCellData makeWithTag:feature];
//    
//    ViewController *targetVc = [self makeViewControllerByFeature:feature isLetv:isLetv];
//    cellData.otherData = targetVc;
//
//    return cellData;
//}
//
//- (void)makeDataSourceModel
//{
//    TableViewCellData *cellData;
//    kUserRoleType roleType = self.user.userRoleType;
//    NSInteger sectionIndex = 0;
//    NSMutableArray *tempItemArray;
//
//    if (nil == self.dataSourceModel) {
//        self.dataSourceModel = [TableViewDataSourceModel new];
//    }
//    
//    //用HEADER中的OTHERDATA来存放CELLDATA数组
//
//    //售后服务（长虹、启客、三洋、迎燕等)
//    //服务商:工单处理、技术点评、服务改善、备件跟踪
//    //维修工:工单处理、技术点评、备件跟踪
//    //技术支持:任务处理
//    TableViewSectionHeaderData *header1 = [TableViewSectionHeaderData makeWithTitle:@"售后服务（长虹、启客、三洋、迎燕等）"];
//    [self.dataSourceModel setHeaderData:header1 forSection:0];
//
//    sectionIndex = 0;
//    tempItemArray = [NSMutableArray new];
//    header1.otherData = tempItemArray;
//
//    if (kUserRoleTypeFacilitator == roleType
//        || kUserRoleTypeRepairer == roleType) {
//
//        //工单处理
//        cellData = [self makeTableViewCellData:kHomePadFeatureItemOrderManage isLetv:NO];
//        [tempItemArray addObject:cellData];
//
//        //技术点评
//        cellData = [self makeTableViewCellData:kHomePadFeatureItemSupport isLetv:NO];
//        [tempItemArray addObject:cellData];
//
//        if (kUserRoleTypeFacilitator == roleType) {
//            //服务改善
//            cellData = [self makeTableViewCellData:kHomePadFeatureItemImprovement isLetv:NO];
//            [tempItemArray addObject:cellData];
//        }
//
//        //备件跟踪
//        cellData = [self makeTableViewCellData:kHomePadFeatureItemPartTrace isLetv:NO];
//        [tempItemArray addObject:cellData];
//    }else if (kUserRoleTypeSupporter == roleType){
//        //任务处理
//        cellData = [self makeTableViewCellData:kHomePadFeatureItemTaskManage isLetv:NO];
//        [tempItemArray addObject:cellData];
//    }
//
//    //售后服务（乐视）
//    //服务商:工单处理、技术点评
//    //维修工:工单处理、技术点评
//    //技术支持:任务处理
//    sectionIndex = 1;
//    TableViewSectionHeaderData *header2 = [TableViewSectionHeaderData makeWithTitle:@"售后服务（乐视）"];
//    [self.dataSourceModel setHeaderData:header2 forSection:sectionIndex];
//    tempItemArray = [NSMutableArray new];
//    header2.otherData = tempItemArray;
//
//    if (kUserRoleTypeFacilitator == roleType
//        || kUserRoleTypeRepairer == roleType) {
//
//        //工单处理
//        cellData = [self makeTableViewCellData:kHomePadFeatureItemOrderManage isLetv:YES];
//        [tempItemArray addObject:cellData];
//#ifdef Module_TecSupport
//        //技术点评
//        cellData = [self makeTableViewCellData:kHomePadFeatureItemSupport isLetv:YES];
//        [tempItemArray addObject:cellData];
//#endif
//    }else if (kUserRoleTypeSupporter == roleType){
//        //任务处理
//        cellData = [self makeTableViewCellData:kHomePadFeatureItemTaskManage isLetv:YES];
//        [tempItemArray addObject:cellData];
//    }
//}

//- (void)showQuestionnaireSurveyIfNeed
//{
//    NSDate *dedlineDate = [Util dateWithString:@"20161019000000" format:WZDateStringFormat9];
//
//    BOOL isTimeout = ([[NSDate date]minutesBeforeDate:dedlineDate] < 0);
//
//    //问卷调查
//    if (!isTimeout && (kUserRoleTypeFacilitator == self.user.userRoleType
//        || kUserRoleTypeRepairer == self.user.userRoleType)) {
//        self.tableView.tableHeaderView = self.surveyView;
//
//        //如果从来没有显示过时，应该立即弹出问卷调查表
//        UserDefaults *userDefault = [UserDefaults sharedInstance];
//        if (userDefault.questionnaireSurveyPageShowCount <= 0) {
//            [self popupQuestionnaireSurveyPage];
//            userDefault.questionnaireSurveyPageShowCount += 1;
//        }
//    }else {
//        _surveyView = nil;
//        UIView *topSpace = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, kDefaultSpaceUnit)];
//        [topSpace clearBackgroundColor];
//        self.tableView.tableHeaderView = topSpace;
//    }
//}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.title = @"工单处理";
//    
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    [self makeDataSourceModel];
//    
//    [self doObserveNotification:UIApplicationDidBecomeActiveNotification selector:@selector(onApplicationDidBecomeActive:)];
//}

//- (void)didReceiveMemoryWarning{
//    [super didReceiveMemoryWarning];
//    [self undoObserveNotification:UIApplicationDidBecomeActiveNotification];
//}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self showQuestionnaireSurveyIfNeed];
//}
//
//- (void)onApplicationDidBecomeActive:(id)object
//{
//    [self showQuestionnaireSurveyIfNeed];
//}
//
//- (void)questionnaireSurveyEntryViewClicked:(id)sender
//{
//    [self popupQuestionnaireSurveyPage];
//}
//
//- (void)popupQuestionnaireSurveyPage
//{
//    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 100)];
//    
//    NSURL *url = [NSURL URLWithString:@"https://sojump.com/m/9878005.aspx"];
//    webView.delegate = self;
//
//    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
//    [webView loadRequest:requst];
//    
//    WZModal *modal = [WZModal sharedInstance];
//    modal.showCloseButton = YES;
//    modal.tapOutsideToDismiss = YES;
//    modal.onTapOutsideBlock = ^(){
//        [self.view.window makeKeyAndVisible];
//    };
//    modal.contentViewLocation = WZModalContentViewLocationBottom;
//    [modal showWithContentView:webView andAnimated:YES];
//}


//#pragma mark - TableView Delegate & Data source
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return [self.dataSourceModel numberOfSections];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    TableViewSectionHeaderData *headerData = [self.dataSourceModel headerDataOfSection:section];
//
//    NSInteger itemCnt = ((NSArray*)headerData.otherData).count;
//    return itemCnt/4 + ((0 == itemCnt%4) ? 0 : 1);
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return kTableViewSectionHeaderHeight;
//}
//
//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    TableViewSectionHeaderData *headerData = [self.dataSourceModel headerDataOfSection:section];
//    return headerData.title;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 86;
//}
//
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString* sCellId = @"HomePadItemCellId";
//
//    HomePadItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellId];
//    if (!cell) {
//        cell = [[HomePadItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellId];
//    }
//    
//    TableViewSectionHeaderData *headerData = [self.dataSourceModel headerDataOfSection:indexPath.section];
//    NSArray *allItems = (NSArray*)headerData.otherData;
//
//    NSInteger startIndex = indexPath.row * 4;
//    NSInteger len = MIN(4, allItems.count - startIndex);
//    NSRange range = NSMakeRange(startIndex, len);
//    NSArray *rowItems = [allItems subarrayWithRange:range];
//    cell.viewController = self;
//    [cell setItemDatas:rowItems itemSize:CGSizeMake(ScreenWidth/4, 86)];
//    
//    return cell;
//}

#if 0
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    TableViewCellData *cellData = [self.dataSourceModel cellDataForSection:indexPath.section row:indexPath.row];
//
//    UIViewController *targetVc = (ViewController*)cellData.otherData;
//    [self pushViewController:targetVc];
//}
#endif

//- (ViewController*)makeViewControllerByFeature:(kHomePadFeatureItem)feature isLetv:(BOOL)isLetv
//{
//    ViewController *targetVc;
//    Class targetVcClass;
//
//    if (!isLetv) {
//        switch (feature) {
//            case kHomePadFeatureItemOrderManage:
//                targetVcClass = [OrderListViewController class];
//                break;
//            case kHomePadFeatureItemSupport:
//                targetVcClass = [TechnicalSupportViewController class];
//                break;
//            case kHomePadFeatureItemPartTrace:
//                targetVcClass = [PartTraceViewController class];
//                break;
//            case kHomePadFeatureItemImprovement:
//                targetVcClass = [ServiceImproveViewController class];
//                break;
//            case kHomePadFeatureItemTaskManage:
//                targetVcClass = [OrderListViewController class];
//                break;
//            default:
//                break;
//        }
//    }else { //Letv
//        switch (feature) {
//            case kHomePadFeatureItemOrderManage:
//                targetVcClass = [LetvOrderListViewController class];
//                break;
//            case kHomePadFeatureItemSupport:
//                targetVcClass = [LetvTechnicalSupportViewController class];
//                break;
//            case kHomePadFeatureItemTaskManage:
//                targetVcClass = [LetvOrderListViewController class];
//                break;
//            default:
//                break;
//        }
//    }
//
//    //create view controller
//    if (targetVcClass) {
//        targetVc = [[targetVcClass alloc]init];
//        if (isLetv) {
//            targetVc.title = [NSString stringWithFormat:@"%@ (乐视)",getHomePadFeatureItemName(feature)];
//        }else{
//            targetVc.title = getHomePadFeatureItemName(feature);
//        }
//    }
//    return targetVc;
//}

//#pragma mark - webview
//
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    [Util showWaitingDialogToView:webView];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [Util dismissWaitingDialogFromView:webView];
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    [Util dismissWaitingDialogFromView:webView];
//}

@end
