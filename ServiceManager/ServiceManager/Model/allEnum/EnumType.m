//
//  EnumType.m
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-4-27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "EnumType.h"

NSString *getUserRoleTypeName(kUserRoleType roleType)
{
    NSString *tempStr;

    switch (roleType) {
        case kUserRoleTypeFacilitator://服务商
            tempStr = @"服务商";
            break;
        case kUserRoleTypeRepairer://维修人员
            tempStr = @"维修人员";
            break;
        case kUserRoleTypeDealer://经销商
            tempStr = @"经销商";
            break;
        case kUserRoleTypeBranchManager://分公司经理
            tempStr = @"分公司经理";
            break;
        case kUserRoleTypeSupporter://技术支持人员
            tempStr = @"技术支持人员";
            break;
        case kUserRoleTypeMultiMediaManager://多媒体服务经理
            tempStr = @"多媒体服务经理";
            break;
        default:
            break;
    }
    return tempStr;
}

NSString *getFacilitatorOrderStatusStr(kFacilitatorOrderStatus status)
{
    NSString *tempStr;
    
    switch (status) {
        case kFacilitatorOrderStatusNew:
            tempStr = @"新工单";
            break;
        case kFacilitatorOrderStatusReceived:
            tempStr = @"未派工";
            break;
        case kFacilitatorOrderStatusAssigned:
            tempStr = @"已派工";
            break;
        case kFacilitatorOrderStatusWaitForAppointment:
            tempStr = @"待预约";
            break;
        case kFacilitatorOrderStatusWaitForExecution:
            tempStr = @"待执行";
            break;
        case kFacilitatorOrderStatusRefused:
            tempStr = @"已拒绝";
            break;
        case kFacilitatorOrderStatusAppointed:
            tempStr = @"已预约";
            break;
        case kFacilitatorOrderStatusAppointFailure:
            tempStr = @"预约失败";
            break;
        case kFacilitatorOrderStatusUnfinish:
            tempStr = @"未完工";
            break;
        case kFacilitatorOrderStatusConfirm:
            tempStr = @"技术确认";
            break;
        case kFacilitatorOrderStatusAppointTrace:
            tempStr = @"备件跟踪";
            break;
        case kFacilitatorOrderStatusFinished:
            tempStr = @"历史工单";
            break;
        default:
            break;
    }
    return tempStr;
}

NSString *getRepairerOrderStatusStr(kRepairerOrderStatus status)
{
    NSString *tempStr;
    
    switch (status) {
        case kRepairerOrderStatusNew:
            tempStr = @"新工单";
            break;
        case kRepairerOrderStatusWaitForAppointment:
            tempStr = @"待预约";
            break;
        case kRepairerOrderStatusAppointFailure:
            tempStr = @"预约失败";
            break;
        case kRepairerOrderStatusWaitForExecution :
            tempStr = @"待执行";
            break;
        case kRepairerOrderStatusUnfinish:
            tempStr = @"未完工";
            break;
        case kRepairerOrderStatusConfirm:
            tempStr = @"技术确认";
            break;
        case kRepairerOrderStatusTrace:
            tempStr = @"备件跟踪";
            break;
        case kRepairerOrderStatusFinished:
            tempStr = @"历史工单";
            break;
        default:
            break;
    }
    return tempStr;
}

extern NSString *getHomeSectionItemName(kHomeSectionItem item)
{
    NSString *tempStr = kUnknown;
    
    switch (item) {
        case kHomeSectionItemTools:
            tempStr = @"工具箱";
            break;
        case kHomeSectionItemCommonBrands:
            tempStr = @"长虹、启客、三洋、迎燕等品牌";
            break;
        case kHomeSectionItemLetvBrand:
            tempStr = @"乐视品牌";
            break;
        case kHomeSectionItemMeiningBrand:
            tempStr = @"美菱品牌";
            break;
        case kHomeSectionItemSmartMiBrand:
            tempStr = @"智米品牌";
            break;
    }
    return tempStr;
}

NSString *getHomePadFeatureItemName(kHomePadFeatureItem item)
{
    NSString *tempStr;
    
    switch (item) {
        case kHomePadFeatureItemOrderManage:
            tempStr = @"工单处理";
            break;
        case kHomePadFeatureItemSupport:
            tempStr = @"技术点评";
            break;
        case kHomePadFeatureItemPartTrace:
            tempStr = @"备件跟踪";
            break;
        case kHomePadFeatureItemImprovement:
            tempStr = @"服务改善";
            break;
        case kHomePadFeatureItemTaskManage:
            tempStr = @"任务处理";
            break;
        case  kHomePadFeatureItemExtendService:
            tempStr = @"延保管理";
            break;
        case kHomePadFeatureItemEmployeeManage:
            tempStr = @"员工管理";
            break;
        case kHomePadFeatureItemResource:
            tempStr = @"技术资料";
            break;
        case kHomePadFeatureItemServicePrice:
            tempStr = @"服务价格";
            break;
        case kHomePadFeatureItemTaskOrderHistory:
            tempStr = @"历史工单";
            break;
    }
    return tempStr;
}

NSString *getSupporterOrderStatusStr(kSupporterOrderStatus status)
{
    NSString *tempStr;
    
    switch (status) {
        case kSupporterOrderStatusApply:
            tempStr = @"新任务";
            break;
        case kSupporterOrderStatusReceived:
            tempStr = @"已确认";
            break;
        case kSupporterOrderStatusConfirmed:
            tempStr = @"已点评";
            break;
        default:
            break;
    }
    return tempStr;
}

NSString* getOrderOperationTypeStr(kOrderOperationType type)
{
    NSString *operateName;
    
    switch (type) {
        case kOrderOperationTypeView:
            operateName = @"查看";
            break;
        case kOrderOperationTypeDelete:
            operateName = @"删除";
            break;
        case kOrderOperationTypeAgree:
            operateName = @"接受";
            break;
        case kOrderOperationTypeAssign:
            operateName = @"派工";
            break;
        case kOrderOperationTypeReassign:
            operateName = @"改派";
            break;
        case kOrderOperationTypeExecute:
            operateName = @"执行";
            break;
        case kOrderOperationTypeAppointment:
            operateName = @"预约";
            break;
        case kOrderOperationTypeChangeAppointment:
            operateName = @"改约";
            break;
        case kOrderOperationTypeRefuse:
            operateName = @"拒绝";
            break;
        case kOrderOperationTypeAppointmentAgain:
            operateName = @"改约";
            break;
        case kOrderOperationTypeConfirm:
            operateName = @"确认";
            break;
        case kOrderOperationTypeSpecialFinish:
            operateName = @"特殊\n完工";
            break;
        case kOrderOperationTypeExtend:
            operateName = @"办理\n延保";
            break;
        case kOrderOperationTypeUserComment:
            operateName = @"客户\n点评";
            break;
        case kOrderOperationTypeReceiveAccount:
            operateName = @"收款";
            break;
        case kOrderOperationTypeEdit:
            operateName = @"编辑";
            break;
        default:
            break;
    }
    return operateName;
}

UIColor* getOrderOperationButtonColor(kOrderOperationType type)
{
    NSString *colorHex;
    
    switch (type) {
        case kOrderOperationTypeView:
            colorHex = @"#999999";
            break;
        case kOrderOperationTypeAssign:
        case kOrderOperationTypeAgree:
        case kOrderOperationTypeReassign:
        case kOrderOperationTypeEdit:
            colorHex = @"#0099cc";
            break;
        case kOrderOperationTypeAppointment:
        case kOrderOperationTypeChangeAppointment:
        case kOrderOperationTypeAppointmentAgain:
        case kOrderOperationTypeReceiveAccount:
            colorHex = @"#996699";
            break;
        case kOrderOperationTypeExecute:
        case kOrderOperationTypeRefuse:
        case kOrderOperationTypeDelete:
            colorHex = @"#ff6600";
            break;
        case kOrderOperationTypeSpecialFinish:
        case kOrderOperationTypeExtend:
            colorHex = @"#cc6600";
            break;
        case kOrderOperationTypeUserComment:
            colorHex = @"#1a9bfc";
            break;
        default:
            colorHex = @"#996699";
            break;
    }
    return ColorWithHex(colorHex);
}

NSString *getErrorCodeDescription(kErrorCode errorCode)
{
    NSString *errorDescription = kUnknownErr;

    switch (errorCode) {
        case kErrorCodeNetNotConnect:
            errorDescription = @"网络连接失败";
            break;
        default:
            break;
    }
    return errorDescription;
}

NSString *getOrderTraceStatusById(NSString *orderTraceId)
{
    NSDictionary *retDic = @{
        @"1":@"创建",
        @"2":@"申请",
        @"3":@"组件向上维修",
        @"4":@"审核未通过",
        @"5":@"服务商处理",
        @"6":@"已审核",
        @"7":@"已发货",
        @"8":@"取消",
        @"9":@"收货确认",
        @"10":@"DOA退回",
        @"11":@"DOA鉴定完成"
    };
    return [Util defaultStr:@"备件状态未知" ifStrEmpty:[retDic objForKey:orderTraceId]];
}

NSString *getOrderTraceHandleTypeStrById(kOrderTraceHandleType handleId)
{
    NSString *tempStr;

    switch (handleId) {
        case kOrderTraceHandleTypeReceive:
            tempStr = @"收货";
            break;
        case kOrderTraceHandleTypeDOABack:
            tempStr = @"DOA\n退回";
            break;
        case kOrderTraceHandleTypeEditPart:
            tempStr = @"变更\n条码";
            break;
        default:
            break;
    }
    return tempStr;
}

NSString *getSellFeeListHandleTypeStrById(kSellFeeListHandleType handleId)
{
    NSString *tempStr;
    
    switch (handleId) {
        case kSellFeeListHandleTypeEdit:
            tempStr = @"编辑";
            break;
        case kSellFeeListHandleTypeDelete:
            tempStr = @"删除";
            break;
        default:
            break;
    }
    return tempStr;
}

NSString *getComponentMaintainHandleTypeStrById(kComponentMaintainHandleType handleId)
{
    NSString *tempStr;

    switch (handleId) {
        case kComponentMaintainHandleTypeView:
            tempStr = @"查看";
            break;
        case kComponentMaintainHandleTypeEdit:
            tempStr = @"编辑";
            break;
        case kComponentMaintainHandleTypeDelete:
            tempStr = @"删除";
            break;
        default:
            break;
    }
    return tempStr;
}

NSString *getWarrantyDateStrById(NSString *idStr)
{
    NSDictionary *retDic = @{
         [NSString intStr:kWarrantyDateRangeUnexpired]:@"保内",
         [NSString intStr:kWarrantyDateRangeExpired]:@"保外",
         [NSString intStr:kWarrantyDateRangeExtend]:@"延保"
    };
    return [retDic objForKey:idStr default:kUnknown];
}

NSString *getExtendServiceTypeById(kExtendServiceType extendType)
{
    NSString *tempStr;

    switch (extendType) {
        case kExtendServiceTypeSingle:
            tempStr = @"单品延保";
            break;
        case kExtendServiceTypeMutiple:
            tempStr = @"家多保";
            break;
        default:
            break;
    }
    return tempStr;
}

NSString *getExtendServiceOrderStatusById(NSString* statusId)
{
    NSDictionary *dic = @{
        @"SC10":@"创建",
        @"SC20":@"提交",
        @"SC30":@"回访未通过",
        @"SC40":@"回访通过",
        @"SC50":@"合同生效",
        @"SC60":@"合同作废",
        @"SC70":@"合同终止",
        @"SC21":@"提交作废",
        @"SC55":@"合同已投保"
    };
    return [dic objForKey:statusId];
}

kPriceManageType getPriceManageTypeByCode(NSString *code)
{
    if ([code isEqualToString:@"ZRVW"] || [code isEqualToString:@"ZRV1"]) {
        return kPriceManageTypeService;
    }else if ([code isEqualToString:@"ZPRV"]) {
        return kPriceManageTypeSells;
    }
    return kPriceManageTypeNone;
}

NSString *getAppointmentOperateTypeStr(kAppointmentOperateType type)
{
    NSString *tempStr;

    switch (type) {
        case kAppointmentOperateType1stTime:
            tempStr = @"预约";
            break;
        case kAppointmentOperateType2ndTime:
            tempStr = @"二次预约";
            break;
        case kAppointmentOperateTypeChangeTime:
            tempStr = @"改约";
            break;
        default:
            break;
    }
    return tempStr;
}

NSString *getPriceManageTypeStr(kPriceManageType priceManageType)
{
    NSString *tempStr;
    
    switch (priceManageType) {
        case kPriceManageTypeService:
            tempStr = @"费用管理";
            break;
        case kPriceManageTypeSells:
            tempStr = @"销售费用管理";
            break;
        default:
            break;
    }
    return tempStr;
}


NSString *getDispatchPartStatusById(NSString* statusId)
{
    return getOrderTraceStatusById(statusId);
}

