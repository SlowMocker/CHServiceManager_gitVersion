//
//  MiscHelper.m
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-4-28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "MiscHelper.h"
#import "ConfigInfoManager.h"
#import "WZCheckMenuView.h"
#import "ViewController.h"
#import "PleaseSelectViewCell.h"
#import "WZSingleCheckViewController.h"

#import "OrderListViewController.h"
#import "ExtendServiceListViewController.h"
#import "HistoryOrderListViewController.h"

@interface MiscHelper()
@end

@implementation MiscHelper

+ (instancetype)sharedInstance
{
    static MiscHelper *sMiscHelper = nil;
    static dispatch_once_t sOnceToken;
    dispatch_once(&sOnceToken, ^{
        sMiscHelper = [[MiscHelper alloc]init];
    });
    return sMiscHelper;
}

+ (UIButton *)makeImageTextButton:(ImageTextButtonData*)buttonData
{
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = kColorWhite;

    [btn setTag:buttonData.buttonIndex];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, ScreenWidth - 80)];

    [btn setTitleColor:kColorDarkGray forState:UIControlStateNormal];
    [btn setTitleColor:kColorDefaultOrange forState:UIControlStateHighlighted];
    [btn setTitleColor:kColorDefaultOrange forState:UIControlStateSelected];

    [btn setImage:ImageNamed(buttonData.norImageName) forState:UIControlStateNormal];
    [btn setImage:ImageNamed(buttonData.selImageName) forState:UIControlStateHighlighted];
    [btn setImage:ImageNamed(buttonData.selImageName) forState:UIControlStateSelected];

    [btn setTitleForAllStatus:buttonData.title];

    [btn addTarget:buttonData.actionTarget action:buttonData.action forControlEvents:UIControlEventTouchUpInside];

    [btn addBottomLine:kColorWhite];
    
    return btn;
}

+ (UITableViewCell*)makeCommonSelectCell:(NSString*)title
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setFont:SystemFont(14)];
    [cell.detailTextLabel setFont:SystemFont(14)];
    [cell.textLabel setText:title];
    [cell.detailTextLabel setText:@"请选择"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

+ (TextFieldTableViewCell*)makeTextFieldCell:(NSString*)placeHolder
{
    TextFieldTableViewCell *editCell = [[TextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    editCell.textField.placeholder = placeHolder;
    editCell.textField.adjustsFontSizeToFitWidth = YES;
    editCell.textField.textColor = kColorDefaultBlue;
    [editCell addLineTo:kFrameLocationBottom];
    
    return editCell;
}

+ (PleaseSelectViewCell*)makePleaseSelectCell:(NSString*)title
{
    PleaseSelectViewCell *cell = [[PleaseSelectViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setFont:SystemFont(14)];
    [cell.detailTextLabel setFont:SystemFont(14)];
    [cell.textLabel setText:title];
    [cell.detailTextLabel setText:@"请选择"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

+ (TextFieldTableViewCell*)makeLeftEditRightBarCodeBtnCell:(id)target  action:(SEL)barCodeBtnClickAction
{
    TextFieldTableViewCell *barCodeCell = [[TextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    UIButton *barCodeButton = [UIButton imageButtonWithNorImg:@"dealer_erweima" selImg:@"dealer_erweima" size:CGSizeMake(26, 26) target:target action:barCodeBtnClickAction];
    [barCodeButton addLineTo:kFrameLocationLeft];

    barCodeCell.accessoryView = barCodeButton;
    barCodeCell.textField.placeholder = @"请扫描或输入机号";

    return barCodeCell;
}

+ (PleaseSelectViewCell*)makeSelectItemCell:(NSString*)title checkItems:(NSArray*)checkItems checkedItem:(CheckItemModel*)checkedItem
{
    PleaseSelectViewCell *selectCell = [MiscHelper makePleaseSelectCell:title];
    [selectCell addLineTo:kFrameLocationBottom];

    UIButton *iconButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [iconButton setImage:ImageNamed(@"dropdown_hit") forState:UIControlStateNormal];
    selectCell.accessoryView = iconButton;
    selectCell.tag = kCellTypeSingleCheck;
    selectCell.checkItems = checkItems;
    selectCell.checkViewTitle = title;
    selectCell.checkedItem = checkedItem;

    return selectCell;
}

+ (UITableViewCell*)makeRightSwitchViewCell:(id)target action:(SEL)action
{
    //right switch
    UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 40, 24)];
    switchView.onTintColor = kColorDefaultOrange;
    [switchView addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryView = switchView;
    
    return cell;
}

+ (UIView*)makeTableViewSectionHeaderLabel:(CGFloat)height text:(NSString*)labelText
{
    ReturnIf([Util isEmptyString:labelText])nil;

    height = MAX(28, height);

    CGRect frame = CGRectMake(0, 0, ScreenWidth, height);
    UIView *headerView = [[UIView alloc]initWithFrame:frame];
    [headerView clearBackgroundColor];

    frame.origin.x = kTableViewLeftPadding;
    frame.size.height = MIN(28, height);
    frame.origin.y = CGRectGetHeight(headerView.frame) - frame.size.height;
    frame.size.width -= frame.origin.x;
    UILabel *headerLabelView = [[UILabel alloc]initWithFrame:frame];
    [headerLabelView clearBackgroundColor];
    headerLabelView.textColor = kColorBlack;
    headerLabelView.text = labelText;
    headerLabelView.font = SystemFont(15);
    [headerView addSubview:headerLabelView];

    return headerView;
}

+ (UITableViewCell*)makeCellWithLeftIcon:(NSString*)iconName leftTitle:(NSString*)title rightText:(NSString*)rightText
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.textColor = kColorDarkGray;
    cell.textLabel.font = SystemFont(15);
    cell.textLabel.text = title;

    cell.detailTextLabel.textColor = kColorDefaultOrange;
    cell.detailTextLabel.font = SystemFont(13);
    cell.detailTextLabel.text = rightText;

    cell.imageView.image = ImageNamed(iconName);

    return cell;
}

+ (NSMutableArray*)parserObjectList:(id)resultData objectClass:(NSString*)entityClassName
{
    ReturnIf((!resultData) || (![resultData isKindOfClass:[NSArray class]])||!entityClassName) nil;
    NSArray *array = (NSArray*)resultData;
    
    NSMutableArray *objectArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in array) {
        NSObject *entity =[[NSClassFromString(entityClassName) alloc]initWithDictionary:dic];
        [objectArray addObject:entity];
    }
    return objectArray;
}

+ (NSMutableArray*)parserStreetItems:(id)resultData{
    ReturnIf((!resultData) || (![resultData isKindOfClass:[NSArray class]])) nil;
    NSArray *array = (NSArray*)resultData;

    NSMutableArray *objectArray = [[NSMutableArray alloc]init];

    for (NSDictionary *dic in array) {
        CheckItemModel *model = [CheckItemModel new];
        if ([dic containsKey:@"street"]) { //format 1
            model.key = [dic objForKey:@"street"];
            model.value = model.key;
        }else { //format 2
            model.key = [dic objForKey:@"code"];
            model.value = [dic objForKey:@"val"];
        }
        [objectArray addObject:model];
    }
    return objectArray;
}

+ (NSMutableArray*)parserOrderList:(id)resultData
{
    ReturnIf((!resultData) || (![resultData isKindOfClass:[NSArray class]])) nil;
    NSArray *array = (NSArray*)resultData;

    NSMutableArray *objectArray = [[NSMutableArray alloc]init];

    for (NSDictionary *dic in array) {
        OrderContentModel *model =[[OrderContentModel alloc]initWithDictionary:dic];
        [objectArray addObject:model];
    }
    return objectArray;
}

+ (NSMutableArray*)parserOrderList:(id)resultData filter:(NSInteger)groupStatus
{
    ReturnIf((!resultData) || (![resultData isKindOfClass:[NSArray class]])) nil;
    NSArray *array = (NSArray*)resultData;
    
    NSMutableArray *objectArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in array) {
        OrderContentModel *model =[[OrderContentModel alloc]initWithDictionary:dic];
        //filter by group status
        if (NSNotFound == groupStatus || [model isOrderStatus:groupStatus])
        {
            [objectArray addObject:model];
        }
    }
    return objectArray;
}

+(NSArray*)filterOrders:(NSArray*)orders byStatus:(NSInteger)status
{
    NSMutableArray *orderArray = [[NSMutableArray alloc]init];
    for (OrderContentModel *order in orders) {
        if ([order isOrderStatus:status]) {
            [orderArray addObject:order];
        }
    }
    return orderArray;
}

+ (NSMutableArray*)letv_parserOrderList:(id)resultData filter:(NSInteger)groupStatus
{
    ReturnIf((!resultData) || (![resultData isKindOfClass:[NSArray class]])) nil;
    NSArray *array = (NSArray*)resultData;
    
    NSMutableArray *objectArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in array) {
        LetvOrderContentModel *model =[[LetvOrderContentModel alloc]initWithDictionary:dic];
        //filter by group status
        if (NSNotFound == groupStatus || [model isOrderStatus:groupStatus])
        {
            [objectArray addObject:model];
        }
    }
    return objectArray;
}

+(NSArray*)letv_filterOrders:(NSArray*)orders byStatus:(NSInteger)status
{
    NSMutableArray *orderArray = [[NSMutableArray alloc]init];
    for (LetvOrderContentModel *order in orders) {
        if ([order isOrderStatus:status]) {
            [orderArray addObject:order];
        }
    }
    return orderArray;
}

+ (NSMutableArray*)parserExtendOrderList:(id)resultData;
{
    ReturnIf((!resultData) || (![resultData isKindOfClass:[NSArray class]])) nil;
    NSArray *array = (NSArray*)resultData;
    
    NSMutableArray *objectArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in array) {
        ExtendServiceOrderContent *model = [[self class]parserExtendOrderDetails:dic];
        if (model) {
            [objectArray addObject:model];
        }
    }
    return objectArray;
}

+ (OrderContentDetails *)parserOrderContentDetails:(id)resultData
{
    ReturnIf((!resultData) || (![resultData isKindOfClass:[NSDictionary class]])) nil;

    OrderContentDetails *details = [[OrderContentDetails alloc]initWithDictionary:resultData];
    details.tDispatchParts = [[self class]parserObjectList:details.tDispatchParts objectClass:@"PartMaintainContent"];

    details.supportInfo = [[SupporterOrderContent alloc]initWithDictionary:resultData];
    details.supportInfo.status = [resultData objForKey:@"supprotStatus"];
    details.supportInfo.order_type = details.process_type;
    details.supportInfo.objectId = details.object_id;
    details.supportInfo.workerId = details.partner_fwg;
    details.supportInfo.workerName = details.partner_fwgname;
    return details;
}

+ (NSArray*)parserExtendProductContentList:(NSArray*)resultData{
    ReturnIf((!resultData) || (![resultData isKindOfClass:[NSArray class]])) nil;
    NSArray *array = (NSArray*)resultData;
    
    NSMutableArray *objectArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in array) {
        ExtendProductContent *entity =[[ExtendProductContent alloc]initWithDictionary:dic];
        entity.zzfld00002i = [NSString dateStringWithIntervalStr:entity.zzfld00002i.description formatStr:WZDateStringFormat5];

        entity.factoryWarrantyDue = [NSString dateStringWithIntervalStr:entity.factoryWarrantyDue.description formatStr:WZDateStringFormat5];

        entity.extendprdBeginDue = [NSString dateStringWithIntervalStr:entity.extendprdBeginDue.description formatStr:WZDateStringFormat5];

        entity.extendprdEndDue = [NSString dateStringWithIntervalStr:entity.extendprdEndDue.description formatStr:WZDateStringFormat5];
        
        entity.buyprice = [NSString stringWithFormat:@"%@", entity.buyprice];

        [objectArray addObject:entity];
    }
    return objectArray;
}

+ (ExtendServiceOrderContent*)parserExtendOrderDetails:(id)resultData
{
    ReturnIf((!resultData) || (![resultData isKindOfClass:[NSDictionary class]])) nil;
    ExtendServiceOrderContent *extendOrder =[[ExtendServiceOrderContent alloc]initWithDictionary:resultData];
    extendOrder.productInfoList = [[self class]parserExtendProductContentList:extendOrder.productInfoList];
    extendOrder.customerInfo = [[ExtendCustomerInfo alloc]initWithDictionary:(NSDictionary*)extendOrder.customerInfo];
    return extendOrder;
}

+(NSString *)getOrderProccessStatusStrById:(NSString*)processId repairerHandle:(NSString*)repairerHandle
{
    if ([processId isEqualToString:@"SR01"]) {
        if ([repairerHandle isEqualToString:@"1"]) {
            return @"已接受";
        }else if ([repairerHandle isEqualToString:@"2"]){
            return @"已拒绝";
        }
    }
    return [[self class]getOrderProccessStatusStrById:processId];
}

+ (NSString *)getOrderProccessStatusStrById:(NSString*)processId
{
    NSDictionary *statusDic = @{
        @"SR01":@"已派至维修工",
        @"SR20":@"已派至服务商",
        @"SR30":@"服务商已接受",
        @"SR40":@"预约未成功",
        @"SR41":@"已预约",
        @"SR45":@"服务未完工",
        @"SR46":@"二次预约",
        @"SR50":@"服务完工",
        @"SR99":@"工单取消"
    };
    if ([statusDic containsKey:processId]) {
        return [statusDic objForKey:processId];
    }else {
        return processId;
    }
}

+ (NSString *)getOrderHandleTypeStrById:(NSString*)handleId
{
    NSDictionary *statusDic = @{
        @"ZR01":@"上门维修",
        @"ZRA1":@"新机安装",
        @"ZR03":@"服务改善",
        @"ZR02":@"拉修服务",
        @"ZR05":@"客户送修",
        @"ZMS1":@"上门式售中机",
        @"ZMS2":@"集中式售中机"
    };
    
    if ([statusDic containsKey:handleId]) {
        return [statusDic objForKey:handleId];
    }else {
        return handleId;
    }
}

+ (NSString*)isValidPasswordStr:(NSString*)password
{
    NSString *errStr;
    if ([Util isEmptyString:password]) {
        errStr = @"密码不能为空";
    }
    return errStr;
}

+ (BOOL)isValidReceiptNumber:(NSString*)receiptNumber
{
    ReturnIf([Util isEmptyString:receiptNumber] || receiptNumber.length > 10)NO;
    NSString *regex = @"^[a-zA-Z0-9]{1,10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:receiptNumber];
}

+ (WZSingleCheckViewController*)pushToCheckListViewController:(NSString
                                                             *)title
                                                   checkItems:(NSArray*)checkItems
                                                  checkedItem:(CheckItemModel*)checked
                                                       from:(UIViewController*)viewController
                                                   delegate:(id<WZSingleCheckViewControllerDelegate>)delegate
{
    WZSingleCheckViewController *checkVc = [[WZSingleCheckViewController alloc]init];
    checkVc.title = [Util defaultStr:@"选择" ifStrEmpty:title];
    checkVc.delegate = delegate;
    checkVc.checkItemArray = checkItems;
    checkVc.checkedItem = checked;
    [viewController pushViewController:checkVc];
    
    return checkVc;
}

+ (CGFloat)cacheFolderSize
{
    return [Util folderSizeAtPath:[NSString cachePath]];
}

+ (void)cleanCacheFolderWithComplete:(VoidBlock)completeCallBack
{
    BACK(^(){
        NSString *cachePath = [NSString cachePath];
        NSArray *cacheFiles = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
        for (NSString *file in cacheFiles) {
            NSError *error;
            NSString *path = [cachePath stringByAppendingPathComponent:file];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        MAIN(^(){
            completeCallBack();
        });
    });
}

+ (void)locateCurrentAddressWithComplete:(LocationCallBack)responseCallBack
{
    [[LocationManager sharedInstance]startLocationWithResponse:responseCallBack];
}

+ (NSString *)isValidChangHongAirConditionCode:(NSString*)barCode
{
    NSString *invalidInfo;
    
    do {
        if ([Util isEmptyString:barCode]) {
            invalidInfo = @"机器条码不能为空";
            break;
        }
        // 1.空调类产品机号只有16位和24位
        if (!(barCode.length == 16 || barCode.length == 24)) {
            invalidInfo = @"机器条码位数不对";
            break;
        }
        
        // 2.空调类产品不能出现8个相同连续字符
        if ([[self class] contain8orMoreSameCharactors:barCode]){
            invalidInfo = @"机器条码不能有8个连续的字符相同";
            break;
        }
        
        // 3.KYD开头的机号不做校验
        if (![barCode hasPrefix:@"KYD"]) {
            // 4.空调产品24位机号第二位产品线校验为：3
            if (barCode.length == 24
                && [barCode characterAtIndex:1] != '3') {
                invalidInfo = @"机器条码格式不正确";
                break;
            }
        }
    } while (0);
    return invalidInfo;
}

+(kProductType)getProductTypeByBrand:(NSString*)brandId product:(NSString*)productId categroy:(NSString*)categroyId{
    if ([productId isEqualToString:@"KT0010"]) {  //空调
        if ([brandId isEqualToString:@"CH"]) {
            return kProductTypeChangHongAirConditioning;
        }else if([brandId isEqualToString:@"CHIQ"]){
            return kProductTypeChiqAirConditioning;
        }else if ([brandId isEqualToString:@"XZYY"]){
            return kProductTypeYingYanAirConditioning;
        }
    }else if ([productId isEqualToString:@"TV0010"]){ //电视
        if ([brandId isEqualToString:@"CH"]) {
            return kProductTypeChangHongTV;
        }else if([brandId isEqualToString:@"CHIQ"]){
            return kProductTypeChiqTV;
        }else if ([brandId isEqualToString:@"SY"]){
            return kProductTypeSanYoTV;
        }
    }
    return kProductTypeOther;
}

+ (NSString*)machineCode:(NSString*)machineCode isMatchBrand:(NSString*)brandId product:(NSString*)productId categroy:(NSString*)categroyId{
    ReturnIf([Util isEmptyString:machineCode])@"机号不能为空";

    kProductType productType = [MiscHelper getProductTypeByBrand:brandId product:productId categroy:categroyId];

    switch (productType) {
        case kProductTypeChangHongTV: //长虹电视
        case kProductTypeChiqTV: //长虹启客电视
            return [[self class]isValidChangHongTelevitionCode:machineCode machineModel:categroyId];
        case kProductTypeChangHongAirConditioning: //长虹空调
        case kProductTypeChiqAirConditioning: //长虹启客空调
            return [[self class]isValidChangHongAirConditionCode:machineCode];
        case kProductTypeSanYoTV: //三洋电视
            return [[self class]isValidSanYoTelevitionCode:machineCode];
        case kProductTypeYingYanAirConditioning: //迎燕空调
            return [[self class]isValidYingYanAirConditionCode:machineCode];
        case kProductTypeOther: //其它
            break;
        default:
            break;
    }
    return nil;
}

+ (BOOL)isValidExtendOrderContractNo:(NSString*)extendOrderContractNo
{
    NSString *regex = @"^K[0-9]{11}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:[extendOrderContractNo uppercaseString]];
}

+ (BOOL)isValidMutiExtendOrderContractNo:(NSString*)extendOrderContractNo
{
    NSString *regex = @"^KAL[0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:[extendOrderContractNo uppercaseString]];
}

+(NSString*)isValidChangHongTelevitionCode:(NSString*)barCode machineModel:(NSString*)machineModel
{
    NSString *invalidInfo;
    NSUInteger barCodeLength = barCode.length;
    do {
        if ([Util isEmptyString:barCode]) {
            invalidInfo = @"主机条码不能为空";
            break;
        }

        // 1.彩电产品机号位数只能为：10、17、24、26
        if (10 != barCodeLength && 17 != barCodeLength
            && 24 != barCodeLength && 26 != barCodeLength) {
            invalidInfo = @"机号位数不对";
            break;
        }
        
        // 2.彩电不能有8个连续的字符相同
        if ([[self class] contain8orMoreSameCharactors:barCode]) {
            invalidInfo = @"机号不能有8个连续的字符相同";
            break;
        }
        
        // 3.K1W开头的机号无法验证，只做位数校验，必须是24位
        if ([barCode hasPrefix:@"K1W"]) {
            if (24 != barCodeLength) {
                invalidInfo = @"机号位数不正确";
                break;
            }
        }
        
        // 4.彩电24位机号中“99、k1w、d1q, J9”开头机号不做产品线校验，10位、17位机号不做产品线校验
        if (24 == barCodeLength) {
            if (![barCode hasPrefix:@"99"]
                && ![barCode hasPrefix:@"K1W"]
                && ![barCode hasPrefix:@"D1Q"]
                && ![barCode hasPrefix:@"J9"]) {
                if ([machineModel isEqualToString:@"TV20"]) {// CRT彩电
                    if ('1' != [barCode characterAtIndex:1]) {
                        invalidInfo = @"机号填写不正确（与所选品类不符）";
                        break;
                    }
                }else if ([machineModel isEqualToString:@"TV10"]
                          ||[machineModel isEqualToString:@"TV30"]){// 液晶产品/智能液晶
                    if ('7' != [barCode characterAtIndex:1]) {
                        invalidInfo = @"机号填写不正确（与所选品类不符）";
                        break;
                    }
                }else if ([machineModel isEqualToString:@"TV15"]
                          ||[machineModel isEqualToString:@"TV35"]){// 等离子产品/智能等离子
                    if ('9' != [barCode characterAtIndex:1]) {
                        invalidInfo = @"机号填写不正确（与所选品类不符）";
                        break;
                    }
                }else if ([machineModel isEqualToString:@"TV10"]){// 投影仪（前投影）
                    if ('8' != [barCode characterAtIndex:1]) {
                        invalidInfo = @"机号填写不正确（与所选品类不符）";
                        break;
                    }
                }
            }
        }
    } while (NO);
    
    return invalidInfo;
}

+ (NSString*)isValidSanYoTelevitionCode:(NSString*)machineCode{
    //暂无需机号格式检测
    return nil;
}

+ (NSString*)isValidYingYanAirConditionCode:(NSString*)machineCode{
    //暂无需机号格式检测
    return nil;
}

// 判断机号是否有8个连续相同
+ (BOOL)contain8orMoreSameCharactors:(NSString*)barCode
{
    return [[self class]rangeString:barCode repeatCount:8];
}

+ (BOOL)rangeString:(NSString *)string repeatCount:(NSInteger)Num
{
    if (1 == Num && 0 < string.length) {
        return YES;
    }else if (0 >= string.length){
        return NO;
    }
    NSString *lastStr = @"";
    NSInteger count = 1;
    for (int i = 0; i < string.length; i++) {
        NSString *newStr = [string substringWithRange:NSMakeRange(i, 1)];
        if ([lastStr isEqualToString:newStr]) {
            count ++;
            if (Num == count) {
                return YES;
            }
        }else{
            count = 1;
        }
        lastStr = newStr;
    }
    return NO;
}

+ (NSString*)productBrandCodeByName:(NSString*)brandName
{
    return [[ConfigInfoManager sharedInstance]getConfigItemCodeByType:MainConfigInfoTableType1 value:brandName];
}

+ (NSString*)productTypeCodeByName:(NSString*)productTypeName
{
    return [[ConfigInfoManager sharedInstance]getConfigItemCodeByType:MainConfigInfoTableType2 value:productTypeName];
}

+ (NSString*)subProductTypeCodeByName:(NSString*)subProductTypeName
{
    return [[ConfigInfoManager sharedInstance]getConfigItemCodeByType:MainConfigInfoTableType3 value:subProductTypeName];
}

+ (NSString*)extendProductBrandName:(ExtendProductContent*)product
{
    BOOL isOtherBrand = [product.zzfld000000 isEqualToString:@"QT"];
    NSString *brandName;

    if (isOtherBrand) {
        brandName = product.zzfld000003v;
    }else {
        brandName = [[ConfigInfoManager sharedInstance]getConfigItemValueByType:MainConfigInfoTableType1001 code:product.zzfld000000];
    }
    return [Util defaultStr:@"品牌未知" ifStrEmpty:brandName];
}

+(NSString*)extendSubProductName:(ExtendProductContent*)product forType:(kExtendServiceType)serviceType
{
    MainConfigInfoTableType type = MainConfigInfoTableType3;
    if (serviceType == kExtendServiceTypeMutiple) {
        type = MainConfigInfoTableType30;
    }
    NSString *productName = [[ConfigInfoManager sharedInstance]getConfigItemValueByType:type code:product.zzfld000001];
    return [Util defaultStr:@"产品未知" ifStrEmpty:productName];
}

+(NSString*)extendProductModelName:(ExtendProductContent*)product
{
    NSString *productModel = [Util defaultStr:product.zzfld00005j ifStrEmpty:product.zzfld00000q];
    return [Util defaultStr:@"机型未知" ifStrEmpty:productModel];
}

+(NSString*)provinceValueForCode:(NSString*)provinceCode
{
    NSString *itemValue = [[ConfigInfoManager sharedInstance]getConfigItemValueByType:MainConfigInfoTableType18 code:provinceCode];
    return itemValue;
}

+(NSString*)cityValueForCode:(NSString*)cityCode
{
    NSString *itemValue = [[ConfigInfoManager sharedInstance]getConfigItemValueByType:MainConfigInfoTableType19 code:cityCode];
    return itemValue;
}

+(NSString*)districtValueForCode:(NSString*)districtCode
{
    NSString *itemValue = [[ConfigInfoManager sharedInstance]getConfigItemValueByType:MainConfigInfoTableType20 code:districtCode];
    return itemValue;
}

+(NSString*)streetValueForCode:(NSString*)streetCode
{
    NSString *itemValue = [[ConfigInfoManager sharedInstance]getConfigItemValueByType:MainConfigInfoTableType21 code:streetCode];
    return itemValue;
}

+ (NSString*)productBrandCodeForValue:(NSString*)brandCode
{
    NSString *itemCode = [[ConfigInfoManager sharedInstance]getConfigItemCodeByType:MainConfigInfoTableType1 value:brandCode];
    return itemCode;
}

+ (NSString*)productTypeCodeForValue:(NSString*)typeCode
{
    NSString *itemCode = [[ConfigInfoManager sharedInstance]getConfigItemCodeByType:MainConfigInfoTableType2 value:typeCode];
    return itemCode;
}

+ (NSString*)productCategoryCodeForValue:(NSString*)categoryValue
{
    NSString *itemCode = [[ConfigInfoManager sharedInstance]getConfigItemCodeByType:MainConfigInfoTableType3 value:categoryValue];
    return itemCode;
}

+ (BOOL)isMaintainContentIntegrateForNew:(PartMaintainContent*)content
{
    do {
//        BreakIf([Util isEmptyString:content.object_id];//工单号
//        BreakIf([Util isEmptyString:content.dispatch_parts_id;//备件?
//        BreakIf([Util isEmptyString:content.parts_bominfo_id;//备件bom表id
//        BreakIf([Util isEmptyString:content.parts_maininfo_id;//备件主数据表id

        BreakIf([Util isEmptyString:content.puton_part_matno]);//换上件,组件物料
        BreakIf([Util isEmptyString:content.puton_part_number]);//换上件,数量
        BreakIf([Util isEmptyString:content.puton_status]);//换上件,申请状态(1创建，2申请,3doa)
        BreakIf([Util isEmptyString:content.part_text]);//组件描述

        BreakIf([Util isEmptyString:content.putoff_status]);//换下件,申请状态(默认1创建)
        BreakIf([Util isEmptyString:content.putoff_part_matno]);//换下件,组件物料
        BreakIf([Util isEmptyString:content.putoff_part_number]);//换下件,数量
        BreakIf([Util isEmptyString:content.putoff_part_text]);//换下件描述, Local
        return YES;
    } while (NO);
    return NO;
}

+ (BOOL)canEditPartMaintainContent:(PartMaintainContent*)content
{
    BOOL canEditComponent = NO;
    
    if([content.puton_status isEqualToString:@"1"]){
        //创建
        canEditComponent = YES;
    }else if([Util isEmptyString:content.puton_status]){
        canEditComponent = YES;
    }

    return canEditComponent;
}

+ (NSString*)thumbTelnumbers:(NSString*)telnumbersStr
{
    NSString *thumbStr = telnumbersStr;

    NSArray *telArray = [telnumbersStr componentsSeparatedByString:@","];
    if (telArray.count == 1) {
        thumbStr = telArray[0];
    }else if (telArray.count > 1){
        thumbStr = [NSString stringWithFormat:@"%@ , ...",telArray[0]];
    }else {
        thumbStr = kUnknown;
    }
    return thumbStr;
}

+ (BOOL)checkIsPartsAffectFinishOrder:(NSArray*)components{
    for (PartMaintainContent *part in components) {
        ReturnIf(part.bAffectPerformOrder)YES;
    }
    return NO;
}

+ (NSString*)checkNumberInput:(NSString*)numStr name:(NSString*)name greaterThan:(CGFloat)minValue{
    NSString *inValidError;
    do {
        if ([Util isEmptyString:numStr]) {
            inValidError = [@"请填写" appendStr:name];
        }
        BreakIf(nil != inValidError);
        
        if (![numStr isPureFloat] || ![numStr isPureInt] ) {
            inValidError = [@"请填写正确的" appendStr:name];
        }
        BreakIf(nil != inValidError);
        
        if ([numStr floatValue] <= minValue) {
            inValidError = [name appendStr:@"必须大于"];
            inValidError = [inValidError appendStr:[NSString stringWithFormat:@"%.0f",minValue]];
        }
        BreakIf(nil != inValidError);
    } while (0);
    
    return inValidError;
}

+ (NSArray*)getOrderStatusGroupsBy:(NSString*)orderProgress isReceive:(NSString*)isReceive workerId:(NSString*)workerId
{
    NSMutableArray *matchGroups = [NSMutableArray new];

    BOOL receiveStr0 = [isReceive isEqualToString:@"0"];
    BOOL receiveStr1 = [isReceive isEqualToString:@"1"];
    BOOL receiveStr2 = [isReceive isEqualToString:@"2"];
    BOOL amIWorker = [workerId isEqualToString:[UserInfoEntity sharedInstance].userId];

    NSInteger orderStatus = NSNotFound;
    
    switch ([UserInfoEntity sharedInstance].userRoleType) {
        case kUserRoleTypeFacilitator:
        {
            if ([orderProgress isEqualToString:@"SR20"]) {
                orderStatus = kFacilitatorOrderStatusNew;
                [matchGroups addObject:@(orderStatus)];
            }if ([orderProgress isEqualToString:@"SR30"]) {
                orderStatus = kFacilitatorOrderStatusReceived;
                [matchGroups addObject:@(orderStatus)];
            }if ([orderProgress isEqualToString:@"SR01"] && (receiveStr0 || receiveStr1)) {
                orderStatus = kFacilitatorOrderStatusAssigned;
                [matchGroups addObject:@(orderStatus)];
            }if (![orderProgress isEqualToString:@"SR50"] && receiveStr2) {
                orderStatus = kFacilitatorOrderStatusRefused;
                [matchGroups addObject:@(orderStatus)];
            }if ([orderProgress isEqualToString:@"SR41"]) {
                orderStatus = kFacilitatorOrderStatusAppointed;
                [matchGroups addObject:@(orderStatus)];
            }if ([orderProgress isEqualToString:@"SR40"]) {
                orderStatus = kFacilitatorOrderStatusAppointFailure;
                [matchGroups addObject:@(orderStatus)];
            }if (amIWorker && [orderProgress isEqualOneInArray:@[@"SR01", @"SR40"]] && !receiveStr0) {
                orderStatus = kFacilitatorOrderStatusWaitForAppointment;
                [matchGroups addObject:@(orderStatus)];
            }if (amIWorker && [orderProgress isEqualOneInArray:@[@"SR41", @"SR45",@"SR46"]]) {
                orderStatus = kFacilitatorOrderStatusWaitForExecution;
                [matchGroups addObject:@(orderStatus)];
            }if ([orderProgress isEqualOneInArray:@[@"SR45",@"SR46"]]) {
                orderStatus = kFacilitatorOrderStatusUnfinish;
                [matchGroups addObject:@(orderStatus)];
            }if ([orderProgress isEqualToString:@"SR50"]) {
                orderStatus = kFacilitatorOrderStatusFinished;
                [matchGroups addObject:@(orderStatus)];
            }
        }
            break;
        case kUserRoleTypeRepairer:
        {
            if (receiveStr0 && [orderProgress isEqualOneInArray:@[@"SR01",@"SR41",@"SR46",@"SR45",@"SR40"]]) {
                orderStatus = kRepairerOrderStatusNew;
                [matchGroups addObject:@(orderStatus)];
            }if (receiveStr1 && [orderProgress isEqualOneInArray:@[@"SR01"]]){
                orderStatus = kRepairerOrderStatusWaitForAppointment;
                [matchGroups addObject:@(orderStatus)];
            }if (receiveStr1 && [orderProgress isEqualOneInArray:@[@"SR40"]]){
                orderStatus = kRepairerOrderStatusAppointFailure;
                [matchGroups addObject:@(orderStatus)];
            }if (receiveStr1 && [orderProgress isEqualOneInArray:@[@"SR41"]]){
                orderStatus = kRepairerOrderStatusWaitForExecution;
                [matchGroups addObject:@(orderStatus)];
            }if (receiveStr1 && [orderProgress isEqualOneInArray:@[@"SR45",@"SR46"]]){
                orderStatus = kRepairerOrderStatusUnfinish;
                [matchGroups addObject:@(orderStatus)];
            }if ([orderProgress isEqualToString:@"SR50"]) {
                orderStatus = kRepairerOrderStatusFinished;
                [matchGroups addObject:@(orderStatus)];
            }
        }
            break;
        case kUserRoleTypeSupporter:
            break;
        default:
            break;
    }
    
    return matchGroups;
}

+ (void)popToOrderListViewController:(UIViewController*)fromVc
{
    if (![fromVc.navigationController.topViewController isKindOfClass:[OrderListViewController class]]) {
        for (UIViewController *vc in fromVc.navigationController.viewControllers) {
            if ([vc isKindOfClass:[OrderListViewController class]]) {
                if (vc != fromVc) {
                    [fromVc popTo:vc];
                }
            }
        }
    }
}

+ (void)popToLatestListViewController:(UIViewController*)fromVc
{
    for (UIViewController *vc in fromVc.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ExtendServiceListViewController class]]
            ||[vc isKindOfClass:[OrderListViewController class]]
            ||[vc isKindOfClass:[HistoryOrderListViewController class]]) {
            if (vc != fromVc) {
                [fromVc popTo:vc];
            }
        }
    }
}

@end
