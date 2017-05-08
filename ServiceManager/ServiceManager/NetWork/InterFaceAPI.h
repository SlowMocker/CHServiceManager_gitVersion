//
//  InterFaceAPI.h
//  BaseProject
//
//  Created by wangzhi on 15-2-2.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

/*
 *  服务端提供的接口名，即URL的相对路径
 */

#import <Foundation/Foundation.h>

#ifndef BaseProject_InterFaceAPI_h
#define BaseProject_InterFaceAPI_h

#pragma mark - Part 1 : Common Interface

#pragma mark - -1.1 Common

//用户登录
static NSString *const ServerApiUserLogin = @"/userLogin/doLogin/";

//修改密码
static NSString *const ServerApiChangePassword = @"/repairman/updatePassword/";

//修改员工信息
static NSString *const ServerApiChangeUserInfo = @"/repairman/updateRepairmanInfo/";

//技术支持人员列表
static NSString *const ServerApiGetEngneerList = @"/repairman/querySupportManList/";

//申请技术支持
static NSString *const ServerApiApplySupportHelp = @"/repairman/applySupport/";

//服务商维修人员列表,用于派工
static NSString *const ServerApiGetRepairerList = @"/serviceProvider/queryRepairmanList/";

//派工给服务工程师(维修工)
static NSString *const ServerApiAssignEngineer = @"/serviceProvider/dispatching/";

//公告列表
static NSString *const ServerApiQueryBulletinList = @"/notice/list/";

//公告详情
static NSString *const ServerApiQueryBulletinDetails = @"/notice/detail/";

//首页热门公告列表
static NSString *const ServerApiGetTopBulletinList = @"/notice/list/home/";

//Qiniu云图片上传的TOKEN
static NSString *const ServerApiGetQiniuUploadToken = @"/repairman/getQiniuUploadToken/";

//问卷调查
static NSString *const ServerApiGetQuestionnaireSurvey = @"/survey/detail/";

//意见反馈
static NSString *const ServerApiSubmitFeedback = @"/feedback/add/";

//读配置主数据
static NSString *const ServerApiGetMainInfoList = @"serviceProvider/queryMainInfoList/";

//读街道主数据
static NSString *const ServerApiGetStreetInfoList = @"/serviceProvider/queryStreetList/";

//工单详情
static NSString *const ServerApiGetOrderDetails = @"/repairman/queryDispatchInfoDetail/";

//服务改善详情
static NSString *const ServerApiGetServiceImproveDetails = @"/serviceProvider/queryServiceImprovementDetail/";

//设备信息
static NSString *const ServerApiGetDeviceInfos = @"/repairman/queryMachinesDeviceInfo/";

//读取空调云设备信息
static NSString *const ServerApiGetChiqAirConditioningDeviceInfos = @"http://chiq2.chiq-cloud.com/chiq2/api/v2/wggBarcode/getFromDb/";

//服务商删除其下的维修工
static NSString *const ServerApiDeleteEmployee = @"/serviceProvider/repairmanDelete/";

//活动详情
static NSString *const ServerApiQueryActivityContentDetail = @"/repairman/queryActivityContentDetail/";

//微信点评二纬码请求
static NSString *const ServerApiGetWeixinCommentQrCode = @"/repairman/applyForComment/";

//获取延保收款单信息
static NSString *const ServerApiGetExtendPayOrderInfo = @"/extendprd/submitExtendWarranty/";

//存储上传的图片信息
static NSString *const ServerApiSaveImageInfos = @"/repairman/saveImageUrl/";

#pragma mark -  -1.2 Facilitator

//接受、拒绝订单
static NSString *const ServerApiFacilitatorRefuseOrder = @"/serviceProvider/acceptOrRefuse";

//服务商订单列表
static NSString *const ServerApiGetSvcProviderOrderList = @"/serviceProvider/queryDispatchInfoList/";

//服务改善列表
static NSString *const ServerApiGetServiceImproveList = @"/serviceProvider/queryServiceImprovementList";

#pragma mark -  -1.3 Repairer

//接受、拒绝订单
static NSString *const ServerApiRepairerRefuseOrder = @"/repairman/acceptOrRefuse/";

//维修工订单列表
static NSString *const ServerApiGetRepairOrderList = @"/repairman/queryDispatchInfoList/";

//搜索工单
static NSString *const ServerApiSearchOrders = @"/repairman/queryList4RepairmanByObjectid/";

//查找备件
static NSString *const ServerApiRepairSelectParts = @"/repairman/findParts/";

//增、删、改备件
static NSString *const ServerApiRepairOperateParts = @"/repairman/updateParts/";

//备件信息
static NSString *const ServerApiGetPartInfo = @"/repairman/partsScan/";

//机型品类
static NSString *const ServerApiGetMachineCategory = @"/repairman/queryAircraftCategory/";

//完成工单
static NSString *const ServerApiFinishBill = @"/repairman/finishWork/";

//特殊完工
static NSString *const ServerApiSpecialFinishBill = @"/repairman/specialFinishWork/";

//JD鉴定图片上传状态
static NSString *const ServerApiJdIdentiyUploadImageStatus = @"/serviceProvider/uploadJdjcd/";

//创建或编辑单品延保单
static NSString *const ServerApiEditSingleExtendServiceOrder = @"/extendprd/createSingleExtendprd/";

//创建或编辑单品延保单(电子延保单)
static NSString *const ServerApiEditEContractSingleExtendServiceOrder = @"/extendprd/createEcontractSingleExtendprd/";

//创建或编辑多品延保单
static NSString *const ServerApiEditMutiExtendServiceOrder = @"/extendprd/createMultipleExtendprd/";

//创建或编辑多品延保单(电子延保单)
static NSString *const ServerApiEditEContractMutiExtendServiceOrder = @"/extendprd/createEcontractMultipleExtendprd/";

//单、多品延保单列表
static NSString *const ServerApiGetExtendOrderList = @"/extendprd/queryExtendprdList/";

//删除电子延保单
static NSString *const ServerApiDeleteExtendOrder = @"/extendprd/deleteExtendWarranty/";

//单、多品延保单详情
static NSString *const ServerApiGetExtendOrderDetails = @"/extendprd/queryExtendprdDetail/";

//模糊查询机型
static NSString *const ServerApiFindMachineModel = @"/repairman/queryFuzzyAircraft/";

//服务商预约
static NSString *const ServerApiAppointmentOrder = @"/serviceProvider/appointment/";

//服务商改约
static NSString *const ServerApiChangeAppointmentOrder = @"/serviceProvider/changeAppointment/";

//新加维修工
static NSString *const ServerApiNewRepairer = @"/serviceProvider/repairmanRegister/";

//保外费用添加或编辑
static NSString *const ServerApiEditFeeOrder = @"/expense/updateExpense/";

//删除费用
static NSString *const ServerApiDeleteFeeOrder = @"/expense/deleteExpense/";

//删除所有费用
static NSString *const ServerApiDeleteAllFeeOrder = @"/expense/deleteAllExpenses/";

//同步费用管理列表
static NSString *const ServerApiSyncFeeBillList = @"/expense/syncExpense/";

//查询费用管理同步情况
static NSString *const ServerApiQueryFeeBillStatus = @"/expense/queryExpenseNumber/";

//维修工预约,改约
static NSString *const ServerApiRepairerAppointmentOrder = @"/repairman/appointment/";

//维修工技术确认
static NSString *const ServerApiRepairerConfirmSupportOrder = @"/repairman/confirmSupport/";

//维修工管理列表
static NSString *const ServerApiRepairerManagerList = @"/serviceProvider/queryRepairmanManageList/";

//备件跟踪列表
static NSString *const ServerApiPartTracklist = @"/repairman/queryPartsTrackList/";

//备件跟踪状态更新
static NSString *const ServerApiSetPartTraceStatus = @"/repairman/updateParts/";

//费用管理列表
static NSString *const ServerApiQueryExpenseList = @"/expense/queryExpenseList/";

//接受催单
static NSString *const ServerApiAgreeOrderUrge = @"/repairman/acceptUrge/";

//维修工上门签到
static NSString *const ServerApiRepairSignIn = @"/repairman/sign/";

//技术支持订单列表
static NSString *const ServerApiGetSupporterOrderList = @"/support/querySupportInfoList/";

//技术工接受支持
static NSString *const ServerApiSupporterAcceptTask = @"/support/accept/";

#pragma mark - Part 2 : Letv Interface

//服务商维修人员列表,用于派工
static NSString *const LetvServerApiGetRepairerList = @"/lsServiceProvider/queryRepairmanList/";

//派工给服务工程师(维修工)
static NSString *const LetvServerApiAssignEngineer = @"/lsServiceProvider/dispatching/";

//服务商订单列表
static NSString *const LetvServerApiGetSvcProviderOrderList = @"/lsServiceProvider/queryDispatchInfoList/";

//服务商接受、拒绝订单
static NSString *const LetvServerApiFacilitatorRefuseOrder = @"/lsServiceProvider/acceptOrRefuse/";

//工单详情
static NSString *const LetvServerApiGetOrderDetails = @"/lsRepairman/queryDispatchInfoDetail/";

//维修工技术确认
static NSString *const LetvServerApiRepairerConfirmSupportOrder = @"/lsRepairman/confirmSupport/";

//技术支持订单列表
static NSString *const LetvServerApiGetSupporterOrderList = @"/lsSupport/querySupportInfoList/";

//维修工订单列表
static NSString *const LetvServerApiGetRepairOrderList = @"/lsRepairman/queryDispatchInfoList/";

//接受、拒绝订单
static NSString *const LetvServerApiRepairerRefuseOrder = @"/lsRepairman/acceptOrRefuse/";

//技术工接受支持
static NSString *const LetvServerApiSupporterAcceptTask = @"/lsSupport/accept/";

//维修工预约,改约
static NSString *const LetvServerApiRepairerAppointmentOrder = @"/lsRepairman/appointment/";

//服务商预约
static NSString *const LetvServerApiAppointmentOrder = @"/lsServiceProvider/appointment";

//服务商改约
static NSString *const LetvServerApiChangeAppointmentOrder = @"/lsServiceProvider/changeAppointment";

//完成工单
static NSString *const LetvServerApiFinishBill = @"/lsRepairman/finishWork/";

//Special完工
static NSString *const LetvSpecialServerApiFinishBill = @"/lsRepairman/specialFinishWork/";

//机型物料代码
static NSString *const LetvServerApiQueryBomCodes = @"/lsRepairman/queryBomCodeByModel/";

//接受催单
static NSString *const LetvServerApiAgreeOrderUrge = @"/lsRepairman/acceptUrge/";

//维修工上门签到
static NSString *const LetvServerApiRepairSignIn = @"/lsRepairman/sign/";

//模糊查询机型
static NSString *const LetvServerApiFindMachineModel = @"/lsRepairman/queryFuzzyAircraft/";

//费用管理列表
static NSString *const LetvServerApiQueryExpenseList = @"/lsExpense/queryExpenseList/";

//费用项添加或编辑
static NSString *const LetvServerApiEditFeeOrder = @"/lsExpense/updateExpense/";

//费用项数量
static NSString *const LetvServerGetFeeItemCount = @"/lsExpense/queryExpenseNumber/";

//删除费用
static NSString *const LetvServerApiDeleteFeeOrder = @"/lsExpense/deleteExpense/";

//删除所有费用
static NSString *const LetvServerApiDeleteAllFeeOrder = @"/lsExpense/deleteAllExpenses/";

//技术支持人员列表
static NSString *const LetvServerApiGetEngneerList = @"/lsRepairman/querySupportManList/";

//申请技术支持
static NSString *const LetvServerApiApplySupportHelp = @"/lsRepairman/applySupport/";

//搜索工单
static NSString *const LetvServerApiSearchOrders = @"/lsRepairman/queryList4RepairmanByObjectid/";

#pragma mark
#pragma mark 智米品牌

// 维修人员列表,用于派工
static NSString *const SmartMiServerApiGetRepairerList = @"/zmServiceProvider/queryRepairmanList/";

// 派工给服务工程师(维修工)
static NSString *const SmartMiServerApiAssignEngineer = @"/zmServiceProvider/dispatching/";

// 维修工上门签到
static NSString *const SmartMiServerApiRepairSignIn = @"/zmRepairman/sign/";

// 订单详情
static NSString *const SmartMiServerApiGetOrderDetails = @"/zmRepairman/queryDispatchInfoDetail/";


#pragma mark
#pragma mark 服务商
// 服务商订单列表
static NSString *const SmartMiServerApiGetSvcProviderOrderList = @"/zmServiceProvider/queryDispatchInfoList/";

//接受、拒绝订单
static NSString *const SmartMiServerApiFacilitatorRefuseOrder = @"/zmServiceProvider/acceptOrRefuse/";

//服务商预约
static NSString *const SmartMiServerApiAppointmentOrder = @"/zmServiceProvider/appointment/";

//服务商改约
static NSString *const SmartMiServerApiChangeAppointmentOrder = @"/zmServiceProvider/changeAppointment/";

#pragma mark
#pragma mark 维修工
//维修工订单列表
static NSString *const SmartMiServerApiGetRepairOrderList = @"/zmRepairman/queryDispatchInfoList/";

//接受、拒绝订单
static NSString *const SmartMiServerApiRepairerRefuseOrder = @"/zmRepairman/acceptOrRefuse/";

//维修工预约,改约
static NSString *const SmartMiRepairerAppointmentOrder = @"/zmRepairman/appointment/";

//维修工接受催单
static NSString *const SmartMiAgreeOrderUrge = @"/zmRepairman/acceptUrge/";

//维修工获取机型品牌
static NSString *const SmartMiQueryAircraftBrand = @"/zmRepairman/queryAircraftBrand/";

//维修工模糊查询
static NSString *const SmartMiQueryFuzzyAircraft = @"/zmRepairman/queryFuzzyAircraft/";

//维修工完工
static NSString *const SmartMiFinishWork = @"/zmRepairman/finishWork/";

//维修工取消工单
static NSString *const SmartMiCancelWork = @"/zmRepairman/cancelWork/";

//维修工查询工单
static NSString *const SmartMiQueryList4RepairmanByObjectid = @"/zmRepairman/queryList4RepairmanByObjectid/";

//保存照片地址
static NSString *const SmartMiSaveImageUrl = @"/zmRepairman/saveImageUrl/";

#endif
