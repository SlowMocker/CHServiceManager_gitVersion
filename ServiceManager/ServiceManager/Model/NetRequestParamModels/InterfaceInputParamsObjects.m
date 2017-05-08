//
//  InterfaceInputParamsObjects.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-11.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "InterfaceInputParamsObjects.h"

#pragma mark - Part 1 , Common Interface Params

@implementation GetOrderDetailsInputParams
@end

@implementation GetDeviceInfosInputParams
@end

@implementation StreetListInputParams
@end

@implementation LoginInputParams
@end

@implementation ChangePasswordInputParams
@end

@implementation ChangeUserInfoInputParams
@end

@implementation DeleteRepairerInputParams
@end

@implementation FacilitatorOrderListInPutParams
@end

@implementation SpecialFinishBillInputParams
@end

@implementation RepairerPartListInputParams
@end

@implementation RepairerPartGetInputParams
@end

@implementation GetPartsInfoInputParams
@end

@implementation RepairerAddPartInputParams
@end

@implementation RepairerDeletePartInputParams
@end

@implementation RepairerUpdatePartInputParams
@end

@implementation RepairerPartTypesInputParams
@end

@implementation RepairerSelectPartsInputParams
@end

@implementation ServiceImproveListInPutParams
@end

@implementation SupporterOrderListInPutParams
@end

@implementation SupporterAcceptInPutParams
@end

@implementation QueryActivityContentDetailInputParams
@end

@implementation WeixinCommentQrCodeInputParams
@end

@implementation ExtendPayOrderInfoInputParams
@end

@implementation SaveImageInfosInputParams
@end

@implementation GetEngneerListInputParams
@end

@implementation ApplySupportHelpInputParams
@end

@implementation GetRepairerListInputParams
@end

@implementation AssignEngineerInputParams
@end

@implementation QueryBulletListInputParams
@end

@implementation QueryBulletinDetailsInputParams
@end

@implementation SubmitFeedbackInputParams
@end

@implementation AppointmentOrderInputParams
@end

@implementation ChangeAppointmentOrderInputParams
@end

@implementation NewRepairerInputParams
@end

@implementation DeleteFeeOrderInputParams
@end

@implementation DeleteAllFeeOrderInputParams
@end

@implementation SyncFeeBillListInputParams
@end

@implementation QueryFeeBillStatusInputParams
@end

@implementation ExpenseListInputParams
@end

@implementation EditFeeOrderInputParams
@end

@implementation RepairerAppointmentOrderInputParams
@end

@implementation ConfirmSupportInputParams
@end

@implementation RepairerMangerListInputParams
@end

@implementation PartTracklistInputParams
@end

@implementation SetPartTraceStatusInputParams
@end

@implementation AgreeUrgeInputParams
@end

@implementation RepairSignInInputParams
@end

@implementation MachineCategoryInputParams
@end

@implementation JdIdentifyImageUploadStatusInputParams
@end

@implementation RepairOrderListInPutParams
@end

@implementation FinishBillInputParams
@end

@implementation SearchOrdersInputParams
@end

@implementation RefuseOrderInputParams
@end

@implementation RepairRefuseOrderInputParams
@end

@implementation SingleExtendOrderEditInputParams
@end

@implementation ExtendOrderListInputParams
@end

@implementation DeleteExtendOrderInputParams
@end

@implementation ExtendOrderDetailsInputParams
@end

@implementation FindMachineModelInputParams
@end

@implementation MutiExtendOrderEditInputParams
@end

#pragma mark - Part 2 , Letv Interface Params

@implementation LetvGetRepairerListInputParams
@end

@implementation LetvAssignEngineerInputParams
@end

@implementation LetvFacilitatorOrderListInPutParams
@end

@implementation LetvRefuseOrderInputParams
@end

@implementation LetvGetOrderDetailsInputParams
@end

@implementation LetvConfirmSupportInputParams
@end

@implementation LetvSupporterOrderListInPutParams
@end

@implementation LetvRepairOrderListInPutParams
@end

@implementation LetvRepairRefuseOrderInputParams
@end

@implementation LetvSupporterAcceptInPutParams
@end

@implementation LetvAppointmentOrderInputParams
@end

@implementation LetvChangeAppointmentOrderInputParams
@end

@implementation LetvRepairerAppointmentOrderInputParams
@end

@implementation LetvFinishBillInputParams
@end

@implementation LetvSpecialFinishBillInputParams
@end

@implementation LetvSearchOrdersInputParams
@end

@implementation LetvAgreeUrgeInputParams
@end

@implementation LetvRepairSignInInputParams
@end

@implementation LetvFindMachineModelInputParams
@end

@implementation LetvExpenseListInputParams
@end

@implementation LetvEditFeeOrderInputParams
-(instancetype)initWithEditFeeOrderInputParams:(EditFeeOrderInputParams*)feeItem
{
    self =[super init];
    if (self) {
        self.Id = feeItem.expenseId;
        self.bomCode = feeItem.orderedProd;
        self.Description = feeItem.prodDescription;
        self.quantity = feeItem.quantity;
        self.unitPrice = feeItem.netValue;
        self.receiptNum = feeItem.zzfld00002v;
        self.classify = feeItem.zzfld00005e;
//        self.handleCode;//处理代码
//        self.letvCode;//乐视代码
//        self.softwareVersion;//软件版本
//        self.contractNum;//延保合同号
        if ([feeItem.itmType isEqualToString:@"ZRVW"]) {
            self.itmType = @"ZRV1";
        }else {
            self.itmType = feeItem.itmType;
        }
        self.dispatchInfoId = feeItem.dispatchinfoId;
        self.objectId = feeItem.objectId;
    }
    return self;
}
@end

@implementation LetvDeleteFeeOrderInputParams
@end

@implementation LetvDeleteAllFeeOrderInputParams
@end

@implementation LetvGetEngneerListInputParams
@end

@implementation LetvGetFeeItemCountInputParams
@end

@implementation LetvApplySupportHelpInputParams
@end

@implementation LetvQueryBomCodesInputParams
@end

#pragma mark
#pragma mark 智米

#pragma mark
#pragma mark __通用
@implementation SmartMiGetRepairerListInputParams
@end

@implementation SmartMiAssignEngineerInputParams
@end

@implementation SmartMiRepairSignInInputParams
@end

@implementation SmartMiGetOrderDetailsInputParams
@end

#pragma mark
#pragma mark __服务商

@implementation SmartMiFacilitatorOrderListInPutParams
@end

@implementation SmartMiFacilitatorRefuseOrderInputParams
@end

@implementation SmartMiFacilitatorAppointmentOrderInputParams
@end

@implementation SmartMiFacilitatorChangeAppointmentOrderInputParams
@end

#pragma mark
#pragma mark __维修工
@implementation SmartMiRepairOrderListInPutParams
@end

@implementation SmartMiRepairRefuseOrderInputParams
@end

@implementation SmartMiRepairerAppointmentOrderInputParams
@end

@implementation SmartMiRepairerAgreeOrderUrgeInputParams
@end

@implementation SmartMiRepairerQueryAircraftBrandInputParams
@end

@implementation SmartMiRepairerQueryFuzzyAircraftInputParams
@end

@implementation SmartMiRepairerFinishWorkInputParams
@end

@implementation SmartMiRepairerCancelWorkInputParams
@end

@implementation SmartMiRepairerQueryList4RepairmanByObjectidInputParams
@end

@implementation SmartMiRepairerSaveImageUrlInputParams
@end
