//
//  MiscHelper.h
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-4-28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SideBarEntity.h"
#import <MapKit/MapKit.h>
#import "WZSingleCheckViewController.h"
#import "LocationManager.h"
#import "PleaseSelectViewCell.h"
#import "TextFieldTableViewCell.h"

@class  ViewController;

#pragma - 各项可抽象出来的都可以放在于此

@interface MiscHelper : NSObject

+ (instancetype)sharedInstance;

+ (UIButton *)makeImageTextButton:(ImageTextButtonData*)buttonData;

+ (UITableViewCell*)makeCommonSelectCell:(NSString*)title;

+ (PleaseSelectViewCell*)makePleaseSelectCell:(NSString*)title;

//编辑行CELL
+ (TextFieldTableViewCell*)makeTextFieldCell:(NSString*)placeHolder;

//机器条形码扫描或编辑
+ (TextFieldTableViewCell*)makeLeftEditRightBarCodeBtnCell:(id)target  action:(SEL)barCodeBtnClickAction;

+ (PleaseSelectViewCell*)makeSelectItemCell:(NSString*)title checkItems:(NSArray*)checkItems checkedItem:(CheckItemModel*)checkedItem;

//cell.accessoryView is UISwitchView
+ (UITableViewCell*)makeRightSwitchViewCell:(id)target action:(SEL)action;

+ (UIView*)makeTableViewSectionHeaderLabel:(CGFloat)height text:(NSString*)labelText;

+ (UITableViewCell*)makeCellWithLeftIcon:(NSString*)iconName leftTitle:(NSString*)title rightText:(NSString*)rightText;

//order list : OrderContentModel
+ (NSMutableArray*)parserOrderList:(id)resultData;

//groupStatus: 当为服务商时，则为kFacilitatorOrderStatus类型
//当为维修工时，则为kRepairerOrderStatus类型
//当为NSNotFound时，表不过虑
+ (NSMutableArray*)parserOrderList:(id)resultData filter:(NSInteger)groupStatus;
+ (NSMutableArray*)letv_parserOrderList:(id)resultData filter:(NSInteger)groupStatus;

//orders: LetvOrderContentModel array ,
//status: 当为服务商时，则为kFacilitatorOrderStatus类型
//当为维修工时，则为kRepairerOrderStatus类型
+(NSArray*)letv_filterOrders:(NSArray*)orders byStatus:(NSInteger)status;

//orders: OrderContentModel array ,
//status: 当为服务商时，则为kFacilitatorOrderStatus类型
//当为维修工时，则为kRepairerOrderStatus类型
+(NSArray*)filterOrders:(NSArray*)orders byStatus:(NSInteger)status;

//extend order list : ExtendServiceOrderContent
+ (NSMutableArray*)parserExtendOrderList:(id)resultData;

+ (OrderContentDetails *)parserOrderContentDetails:(id)resultData;
+ (ExtendServiceOrderContent*)parserExtendOrderDetails:(id)resultData;

//paser object list with entity class indicated by entiyClassName
+ (NSMutableArray*)parserObjectList:(id)resultData objectClass:(NSString*)entityClassName;

//paser street item and convert to CheckItemModel object
//resultData : street dic array or ConfigItemInfo dic array
+ (NSMutableArray*)parserStreetItems:(id)resultData;

+ (NSString *)getOrderProccessStatusStrById:(NSString*)processId;

//repairerHandle, 维修工是否接受工单（0：未处理；1：已接受；2：拒绝）,用于processId为SR01时
+ (NSString *)getOrderProccessStatusStrById:(NSString*)processId repairerHandle:(NSString*)repairerHandle;

+ (NSString *)getOrderHandleTypeStrById:(NSString*)processId;

//it's valid if return nil
+ (NSString*)isValidPasswordStr:(NSString*)password;

//必须是全是数字，或是以字母开头，剩下全是数字，且不能大于10位
+ (BOOL)isValidReceiptNumber:(NSString*)receiptNumber;

//push to check list view controller
//checkItems: item CheckItemModel
+ (WZSingleCheckViewController*)pushToCheckListViewController:(NSString
                                                             *)title
                                                 checkItems:(NSArray*)checkItems
                                                checkedItem:(CheckItemModel*)checked
                                                       from:(UIViewController*)viewController
                                                   delegate:(id<WZSingleCheckViewControllerDelegate>)delegate;

+ (CGFloat)cacheFolderSize;

+ (void)cleanCacheFolderWithComplete:(VoidBlock)completeCallBack;

+ (void)locateCurrentAddressWithComplete:(LocationCallBack)responseCallBack;

//是否有效的电视条形码, machineModel机型
+(NSString*)isValidChangHongTelevitionCode:(NSString*)barCode machineModel:(NSString*)machineModel;

//是否有效的空调条形码
+ (NSString *)isValidChangHongAirConditionCode:(NSString*)barCode;

//是否有效的单品延保合同号
+ (BOOL)isValidExtendOrderContractNo:(NSString*)extendOrderContractNo;

//machineCode机号格式是否符合brandId品牌下的productId产品中的categroy品类
+ (NSString*)machineCode:(NSString*)machineCode isMatchBrand:(NSString*)brandId product:(NSString*)productId categroy:(NSString*)categroyId;

//是否有效的多品延保合同号
+ (BOOL)isValidMutiExtendOrderContractNo:(NSString*)extendOrderContractNo;

+(kProductType)getProductTypeByBrand:(NSString*)brandId product:(NSString*)productId categroy:(NSString*)categroyId;

//根据品牌名得到其Code
+ (NSString*)productBrandCodeByName:(NSString*)brandName;

//根据产品品类得到其Code
+ (NSString*)subProductTypeCodeByName:(NSString*)subProductTypeName;

//根据产品大类名得到其Code
+ (NSString*)productTypeCodeByName:(NSString*)productTypeName;

//延保品牌名
+ (NSString*)extendProductBrandName:(ExtendProductContent*)product;

//延保产品品类
+(NSString*)extendSubProductName:(ExtendProductContent*)product forType:(kExtendServiceType)serviceType;

//延保机型
+(NSString*)extendProductModelName:(ExtendProductContent*)product;

//parser out code by value
+ (NSString*)productBrandCodeForValue:(NSString*)brandCode; //品牌
+ (NSString*)productTypeCodeForValue:(NSString*)typeCode;//产品
+ (NSString*)productCategoryCodeForValue:(NSString*)categoryValue;//品类

//新建备件信息的数据是否完整可提交了
+ (BOOL)isMaintainContentIntegrateForNew:(PartMaintainContent*)content;

//根据备件状态来检查是否可编辑
+ (BOOL)canEditPartMaintainContent:(PartMaintainContent*)content;

//parser address info
+(NSString*)provinceValueForCode:(NSString*)provinceCode;
+(NSString*)cityValueForCode:(NSString*)cityCode;
+(NSString*)districtValueForCode:(NSString*)districtCode;
+(NSString*)streetValueForCode:(NSString*)streetCode;

//telnumbersStr: ","号分隔的电话串，返回第一个电话加上"..."，省略号
+ (NSString*)thumbTelnumbers:(NSString*)telnumbersStr;

/*
 * components:PartMaintainContent
 * 检查备件是否影响完工，YES表示影响，则不能完工，NO表示不影响，可以完工
 */
+ (BOOL)checkIsPartsAffectFinishOrder:(NSArray*)components;

/**
 *  检查输入的数字是否正确
 *
 *  @param numStr   数字串
 *  @param name     名称
 *  @param minValue 最小值但不包括
 *
 *  @return nil 则表正确，反正之后错误内容
 */
+ (NSString*)checkNumberInput:(NSString*)numStr name:(NSString*)name greaterThan:(CGFloat)minValue;

//当前为服务商，则返回值为kFacilitatorOrderStatus的NSNumber 数组
//当前为维修工，则返回值为kRepairerOrderStatus的NSNumber 数组
//同一工单，可能同时归属于多个状态分组，所以用数组返回

//不支持技术支持人员
+ (NSArray*)getOrderStatusGroupsBy:(NSString*)orderProgress isReceive:(NSString*)isReceive workerId:(NSString*)workerId;

//pop到顶级的工单处理页面去
+ (void)popToOrderListViewController:(UIViewController*)fromVc;

//pop到最近上层的工单列表、或历史工单列表、或延保列表
+ (void)popToLatestListViewController:(UIViewController*)fromVc;
@end
