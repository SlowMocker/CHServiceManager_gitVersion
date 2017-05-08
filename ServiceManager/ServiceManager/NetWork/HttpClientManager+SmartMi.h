//
//  HttpClientManager+SmartMi.h
//  ServiceManager
//
//  Created by Wu on 17/3/24.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "HttpClientManager.h"

@interface HttpClientManager (SmartMi)

/**
 *  维修人员列表,用于派工（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_getRepairerList:(SmartMiGetRepairerListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 *  维修人员签到（服务商也用这个接口）（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_repairSignIn:(SmartMiRepairSignInInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 *  工单详情（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_getOrderDetails:(SmartMiGetOrderDetailsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

#pragma mark
#pragma mark 服务商
/**
 *  订单列表（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_facilitator_orderList:(SmartMiFacilitatorOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 *  接受、拒绝订单（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_facilitator_refuseOrder:(SmartMiFacilitatorRefuseOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 *  预约（成功、失败）提交（路径和参数已经修改，数据处理未做）
 *  @note 需要做服务过程处理
 */
- (void) smartMi_facilitator_appointmentOrder:(SmartMiFacilitatorAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 *  改约、二次预约（路径和参数已经修改，数据处理未做）
 *  @note 需要做服务过程处理
 */
- (void) smartMi_facilitator_changeAppointmentOrder:(SmartMiFacilitatorChangeAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 *  派工给服务工程师（路径和参数已经修改，数据处理未做）
 */
-(void) smartMi_assignEngineer:(SmartMiAssignEngineerInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

#pragma mark
#pragma mark 维修工
/**
 *  维修工订单列表（路径和参数已经修改，数据处理未做）
 */
-(void) smartMi_repairer_orderList:(SmartMiRepairOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 * 维修工接受、拒绝订单（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_repairer_refuseOrder:(SmartMiRepairRefuseOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 *  维修工预约（成功、失败）提交（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_repairer_appointmentOrder:(SmartMiRepairerAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 *  维修工接受催单（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_repairer_agreeOrderUrge:(SmartMiRepairerAgreeOrderUrgeInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 *  获取机型品牌（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_repairer_queryAircraftBrand:(SmartMiRepairerQueryAircraftBrandInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 *  机型模糊查询（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_repairer_queryFuzzyAircraft:(SmartMiRepairerQueryFuzzyAircraftInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 *  完工（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_repairer_finishWork:(SmartMiRepairerFinishWorkInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 *  取消工单（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_repairer_cancelWork:(SmartMiRepairerCancelWorkInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

/**
 *  查询工单（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_repairer_queryList4RepairmanByObjectid:(SmartMiRepairerQueryList4RepairmanByObjectidInputParams*)input response:(RequestCallBackBlockV2)requestCallBackBlock;

/**
 *  保存照片地址（路径和参数已经修改，数据处理未做）
 */
- (void) smartMi_repairer_saveImageUrl:(SmartMiRepairerSaveImageUrlInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

#pragma mark
#pragma mark 技术支持

@end
