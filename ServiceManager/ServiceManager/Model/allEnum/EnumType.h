//
//  EnumType.h
//  BaseProject
//
//  Created by wangzhi on 15-1-24.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HttpResponseData;

//Sex Type
typedef NS_ENUM(NSInteger, kPersonSexType)
{
    kPersonSexTypeUnknown = 0,
    kPersonSexTypeMale = 1,
    kPersonSexTypeFemale = 2
};

//User Roles
typedef NS_ENUM(NSInteger, kUserRoleType)
{
    kUserRoleTypeFacilitator = 0,   //服务商
    kUserRoleTypeRepairer = 1,          //维修人员
    kUserRoleTypeDealer = 2,            //经销商
    kUserRoleTypeBranchManager = 3,     //分公司经理
    kUserRoleTypeSupporter = 4,         //技术支持人员
    kUserRoleTypeMultiMediaManager = 5  //多媒体服务经理
};
extern NSString *getUserRoleTypeName(kUserRoleType roleType);

//order status
typedef NS_ENUM(NSInteger, kFacilitatorOrderStatus)
{
    kFacilitatorOrderStatusNew = 101, //新工单
    kFacilitatorOrderStatusReceived = 102,//已接受(未派工)
    kFacilitatorOrderStatusAssigned = 103,//已派工
    kFacilitatorOrderStatusWaitForAppointment = 104, //待预约
    kFacilitatorOrderStatusWaitForExecution = 105, //待执行
    kFacilitatorOrderStatusRefused = 106, //维修工已拒绝
    kFacilitatorOrderStatusAppointed = 107, //维修工已预约
    kFacilitatorOrderStatusAppointFailure = 108, //维修工预约失败
    kFacilitatorOrderStatusUnfinish = 109,//未完工
    kFacilitatorOrderStatusConfirm = 201,//技术确认
    kFacilitatorOrderStatusAppointTrace = 120, //备件跟踪(状态)
    kFacilitatorOrderStatusFinished = 999  //已完工（历史工单）
};
extern NSString *getFacilitatorOrderStatusStr(kFacilitatorOrderStatus status);

typedef NS_ENUM(NSInteger, kRepairerOrderStatus)
{
    kRepairerOrderStatusNew = 201,//  新工单
    kRepairerOrderStatusWaitForAppointment = 202, //待预约
    kRepairerOrderStatusAppointFailure = 230, //预约失败
    kRepairerOrderStatusWaitForExecution = 240, //待执行
    kRepairerOrderStatusUnfinish = 250, //未完工
    kRepairerOrderStatusConfirm = 270, //技术确认工单列表
    kRepairerOrderStatusTrace = 280, //备件跟踪(状态)
    kRepairerOrderStatusFinished = 999    //已完工（历史工单）
};
extern NSString *getRepairerOrderStatusStr(kRepairerOrderStatus status);

//首页功能项
typedef NS_ENUM(NSInteger, kHomePadFeatureItem)
{
    kHomePadFeatureItemOrderManage = 0x7362, //工单处理
    kHomePadFeatureItemSupport,     //技术支持(点评)
    kHomePadFeatureItemPartTrace,   //备件跟踪
    kHomePadFeatureItemImprovement, //服务改善
    kHomePadFeatureItemTaskManage,   //任务处理,技术支持人员专项
    kHomePadFeatureItemExtendService,   //延保管理
    kHomePadFeatureItemEmployeeManage,   //员工管理
    kHomePadFeatureItemResource,    //技术资料
    kHomePadFeatureItemServicePrice, //服务价格
    kHomePadFeatureItemTaskOrderHistory    //历史工单
};
extern NSString *getHomePadFeatureItemName(kHomePadFeatureItem item);

//首页功能项Section Ids
typedef NS_ENUM(NSInteger, kHomeSectionItem)
{
    kHomeSectionItemTools,          //工具箱
    kHomeSectionItemCommonBrands,   //长虹、启客、三洋、迎燕等品牌
    kHomeSectionItemLetvBrand,      //乐视品牌
    kHomeSectionItemMeiningBrand,   //美菱品牌
    
    kHomeSectionItemSmartMiBrand,   //智米品牌
};
extern NSString *getHomeSectionItemName(kHomeSectionItem item);


typedef NS_ENUM(NSInteger, kSupporterOrderStatus)
{
    kSupporterOrderStatusApply = 101,       //申请
    kSupporterOrderStatusReceived = 102,    //已接受
    kSupporterOrderStatusConfirmed = 103    //已确认
};
extern NSString *getSupporterOrderStatusStr(kSupporterOrderStatus status);

typedef NS_ENUM(NSInteger, kOrderOperationType)
{
    kOrderOperationTypeNone     = 0,
    kOrderOperationTypeView     = (1 << 0), //查看
    kOrderOperationTypeDelete   = (1 << 1), //删除
    kOrderOperationTypeAgree    = (1 << 2), //接受
    kOrderOperationTypeAssign   = (1 << 3), //派工
    kOrderOperationTypeReassign = (1 << 4), //改派
    kOrderOperationTypeExecute  = (1 << 5), //执行
    kOrderOperationTypeAppointment       = (1 << 6), //预约
    kOrderOperationTypeChangeAppointment = (1 << 7),  //改约
    kOrderOperationTypeRefuse   = (1 << 8),   //拒绝
    kOrderOperationTypeAppointmentAgain = (1 << 9), //二次预约
    kOrderOperationTypeConfirm = (1 << 10), //技术确认
    kOrderOperationTypeSpecialFinish  = (1 << 11), //特殊完工
    kOrderOperationTypeExtend  = (1 << 12), //延保
    kOrderOperationTypeUserComment  = (1 << 13), //客户点评

    kOrderOperationTypeReceiveAccount  = (1 << 14), //收款
    kOrderOperationTypeEdit = (1 << 15) //编辑
};
NSString* getOrderOperationTypeStr(kOrderOperationType type);
UIColor* getOrderOperationButtonColor(kOrderOperationType type);

//接口返回的错误码
typedef NS_ENUM(NSInteger, kHttpReturnCode)
{
    kHttpReturnCodeSuccess = 0, // 	操作成功
    kHttpReturnCodeJsonIsNULL = 1,//终端Json串为空
    kHttpReturnCodeTokenIsInvalid =2,	//Token无效
    kHttpReturnCodeJsonFormatError =3,//	解析json报文失败
    kHttpReturnCodeEncryptError =4,    //加密 json报文失败
    kHttpReturnCodeDecryptError = 5,//	解密 json报文失败
    kHttpReturnCodeParameterError = 6,//	传递参数错误
    kHttpReturnCodeDatabaseExceptional = 7,//	数据库异常
    kHttpReturnCodeRecordNotExists = 8,//数据库记录不存在
    kHttpReturnCodeRecordExists = 9,//	记录重复
    kHttpReturnCodeNoPermission = 10,//	无操作权限
    kHttpReturnCodeTheCRMSyncError = 11,//	与CRM同步错误
    kHttpReturnCodeTheZNYSyncError = 12,//	与故障诊断平台同步错误
    kHttpReturnCodeRequestCRMError = 13,//	请求CRM平台错误
    kHttpReturnCodeRequestZNYError = 14,	//请求故障诊断平台平台错误
    kHttpReturnCodeSyncContractDataError = 15,//	与CRM同步系统延保合同信息错误
    kHttpReturnCodeSyncWeixinError = 16, //与微信公众号业务服务器同步错误！
    kHttpReturnCodeRequestWeixinError = 17, //请求微信公众号业务服务器错误！
    kHttpReturnCodeUsernameOrPasswordWrong = 1001,//用户名或密码是错误的
    kHttpReturnCodeUserNotExist = 3001,//用户不存在
    kHttpReturnCodeTheOldPasswordWrong = 3002,//	旧密码不正确
    kHttpReturnCodeMachinemodelIsWrong = 3003,//	内机条码错误，未找到对应的机型
    kHttpReturnCodeCannotDelete = 3004,//	维修工有未完成任务，不能删除
    kHttpReturnCodeCannotSet = 3005,//不能设置服务完工,相关联的屏坏机工单未完工!
    kHttpReturnCodeNotRepeatingOperation = 4001,//	不能重复操作提示
    kHttpReturnCodeProcessOperationError = 4002,//	流程操作错误
    kHttpReturnCodeMessageSendError = 5001,//	消息发送出现异常
    kHttpReturnCodeChangedAssign = 6004,//	服务商已改派

    kHttpReturnCodeCommentSuccess = 4003, //点评成功
    kHttpReturnCodePaymentSuccess = 4004, //支付成功

    //local
    kHttpReturnCodeErrorNet = 404,  //net error
    kHttpReturnCodeErrorUnkown      //unknown
};

//本地自定义错误码
typedef NS_ENUM(NSInteger, kErrorCode)
{
    kErrorCodeNetNotConnect = kHttpReturnCodeErrorNet,
    kErrorCodeUnkown = kHttpReturnCodeErrorUnkown
};
extern NSString *getErrorCodeDescription(kErrorCode errorCode);

typedef NS_ENUM(NSInteger, kOrderTraceStatus)
{
    kOrderTraceStatusNone = -1, //NONE
    kOrderTraceStatusSent = 7,  //已发货
    kOrderTraceStatusConfirmReveived = 9,   //确认收货
    kOrderTraceStatusDoaBack = 10   //DOA退回
};

typedef NS_ENUM(NSInteger, kOrderTraceHandleType)
{
    kOrderTraceHandleTypeReceive,   //收货
    kOrderTraceHandleTypeDOABack,   //DOA退回
    kOrderTraceHandleTypeEditPart   //变更条码
};
extern NSString *getOrderTraceHandleTypeStrById(kOrderTraceHandleType handleId);

//费用清单操作
typedef NS_ENUM(NSInteger, kSellFeeListHandleType)
{
    kSellFeeListHandleTypeEdit,     //编辑
    kSellFeeListHandleTypeDelete,   //删除
};
extern NSString *getSellFeeListHandleTypeStrById(kSellFeeListHandleType handleId);

//备件状态
extern NSString *getOrderTraceStatusById(NSString *orderTraceId);
extern NSString *getDispatchPartStatusById(NSString* statusId);

//备件维护
typedef NS_ENUM(NSInteger, kComponentMaintainHandleType) {
    kComponentMaintainHandleTypeView,   //查看
    kComponentMaintainHandleTypeEdit,   //编辑
    kComponentMaintainHandleTypeDelete  //删除
};
extern NSString *getComponentMaintainHandleTypeStrById(kComponentMaintainHandleType handleId);

//保修期
typedef NS_ENUM(NSInteger, kWarrantyRangeDate)
{
    kWarrantyDateRangeUnexpired = 10,
    kWarrantyDateRangeExpired = 20,
    kWarrantyDateRangeExtend = 30
};
extern NSString *getWarrantyDateStrById(NSString *orderTraceId);

typedef NS_ENUM(NSInteger, kExtendServiceType)
{
    kExtendServiceTypeSingle = 1,  //单宝
    kExtendServiceTypeMutiple = 2 // 家多宝
};
extern NSString *getExtendServiceTypeById(kExtendServiceType extendType);

//延保单状态
extern NSString *getExtendServiceOrderStatusById(NSString* statusId);

/**
 *  延保新建、从工单中补建、修改编辑
 */

typedef NS_ENUM(NSInteger, kExtendOrderEditMode)
{
    kExtendOrderEditModeNew, //新建
    kExtendOrderEditModeAppend, //从原来的工单中补建，会带入原有工单信息
    kExtendOrderEditModeEdit //修改，
};

//预约行为
typedef NS_ENUM(NSInteger, kAppointmentOperateType)
{
    kAppointmentOperateType1stTime, //预约
    kAppointmentOperateType2ndTime, //二次预约
    kAppointmentOperateTypeChangeTime//改约
};
extern NSString *getAppointmentOperateTypeStr(kAppointmentOperateType type);

typedef NS_ENUM(NSInteger, kPriceManageType)
{
    kPriceManageTypeNone = 1000,    //none
    kPriceManageTypeService = 1001,    //费用管理
    kPriceManageTypeSells = 1002        //智能销售管理
};
extern NSString *getPriceManageTypeStr(kPriceManageType priceManageType);
extern kPriceManageType getPriceManageTypeByCode(NSString *code);

#pragma mark - 售后管家支持的品牌
//品牌
typedef NS_ENUM(NSInteger, kServiceBrandType)
{
    kServiceBrandTypeChangHong, //长虹
    kServiceBrandTypeCHIQ,      //启客
    kServiceBrandTypeLetv,      //乐视
    kServiceBrandTypeMeLing,    //美菱
    kServiceBrandTypeSanYo,     //三洋
    kServiceBrandTypeYingYan,   //迎燕
    kServiceBrandTypeOther      //其它
};

//品牌组
typedef NS_ENUM(NSInteger, kServiceBrandGroup)
{
    kServiceBrandGroupPrimary,  // 长虹、启客、三洋、迎燕
    kServiceBrandGroupLetv,     // 乐视
    kServiceBrandGroupMeLing,   // 美菱
    kServiceBrandGroupOther,    // 其它
    kServiceBrandGroupSmartMi,  // 智米
};

#pragma mark - 产品类型

typedef NS_ENUM(NSInteger, kProductType)
{
    kProductTypeChangHongTV,    //长虹电视
    kProductTypeChangHongAirConditioning,   //长虹空调
    kProductTypeChiqTV,    //长虹启客电视
    kProductTypeChiqAirConditioning,   //长虹启客空调
    kProductTypeSanYoTV,    //三洋电视
    kProductTypeYingYanAirConditioning, //迎燕空调
    kProductTypeOther   //其它

    //此外还支持乐视，乐视产品单独处理，不分类于此处
};

//搜索工单的组类
typedef NS_ENUM(NSInteger, kSearchOrderGroupType)
{
    kSearchOrderGroupTypeAll = 0,   //所有工单
    kSearchOrderGroupTypeUnfinish,  //未结工单
    kSearchOrderGroupTypeFinished   //已结工单
};

//资源上传到七牛云的状态
typedef NS_ENUM(NSInteger, kResourceUploadStatus)
{
    kResourceUploadStatusNotUpload = 0, //未上传的
    kResourceUploadStatusUploading,     //上传至七牛云中
    kResourceUploadStatusFailure,       //上传至七牛云失败
    kResourceUploadStatusSuccess,       //上传至七牛云成功
    kResourceUploadStatusSaveFailure,   //保存到应用服务器失败
    kResourceUploadStatusSaveSuccess    //保存到应用服务器成功
};

//资源上传到七牛云需要做的操作,
typedef NS_ENUM(NSInteger, kResourceUploadAction)
{
    kResourceUploadActionNothingToDo,   //nothing to do
    kResourceUploadActionTakePicture,   //拍照, step1
    kResourceUploadActionCacheToLocal,  //缓存到本地,step2
    kResourceUploadActionGetToken,      //从应用服务器取得上传的Token,step3
    kResourceUploadActionUploadToQiniu, //上传到Qiniu,step4
    kResourceUploadActionSaveToServer   //保存到应用服务器, step5
};
