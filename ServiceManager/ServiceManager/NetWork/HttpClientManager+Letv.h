//
//  HttpClientManager+Letv.h
//  ServiceManager
//
//  Created by will.wang on 16/5/16.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  乐视功能相关接口
 */
@interface HttpClientManager(LetvInterFace)

//维修工订单列表
-(void)letv_repairer_orderList:(LetvRepairOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//服务商订单列表
-(void)letv_facilitator_orderList:(LetvFacilitatorOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//接受催单
- (void)letv_agreeOrderUrge:(LetvAgreeUrgeInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//工单详情
- (void)letv_getOrderDetails:(LetvGetOrderDetailsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//维修工预约,改约,
- (void)letv_repairer_appointmentOrder:(LetvRepairerAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//服务商接受、拒绝订单
- (void)letv_facilitator_refuseOrder:(LetvRefuseOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//维修工接受、拒绝订单
- (void)letv_repairer_refuseOrder:(LetvRepairRefuseOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//派工给服务工程师(维修工)
-(void)letv_assignEngineer:(LetvAssignEngineerInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//维修工员列表,用于派工
- (void)letv_getRepairerList:(LetvGetRepairerListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//签到
-(void)letv_repairSignIn:(LetvRepairSignInInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//模糊查询机型
- (void)letv_findMachineModel:(LetvFindMachineModelInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//技术支持人员列表, List Item : EmployeeInfo
- (void)letv_getEngneerList:(LetvGetEngneerListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//费用管理列表
- (void)letv_queryExpenseList:(LetvExpenseListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//费用项添加或编辑
- (void)letv_editFeeOrder:(LetvEditFeeOrderInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock;

//费用项数量
- (void)letv_getFeeItemCount:(LetvGetFeeItemCountInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock;

//删除费用
- (void)letv_deleteFeeOrder:(LetvDeleteFeeOrderInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock;

//删除所有费用
- (void)letv_deleteAllFeeOrder:(LetvDeleteAllFeeOrderInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock;

//机型物料代码
- (void)letv_queryBomCodes:(LetvQueryBomCodesInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//申请技术支持
- (void)letv_applySupportHelp:(LetvApplySupportHelpInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//维修工技术确认
- (void)letv_repairer_confirmSupport:(LetvConfirmSupportInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//技术支持订单列表
-(void)letv_supporter_orderList:(LetvSupporterOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//技术工接受支持
-(void)letv_supporter_accept:(LetvSupporterAcceptInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//服务商预约
- (void)letv_facilitator_appointmentOrder:(LetvAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//服务商改约
- (void)letv_facilitator_changeAppointmentOrder:(LetvChangeAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//完工执行
- (void)letv_repairFinishBill:(LetvFinishBillInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//特殊完工
- (void)letv_specialRepairFinishBill:(LetvSpecialFinishBillInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//搜索工单requestCallBackBlock's param 3 is LetvOrderContentModel array
- (void)letv_searchOrders:(LetvSearchOrdersInputParams*)input response:(RequestCallBackBlockV2)requestCallBackBlock;

@end
