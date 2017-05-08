//
//  AssignEmployeeViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/9/2.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "AssignEmployeeViewController.h"

#import "EmployeeInfoCell.h"
#import "AssignEmployeeSearchController.h"
#import "QuickFuzzySearch.h"

static NSString *sEmployeeInfoCellIdentifier = @"sEmployeeInfoCell";

@interface AssignEmployeeViewController ()<WZTableViewDelegate, BMKMapViewDelegate, UISearchDisplayDelegate, UITableViewDataSource>

@property(nonatomic, strong)EmployeeInfoCell *protypeCell;

@property(nonatomic, strong)UIButton *searchButton;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)BMKMapView *mapView;
@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)UISearchDisplayController *searchController;

//ITEM: EmployeeInfo, 维修工列表
@property(nonatomic, strong)NSMutableArray *repairerListArray;
@property(nonatomic, strong)NSArray *searchedRepairers;

@end

@implementation AssignEmployeeViewController
{
    CLLocationCoordinate2D _clientLocateCoordinate;
    BMKPointAnnotation *_clientAddrAnnotation;
}

- (WZTableView*)tableView
{
    if (nil == _tableView) {
        _tableView = [[WZTableView alloc]initWithStyle:UITableViewStylePlain delegate:self];
        [_tableView addLineTo:kFrameLocationTop];
        _tableView.tableView.footerHidden = YES;
        [_tableView.tableView registerClass:[EmployeeInfoCell class] forCellReuseIdentifier:sEmployeeInfoCellIdentifier];
        _tableView.showWaitingDialog = NO;
        _protypeCell = [_tableView.tableView dequeueReusableCellWithIdentifier:sEmployeeInfoCellIdentifier];
    }
    return _tableView;
}

- (BMKMapView*)mapView
{
    if (nil == _mapView) {
        CGRect mapFrame = CGRectMake(0, 0, ScreenWidth, 200);
        _mapView = [[BMKMapView alloc]initWithFrame:mapFrame];
        _mapView.zoomLevel = 17;
    }
    return _mapView;
}

- (void)makeAndLayoutCustomSubViews
{
    //map view
    [self.view addSubview:self.mapView];

    //list view
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    [self.tableView refreshTableViewData];
}

-(NSMutableArray*)repairerListArray{
    if (nil == _repairerListArray) {
        _repairerListArray = [[NSMutableArray alloc]init];
    }
    return _repairerListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchButton = [self setNavBarRightButton:ImageNamed(@"search_white") highlighted:ImageNamed(@"search_white") clicked:@selector(navbarRightButtonClicked:)];
    self.searchButton.enabled = NO;

    [self makeAndLayoutCustomSubViews];
}

- (void)navbarRightButtonClicked:(UIButton*)button
{
    AssignEmployeeSearchController *searchVc;
    searchVc = [AssignEmployeeSearchController new];

    //init search bar and display controller
    _searchBar = [[UISearchBar alloc]init];
    _searchController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:searchVc];
    _searchController.delegate = self;
    _searchController.searchResultsDataSource = self;
    _searchController.searchResultsDelegate = self;
    
    //set memebers
    searchVc.parentVc = self;
    searchVc.searchController = _searchController;

    [self pushViewController:searchVc];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}

- (void)navBarLeftButtonClicked:(UIButton *)defaultLeftButton
{
    _mapView = nil;
    [super navBarLeftButtonClicked:defaultLeftButton];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    if (self.isSelfViewNil) {
        self.mapView = nil;
        self.tableView = nil;
        self.repairerListArray = nil;
        self.searchedRepairers = nil;
    }
}

- (NSArray*)searchRepairersFrom:(NSArray*)allRepairers matched:(NSString*)keyStr
{
    NSMutableArray *matchedEmployees = [NSMutableArray new];
    
    for (RepairerInfo *info in allRepairers) {
        NSString *keySource = info.repairman_name;
        if (![Util isEmptyString:keySource]) {
            NSArray *searchedItems = [QuickFuzzySearch userFuzzySearch:@[keySource] keyStr:keyStr];
            if (searchedItems && searchedItems.count > 0) {
                [matchedEmployees addObject:info]; //matched
            }
        }
    }

    return matchedEmployees;
}

#pragma mark
#pragma mark public methods
- (void) requestRepairerListWithResponse:(RequestCallBackBlockV2)responseBlock {
    GetRepairerListInputParams *input = [GetRepairerListInputParams new];
    input.object_id = [self.orderId description];
    
    [Util showWaitingDialog];
    [self.httpClient getRepairerList:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        NSArray *repairers;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            repairers = [MiscHelper parserObjectList:responseData.resultData objectClass:@"RepairerInfo"];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
        responseBlock(error, responseData, repairers);
    }];
}

- (void) assignOrderToRepairer:(RepairerInfo*)repairer response:(RequestCallBackBlock)responseBlock {
    AssignEngineerInputParams *input = [AssignEngineerInputParams new];
    input.object_id = [self.orderId description];
    input.repairmanid = repairer.repairman_id;
    
    [Util showWaitingDialog];
    [self.httpClient assignEngineer:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        responseBlock(error, responseData);
    }];
}

#pragma mark
#pragma mark UITableViewDelegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    __weak __typeof(&*self)weakSelf = self;
    [self requestRepairerListWithResponse:^(NSError *error, HttpResponseData *responseData, id extData) {

        NSArray *repairers = (NSArray *)extData;

        //store repairers and show them
        [self.repairerListArray removeAllObjects];
        if ([repairers isKindOfClass:[NSArray class]]
            && repairers.count > 0) {
            [self.repairerListArray addObjectsFromArray:repairers];
            RepairerInfo *firstRepairer = weakSelf.repairerListArray[0];
            _clientLocateCoordinate = CLLocationCoordinate2DMake([firstRepairer.customer_la doubleValue] , [firstRepairer.customer_lo doubleValue]);
        }
        self.searchButton.enabled = (self.repairerListArray.count > 0);
        [tableView didRequestTableViewListDatasWithCount:self.repairerListArray.count totalCount:self.repairerListArray.count page:pageInfo response:responseData error:error];
        [self setClientLocationAnnotation:_clientLocateCoordinate];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *repaiers = [self recognizeRepairersByTableView:tableView];
    return repaiers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.protypeCell fitHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmployeeInfoCell *cell = [[EmployeeInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sEmployeeInfoCellIdentifier];

    return [self setCell:cell withData:indexPath forTableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *repaiers = [self recognizeRepairersByTableView:tableView];
    RepairerInfo *repairer = repaiers[indexPath.row];

    BOOL bSameWorker = (![Util isEmptyString:self.assignerId] && [self.assignerId isEqualToString:repairer.repairman_id]);
    bSameWorker = NO;//暂时不管是否已派给同一人
    if (bSameWorker) { //无需重派给同一人
        [Util showAlertView:nil message:[NSString stringWithFormat:@"已派工给%@,无需重派",repairer.repairman_name]];
    }else {
        NSString *confirmText = [NSString stringWithFormat:@"确认要派工给%@吗？", repairer.repairman_name];
        [Util confirmAlertView:confirmText confirmAction:^{
            [self assignOrder:self.orderId toEngineer:repairer];
        }];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.searchedRepairers = [self searchRepairersFrom:self.repairerListArray matched:searchString];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    self.searchedRepairers = [self searchRepairersFrom:self.repairerListArray matched:controller.searchBar.text];

    return YES;
}

- (NSArray*)recognizeRepairersByTableView:(UITableView*)tableView
{
    BOOL bIsSearched = (tableView == self.searchController.searchResultsTableView);
    if (bIsSearched) {
        return self.searchedRepairers;
    }else {
        return self.repairerListArray;
    }
}

- (void)assignOrder:(NSString*)orderId toEngineer:(RepairerInfo*)repairer
{
    [self assignOrderToRepairer:repairer response:^(NSError *error, HttpResponseData *responseData) {
        if (!error) {
            NSString *promptStr = [Util getErrorDescritpion:responseData otherError:error];
            if (kHttpReturnCodeSuccess == responseData.resultCode) {
                promptStr = @"分派成功";
            }
            switch (responseData.resultCode) {
                case kHttpReturnCodeSuccess:
                case kHttpReturnCodeChangedAssign:
                    [self postNotification:NotificationOrderChanged];
                    [MiscHelper popToOrderListViewController:self];
//                    [self popViewController];
                    break;
                default:
                    break;
            }
            [Util showToast:promptStr];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}


- (EmployeeInfoCell*)setCell:(EmployeeInfoCell*)cell withData:(NSIndexPath*)indexPath forTableView:(UITableView*)tableView
{
    
    NSArray *repaiers = [self recognizeRepairersByTableView:tableView];

    RepairerInfo *repairer = repaiers[indexPath.row];

    cell.leftNumIcon.contentMode = UIViewContentModeCenter;
    cell.leftNumIcon.image = ImageNamed(@"map-tag-blue");
    cell.leftNumLabel.text = [NSString intStr:indexPath.row + 1];
    cell.leftNumLabel.textAlignment = NSTextAlignmentCenter;
    cell.leftNumLabel.font = SystemBoldFont(16);

    cell.nameLabel.text = [Util defaultStr:kNoName ifStrEmpty:repairer.repairman_name];

    //set the 1st telphone number to show
    NSArray *repairmanTels = [repairer.repairman_phone componentsSeparatedByString:@","];
    if (repairmanTels.count > 0) {
        cell.mobileLabel.text = repairmanTels[0];
    }
    cell.mobileLabel.textColor = kColorDefaultGreen;

    cell.taskCountLabel.text = [NSString stringWithFormat:@"任务 %@",repairer.tasktotal];
    cell.taskCountLabel.hidden = YES;   //hidden it at present

    cell.infoLabel.text = [Util defaultStr:@"地址未知" ifStrEmpty:repairer.repairman_address];
    cell.infoLabel.textColor = kColorDefaultOrange;

    //cell background color
    UIColor *backgroundColor = indexPath.row%2 ? kColorDefaultBackGround :kColorWhite;
    cell.backgroundColor = backgroundColor;
    cell.contentView.backgroundColor = backgroundColor;
    
    cell.leftTagView.hidden = ([Util isEmptyString:self.assignerId] || ![self.assignerId isEqualToString:repairer.repairman_id]);
    
    [cell layoutCustomSubViews];

    return cell;
}

- (void)setClientLocationAnnotation:(CLLocationCoordinate2D)coordinate
{
    if (coordinate.longitude > 0 && 0 < coordinate.latitude){
        [self removeExistedAnnotation];

        _clientAddrAnnotation = [[BMKPointAnnotation alloc]init];
        _clientAddrAnnotation.coordinate = coordinate;
        _clientAddrAnnotation.title = @"客户位置";
        [self.mapView addAnnotation:_clientAddrAnnotation];

        self.mapView.centerCoordinate = coordinate;
    }
}

- (void)removeExistedAnnotation
{
    NSArray *array = [self.mapView annotations];
    if (nil != array && [array count] > 0){
        [self.mapView removeAnnotations:array];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        //Client Location Point
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"clientLocation"];
        newAnnotationView.animatesDrop = YES;
        newAnnotationView.annotation = annotation;
        newAnnotationView.image = ImageNamed(@"map-tag-orange");
        return newAnnotationView;
    }
    return nil;
}

@end
