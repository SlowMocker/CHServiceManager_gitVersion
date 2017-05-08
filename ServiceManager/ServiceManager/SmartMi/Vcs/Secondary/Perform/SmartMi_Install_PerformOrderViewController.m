//
//  SmartMi_Install_PerformOrderViewController.m
//  ServiceManager
//
//  Created by Wu on 17/3/29.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "SmartMi_Install_PerformOrderViewController.h"

#import "Common_SignInView.h"
#import "Common_UserInfoView.h"
#import "Install_ProductConfirmationView.h"
#import "Install_OrderContentView.h"

#import "SpecialFinishEntry.h"
#import "ScanGraphicCodeViewController.h"
#import "SmartMiProductModelSearchViewController.h"
#import "WZSingleCheckViewController.h"
#import "WZSingleCheckListPopView.h"

@interface SmartMi_Install_PerformOrderViewController ()<Common_SignInViewDelegate , Common_UserInfoViewDelegate , WZSingleCheckViewControllerDelegate , Install_ProductConfirmationViewDelegate , Install_OrderContentViewDelegate>

@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) Common_SignInView *common_SIView;/**< 上门签到 view */
@property (nonatomic , strong) Common_UserInfoView *common_UIView;/**< 用户信息 view */
@property (nonatomic , strong) Install_ProductConfirmationView *install_PCView;/**< 产品确认 view */
@property (nonatomic , strong) Install_OrderContentView *install_OCView;/**< 订单内容 view */
@property (nonatomic , strong) WZTextView *textView;/**< 备注信息 textView */
@property (nonatomic , strong) UIButton *submitBtn;/**< 提交按钮 */

@property (nonatomic , strong) SmartMiOrderContentDetails *orderDetail;/**< 工单详情 */

@property (nonatomic , assign) BOOL hiddenCancelOrderBtn;/**< 隐藏取消工单的 btn ｜ YES: 隐藏 NO: 显示 ｜ 取消工单只有在扫描出来的条码和已有条码不一致时显示 */

@end

@implementation SmartMi_Install_PerformOrderViewController
{
    CheckItemModel *_clientStreet;
    NSArray *_streets;
    
    NSArray<CheckItemModel *> *_checkItems_category;/**< 品类集合 */
    NSArray<CheckItemModel *> *_checkItems_handle;/**< 常规处理措施集合 */

    BOOL *_hasSignIn;/**< 是否已经上门签到 */
    
    
    NSString *_street;/**< 当前选择的街道 */

}

#pragma mark
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"执行";
    [self setOrUpdateNavLeftButton];
    
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.scrollView];
    [self requestOrderDetail];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    [self.common_SIView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.height.mas_equalTo(155);
        make.width.equalTo(self.view).offset(-20);
    }];
    
    [self.install_PCView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.common_SIView.mas_bottom);
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.height.mas_equalTo(261);
        make.width.equalTo(self.view).offset(-20);
    }];
    
    [self.common_UIView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.install_PCView.mas_bottom);
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.height.mas_equalTo(305);
        make.width.equalTo(self.view).offset(-20);
    }];
    
    [self.install_OCView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.common_UIView.mas_bottom);
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.height.mas_equalTo(461);
        make.width.equalTo(self.view).offset(-20);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.install_OCView.mas_bottom).offset(5);
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.height.mas_equalTo(130);
        make.width.equalTo(self.view).offset(-20);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(25);
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.bottom.equalTo(self.scrollView).offset(-15); // 注意点
        make.height.mas_equalTo(50);
    }];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark event respose

- (void) submitBtnAction:(UIButton *)sender {
    NSLog(@"提交按钮被点击");
    [self smartMiRepairerFinishWorkInputParams];
    if ([self canSubmit]) {
        [Util showWaitingDialog];
        [self.httpClient smartMi_repairer_finishWork:[self smartMiRepairerFinishWorkInputParams] response:^(NSError *error, HttpResponseData *responseData) {
            [Util dismissWaitingDialog];
            
            if (!error) {
                NSString *promptStr = [Util getErrorDescritpion:responseData otherError:error];
                if (kHttpReturnCodeSuccess == responseData.resultCode) {
                    promptStr = @"提交成功";
                }
                switch (responseData.resultCode) {
                    case kHttpReturnCodeSuccess:
                    case kHttpReturnCodeChangedAssign:
                        [self postNotification:NotificationOrderChanged];
                        [self popViewController];
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
}

- (void) showAlertCancelOrder {
    UIAlertView *alertView = [Util confirmAlertView:nil message:@"请确认是否取消工单？" confirmTitle:@"是" cancelTitle:@"否" confirmAction:^{
        [self cancelOrder];
    }];
    [alertView show];
}

// 取消工单
- (void) cancelOrder {
    // 取消工单
    SmartMiRepairerCancelWorkInputParams *params = [SmartMiRepairerCancelWorkInputParams new];
    params.objectId = self.orderId;
    params.scanHostBarcode = self.install_PCView.scanInBarcode;
    params.scanExternalBarCode = self.install_PCView.scanOutBarcode;
    [Util showWaitingDialog];
    [self.httpClient smartMi_repairer_cancelWork:params response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        if (!error) {
            NSString *promptStr = [Util getErrorDescritpion:responseData otherError:error];
            if (kHttpReturnCodeSuccess == responseData.resultCode) {
                promptStr = @"取消工单成功";
            }
            switch (responseData.resultCode) {
                case kHttpReturnCodeSuccess:
                case kHttpReturnCodeChangedAssign:
                    [self postNotification:NotificationOrderChanged];
                    [self popViewController];
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


// 暂时不做
- (void) specialPerformButtonAction:(UIButton *)sender {
//    SpecialFinishEntry *specialFinish = [SpecialFinishEntry new];
////    [specialFinish gotoSpecialPerformVCByOrderDetails:self.orderDetails orderListVc:self.orderListViewController fromVc:self];
//    [specialFinish gotoSpecialPerformVCByOrderId:self.orderId orderListVc:self fromVc:self];
}

#pragma mark
#pragma mark Common_SignInViewDelegate

- (SmartMiRepairSignInInputParams *) common_SignInView:(Common_SignInView *)view needSupplementParam:(SmartMiRepairSignInInputParams *)param {
    param.objectId = self.orderId;
    param.repairManId = [self.user.userId description];
    return param;
}

#pragma mark
#pragma mark Common_UserInfoViewDelegate

- (void) common_UserInfoView:(Common_UserInfoView *)view didSelectedChooseAreaBtn:(UIButton *)btn {
    NSLog(@"用户信息_选择区域按钮被点击");
    [self requestStreetInfos];
}

#pragma mark
#pragma mark WZSingleCheckViewControllerDelegate

- (void) singleCheckViewController:(WZSingleCheckViewController*)viewController didChecked:(CheckItemModel*)checkedItem {
    // 存储当前选择值
    _clientStreet = [CheckItemModel modelWithValue:checkedItem.value forKey:checkedItem.key];
    
//    NSString *streetAddr = [self.orderDetail.customerFullCountyAddress appendStr:[Util defaultStr:@"" ifStrEmpty:checkedItem.value]];
//    _street = streetAddr;
    _street = _clientStreet.value;
    self.common_UIView.address = [self addressByStreet:_street];
    [viewController popViewController];
}


#pragma mark
#pragma mark Install_ProductConfirmationViewDelegate（产品确认）
// 外机条码扫描按钮被点击
- (void) install_ProductConfirmationView:(Install_ProductConfirmationView *)view didSelectedTopBtn:(UIButton *)btn {
    NSLog(@"产品确认_外机条码扫描按钮被点击");
    [ScanGraphicCodeViewController fastScanWithComplete:^(NSString *codeText) {
        if ([[codeText copy] length] <= 30) {
            self.install_PCView.scanOutBarcode = [codeText copy];
        }
        else {
            [Util showAlertView:nil message:@"条码字符不能超过 30 位"];
            self.install_PCView.scanOutBarcode = nil;
        }

        
        
        if (self.install_PCView.scanInBarcode.length != 0) {
            if ((![self.install_PCView.scanOutBarcode isEqual:self.orderDetail.externalBarCode]) ||
                (![self.install_PCView.scanInBarcode isEqual:self.orderDetail.hostBarcode])) {
                self.hiddenCancelOrderBtn = NO;
            }
            else {
                self.hiddenCancelOrderBtn = YES;
            }
        }
    } fromViewController:self];
}

// 内机条码扫描按钮被点击
- (void) install_ProductConfirmationView:(Install_ProductConfirmationView *)view didSelectedBottomBtn:(UIButton *)btn {
    NSLog(@"产品确认_内机条码扫描按钮被点击");
    [ScanGraphicCodeViewController fastScanWithComplete:^(NSString *codeText) {
        
        if ([[codeText copy] length] <= 30) {
            self.install_PCView.scanInBarcode = [codeText copy];
        }
        else {
            [Util showAlertView:nil message:@"条码字符串不能超过 30 位"];
            self.install_PCView.scanInBarcode = nil;
        }
        
        
        if (self.install_PCView.scanOutBarcode.length != 0) {
            if ((![self.install_PCView.scanOutBarcode isEqual:self.orderDetail.externalBarCode]) ||
                (![self.install_PCView.scanInBarcode isEqual:self.orderDetail.hostBarcode])) {
                self.hiddenCancelOrderBtn = NO;
            }
            else {
                self.hiddenCancelOrderBtn = YES;
            }
        }
    } fromViewController:self];
}

// 品类按钮被点击
- (void) install_ProductConfirmationView:(Install_ProductConfirmationView *)view didSelectedMoreBtn:(UIButton *)btn {
    NSLog(@"产品确认_整体(品类)_更多选择按钮被点击");
    NSArray<CheckItemModel *> *categorys = [self getCategoryMainData];
    
    __block NSInteger index = 999;
    [categorys enumerateObjectsUsingBlock:^(CheckItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.key isEqual:self.orderDetail.category]) {
            index = idx;
        }
    }];
    WZSingleCheckListPopView *checkView =
    [[WZSingleCheckListPopView alloc]initWithCheckItems:categorys title:@"品类" checkIndex:index checkedAction:^(NSInteger checkIndex) {
        self.orderDetail.category = [categorys objectAtIndex:checkIndex].key;
        self.orderDetail.categoryVal = [categorys objectAtIndex:checkIndex].value;
        self.install_PCView.category = self.orderDetail.categoryVal;
    }];
    [checkView show];
}

// 机型查询按钮被点击
- (void) install_ProductConfirmationView:(Install_ProductConfirmationView *)view didSelectedQueryBtn:(UIButton *)btn {
    NSLog(@"产品确认_机型查询按钮被点击");
    // 模糊查询
    SmartMiProductModelSearchViewController *modelSearchVc = [[SmartMiProductModelSearchViewController alloc]init];
    modelSearchVc.brand = _orderDetail.brand;
    modelSearchVc.modelSelectedBlock = ^(ViewController* viewController, ProductModelDes *model){
        [self handlefindMachineModelResult:model];
        [viewController popViewController];
    };
    [self pushViewController:modelSearchVc];
}


- (void) handlefindMachineModelResult:(ProductModelDes*)productModel {
    self.install_PCView.queryResult = productModel.product_id;
    SmartMiRepairerQueryAircraftBrandInputParams *params = [SmartMiRepairerQueryAircraftBrandInputParams new];
    params.model = productModel.product_id;
    params.flag = @"1";
    [self.httpClient smartMi_repairer_queryAircraftBrand:params response:^(NSError *error, HttpResponseData *responseData) {
        if (!error) {
            NSString *promptStr = [Util getErrorDescritpion:responseData otherError:error];
            if (kHttpReturnCodeSuccess == responseData.resultCode) {
                promptStr = @"根据机型查询品牌成功";
            }
            NSDictionary *dic = responseData.resultData;
            self.install_PCView.category = [self.configInfoMgr getConfigItemValueByType:MainConfigInfoTableType3 code:dic[@"category"]];
           
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}


#pragma mark
#pragma mark Install_OrderContentViewDelegate

- (void) tableViewCell:(UITableViewCell *)cell didSelectedHandleIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"处理措施栏被点击");
    NSArray<CheckItemModel *> *handles = [self getHandleMainData];
    
    WZSingleCheckListPopView *checkView =
    [[WZSingleCheckListPopView alloc]initWithCheckItems:handles title:@"处理措施" checkIndex:999 checkedAction:^(NSInteger checkIndex) {
        cell.detailTextLabel.text = [handles objectAtIndex:checkIndex].value;
        self.orderDetail.faultHandling = [handles objectAtIndex:checkIndex].key;
    }];
    [checkView show];
}


#pragma mark
#pragma mark private methods
- (void)setOrUpdateNavLeftButton{
    UIButton *leftBtn = [[UIButton alloc]init];

    [leftBtn setImage:ImageNamed(@"go_back_white") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(navBarLeftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn clearBackgroundColor];
    leftBtn.titleLabel.font = SystemFont(14);
    [leftBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [leftBtn setTitle:self.orderId forState:UIControlStateNormal];
    [leftBtn sizeToFit];
    
    [self setNavBarLeftView:leftBtn];
}

// 请求工单详情
- (void) requestOrderDetail {
    [Util showWaitingDialog];
    SmartMiGetOrderDetailsInputParams *params = [SmartMiGetOrderDetailsInputParams new];
    params.objectId = self.orderId;
    [self.httpClient smartMi_getOrderDetails:params response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        // 获取工单详情，初步填充执行工单
        self.orderDetail = [[SmartMiOrderContentDetails alloc]initWithDictionary:responseData.resultData];
    }];
}

// 请求街道信息
- (void) requestStreetInfos {
    if ([_streets count] > 0) {
        [MiscHelper pushToCheckListViewController:@"选择乡、镇或街道" checkItems:_streets checkedItem:_clientStreet from:self delegate:self];
    }
    else {
        StreetListInputParams *input = [StreetListInputParams new];
        input.regiontxt = self.orderDetail.province;
        input.city1 = self.orderDetail.city;
        input.city2 = self.orderDetail.county;
        input.street = self.orderDetail.street;
        
        [Util showWaitingDialog];
        [self.httpClient getStreetInfos:input response:^(NSError *error, HttpResponseData *responseData) {
            [Util dismissWaitingDialog];
            
            if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
                _streets = [MiscHelper parserStreetItems:responseData.resultData];
                [MiscHelper pushToCheckListViewController:@"选择乡、镇或街道" checkItems:_streets checkedItem:_clientStreet from:self delegate:self];
            }else {
                [Util showErrorToastIfError:responseData otherError:error];
            }
        }];
    }
}

// 获取品类主数据
- (NSArray<CheckItemModel *> *) getCategoryMainData {
    
    NSMutableArray *arrM = [NSMutableArray new];
    if ([_checkItems_category count] != 0) {
        return _checkItems_category;
    }
    // 所有品类集合
    NSArray *tempItems = [self.configInfoMgr subProductsOfProduct:self.orderDetail.productType];
    tempItems = [Util convertConfigItemInfoArrayToCheckItemModelArray:tempItems];
    if (tempItems.count > 0) {
//        CheckItemModel *noneItem = [CheckItemModel modelWithValue:@"请选择" forKey:@""];
//        [arrM addObject:noneItem];
        [arrM addObjectsFromArray:tempItems];
        
    }
    _checkItems_category = [arrM copy];
    return [arrM copy];
}

// 获取常规处理措施主数据
- (NSArray<CheckItemModel *> *) getHandleMainData {
    NSMutableArray *arrM = [NSMutableArray new];
    if ([_checkItems_handle count] != 0) {
        return _checkItems_handle;
    }
    
    // 所有常规处理措施主集合
//    NSArray *tempItems = [self.configInfoMgr normalSolutionsOfProduct:self.orderDetail.productType isNew:NO];
    // 安装处理措施
    NSArray *tempItems = [self.configInfoMgr newMachineSolutionsOfProduct:self.orderDetail.productType];
    tempItems = [Util convertConfigItemInfoArrayToCheckItemModelArray:tempItems];
    if (tempItems.count > 0) {
//        CheckItemModel *noneItem = [CheckItemModel modelWithValue:@"请选择" forKey:@""];
//        [arrM addObject:noneItem];
        [arrM addObjectsFromArray:tempItems];
        
    }
    _checkItems_handle = [arrM copy];
    return [arrM copy];
}

// 完工接口参数
- (SmartMiRepairerFinishWorkInputParams *) smartMiRepairerFinishWorkInputParams {
    
    SmartMiRepairerFinishWorkInputParams *params = [SmartMiRepairerFinishWorkInputParams new];
    params.objectId = self.orderId;
    params.repairManId = self.orderDetail.workerId;
    params.brand = self.orderDetail.brand;
    params.productType = self.orderDetail.productType; // 产品大类
    params.category = self.install_PCView.category; // 品类
    params.model = self.install_PCView.queryResult; // 机型 "model": "LS600200000811"
    params.scanHostBarcode = self.install_PCView.scanInBarcode;
    params.scanExternalBarCode = self.install_PCView.scanOutBarcode; // 手机APP扫描的外机条码
    params.name = self.common_UIView.userName; // 客户姓名
    params.street = _street; // 街道（可选）
    params.detailAddr = self.common_UIView.detailAddress; // 详细地址
    params.phoneNum2 = self.common_UIView.phoneNums; // 客户电话号码
    params.outdoorTemp = self.install_OCView.outTemp; // 室外环境温度
    params.intoTemp = self.install_OCView.inWindTemp; // 室内进风温度
    params.outoTemp = self.install_OCView.outWindTemp; // 室内出风温度
    params.runPressure = self.install_OCView.runPressure;// 运行压力
    params.area = self.install_OCView.useArea; // 使用面积
    params.faultHandling = self.orderDetail.faultHandling;// 处理措施
    params.memo =  self.textView.text; // 完工备注（可选）
    
    return params;
}

// 是否可以提交
- (BOOL) canSubmit {
    
    // 上门签到
    ReturnNOIf(self.common_SIView.needSignIn , @"请先上门签到")

    // 产品确认
    ReturnNOIf(self.orderDetail.productType.length == 0 , @"请先确定产品大类")
    ReturnNOIf(self.install_PCView.queryResult.length == 0 , @"请先确定机型")
    ReturnNOIf(self.install_PCView.category.length == 0 , @"请先确定品类")
    ReturnNOIf(self.install_PCView.scanInBarcode.length == 0 , @"请先确定内机条码")
    ReturnNOIf(self.install_PCView.scanOutBarcode.length == 0 , @"请先确定外机条码")
    
    // 用户信息
    ReturnNOIf(self.common_UIView.userName.length == 0 , @"请先确定客户姓名")
    ReturnNOIf(self.common_UIView.detailAddress.length == 0 , @"请先确定客户详细地址")
//    ReturnNOIf(self.common_UIView.phoneNums.length == 0 , @"请先确定客户电话")
    
    // 工单内容
    ReturnNOIf(self.install_OCView.outTemp.length == 0 , @"请先确定室外环境温度")
    ReturnNOIf(self.install_OCView.outWindTemp.length == 0 , @"请先确定外机出风温度")
    ReturnNOIf(self.install_OCView.inWindTemp.length == 0 , @"请先确定内机出风温度")
    ReturnNOIf(self.install_OCView.runPressure.length == 0 , @"请先确定运行压力")
    ReturnNOIf(self.install_OCView.useArea.length == 0 , @"请先确定使用面积")
    ReturnNOIf(self.install_OCView.inMachinePic.length == 0 , @"请先确定内机照片")
    ReturnNOIf(self.install_OCView.userAppPic.length == 0 , @"请先确定用户app照片")
    ReturnNOIf(self.orderDetail.faultHandling.length == 0 , @"请先确定处理措施")
    
    return YES;
}

- (NSString *) addressByStreet:(NSString *)street {
    NSString *address;
    if (_orderDetail) {
        address = _orderDetail.province;
        address = [address appendStr:_orderDetail.city];
        address = [address appendStr:_orderDetail.county];
        address = [address appendStr:_orderDetail.town];
        address = [address appendStr:street];
    }
    return address;
}




#pragma mark
#pragma mark setters and getters
- (UIScrollView *) scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
                _scrollView.backgroundColor = [UIColor colorWithRed:241./255 green:241./255 blue:241./255 alpha:1];
        _scrollView.scrollEnabled = YES;
        [_scrollView addSubview:self.common_SIView];
        [_scrollView addSubview:self.common_UIView];
        [_scrollView addSubview:self.install_PCView];
        [_scrollView addSubview:self.install_OCView];
        [_scrollView addSubview:self.textView];
        [_scrollView addSubview:self.submitBtn];
    }
    return _scrollView;
}

- (Common_SignInView *) common_SIView {
    if (_common_SIView == nil) {
        _common_SIView = [[[NSBundle mainBundle] loadNibNamed:@"Common_SignInView" owner:nil options:nil] lastObject];
        _common_SIView.delegate = self;
        _common_SIView.backgroundColor = [UIColor clearColor];
    }
    return _common_SIView;
}

- (Common_UserInfoView *) common_UIView {
    if (_common_UIView == nil) {
        _common_UIView = [[[NSBundle mainBundle] loadNibNamed:@"Common_UserInfoView" owner:nil options:nil] lastObject];
        _common_UIView.delegate = self;
        _common_UIView.backgroundColor = [UIColor clearColor];
    }
    return _common_UIView;
}

- (Install_ProductConfirmationView *) install_PCView {
    if (_install_PCView == nil) {
        _install_PCView = [[[NSBundle mainBundle] loadNibNamed:@"Install_ProductConfirmationView" owner:nil options:nil] lastObject];
        _install_PCView.delegate = self;
        _install_PCView.backgroundColor = [UIColor clearColor];
    }
    return _install_PCView;
}

- (Install_OrderContentView *) install_OCView {
    if (_install_OCView == nil) {
        _install_OCView = [[[NSBundle mainBundle] loadNibNamed:@"Install_OrderContentView" owner:nil options:nil] lastObject];
        _install_OCView.delegate = self;
        _install_OCView.backgroundColor = [UIColor clearColor];
        _install_OCView.vc = self;
        _install_OCView.orderId = self.orderId;
    }
    return _install_OCView;
}

- (WZTextView *) textView {
    if (nil == _textView) {
        _textView = [[WZTextView alloc]initWithFrame:CGRectZero maxWords:200];
        _textView.placeholder = @"请填写完工备注（选填）";
    }
    return _textView;
}

- (UIButton *) submitBtn {
    if (_submitBtn == nil) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn setBackgroundColor:[UIColor colorWithRed:251./255 green:71./255 blue:65./255 alpha:1] forState:UIControlStateNormal];
        [_submitBtn.layer setCornerRadius:3];
        [_submitBtn setTintColor:[UIColor whiteColor]];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    return _submitBtn;
}

- (void) setOrderDetail:(SmartMiOrderContentDetails *)orderDetail {
    if (orderDetail && ![orderDetail isEqual:_orderDetail]) {
        _orderDetail = orderDetail;
        
        self.common_UIView.userName = _orderDetail.name;
        _street = _orderDetail.street;
        self.common_UIView.address = [self addressByStreet:_street];
        self.common_UIView.detailAddress = _orderDetail.detailAddr;
        self.common_UIView.refPhoneNums = _orderDetail.phoneNum;
        self.common_UIView.phoneNums = _orderDetail.PhoneNum2;
        
        self.install_PCView.outBarcode = _orderDetail.externalBarCode;
        self.install_PCView.inBarcode = _orderDetail.hostBarcode;
        self.install_PCView.category = _orderDetail.categoryVal;
        self.install_PCView.queryResult = _orderDetail.modelVal;
        
        self.install_OCView.runPressure = _orderDetail.runPressure;
        self.install_OCView.useArea = _orderDetail.area;
        self.install_OCView.outTemp = _orderDetail.outdoorTemp;
        self.install_OCView.outWindTemp = _orderDetail.outoTemp;
        self.install_OCView.inWindTemp = _orderDetail.intoTemp;
        self.install_OCView.inMachinePic = _orderDetail.inMachinePic;
        self.install_OCView.userAppPic = _orderDetail.userAppPic;
        self.install_OCView.outMachinePic = _orderDetail.outMachinePic;
        self.install_OCView.userMachinePic = _orderDetail.userMachinePic;
    }
}

- (void) setHiddenCancelOrderBtn:(BOOL)hiddenCancelOrderBtn {
    _hiddenCancelOrderBtn = hiddenCancelOrderBtn;
    if (_hiddenCancelOrderBtn) {
        self.navigationItem.rightBarButtonItems = nil;
    }
    else {
        [self setNavBarRightButton:@"取消工单" clicked:@selector(showAlertCancelOrder)];
    }
}

@end
