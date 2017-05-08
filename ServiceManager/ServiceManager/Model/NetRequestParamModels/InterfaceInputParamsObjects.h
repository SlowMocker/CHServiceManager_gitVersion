//
//  InterfaceInputParamsObjects.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-11.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigItemInfo.h"

/**
 *  网络接口输入参数列表对象化
 */

#pragma mark - Part 1 , Common Interface Params

@interface GetOrderDetailsInputParams : NSObject
@property(nonatomic, copy)NSString *object_id; //订单号
@end

@interface GetDeviceInfosInputParams : NSObject
@property(nonatomic, copy)NSString *machinemodel; //内机机号
@end

@interface StreetListInputParams : NSObject
@property(nonatomic, copy)NSString *regiontxt;//省
@property(nonatomic, copy)NSString *city1;//市
@property(nonatomic, copy)NSString *city2;//区县
@property(nonatomic, copy)NSString *street;//街道
@end

@interface LoginInputParams : NSObject
@property(nonatomic, copy)NSString *userid;
@property(nonatomic, copy)NSString *password;
@property(nonatomic, copy)NSString *userrole;//kUserRoleType str
@property(nonatomic, copy)NSString *type;       //"IOS"
@end

@interface ChangePasswordInputParams:NSObject
@property(nonatomic, copy)NSString *repairmanid;
@property(nonatomic, copy)NSString *oldpassword;
@property(nonatomic, copy)NSString *newpassword;
@end

@interface ChangeUserInfoInputParams:NSObject
@property(nonatomic, copy)NSString *repairmanid;
@property(nonatomic, copy)NSString *telephone;
@property(nonatomic, copy)NSString *memo;//（当维修人员为自建中心的时候，需要添加文本备注其在长虹的统一员工编号
@end

@interface DeleteRepairerInputParams : NSObject
@property(nonatomic, copy)NSString *repairmanid;
@end

@interface GetEngneerListInputParams : NSObject
@property(nonatomic, copy)NSString *object_id;
@end

@interface ApplySupportHelpInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//订单号(工单单号)
@property(nonatomic, copy)NSString *workerId;//维修工id
@property(nonatomic, copy)NSString *supporterId;//技术支持人员id
@end

@interface GetRepairerListInputParams : NSObject
@property(nonatomic, copy)NSString *object_id;
@end

@interface AssignEngineerInputParams : NSObject
@property(nonatomic, copy)NSString *object_id;
@property(nonatomic, copy)NSString *repairmanid;
@end

@interface QueryBulletListInputParams : NSObject
@property(nonatomic, copy)NSString *pagenow;
@end

@interface QueryBulletinDetailsInputParams : NSObject
@property(nonatomic, copy)NSString *noticeId;
@end

@interface SubmitFeedbackInputParams : NSObject
@property(nonatomic, copy)NSString *feedbackDescription;
@end

@interface AppointmentOrderInputParams : NSObject
@property(nonatomic, copy)NSString *object_id;  //订单号
@property(nonatomic, copy)NSString *flag;   //	0成功,1未成功
@property(nonatomic, copy)NSString *date_yy; //预约时间,成功时必输YYYYMMDDhhmmss
@property(nonatomic, copy)NSString *reason; //未成功原因（主数据）
@property(nonatomic, copy)NSString *memo;   //备注
@end

@interface ChangeAppointmentOrderInputParams : NSObject
@property(nonatomic, copy)NSString *object_id;  //订单号
@property(nonatomic, copy)NSString *date_gy; //YYYYMMDDhhmmss
@property(nonatomic, copy)NSString *memo;   //备注
@end

@interface NewRepairerInputParams : NSObject
@property(nonatomic, copy)NSString *partner;//服务商账号
@property(nonatomic, copy)NSString *username;//	维修工姓名
@property(nonatomic, copy)NSString *telephone;//电话号码
@property(nonatomic, copy)NSString *memo;//	备注(员工工号)
@end

@interface DeleteFeeOrderInputParams : NSObject
@property(nonatomic, copy)NSString *expenseId;//主键ID
@property(nonatomic, copy)NSString *objectId;//工单表
@end

@interface DeleteAllFeeOrderInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单表
@property(nonatomic, copy)NSString *itmType;//项目类别（保外费用：ZRVW:智能产品：ZPRV）

@end

@interface SyncFeeBillListInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单表
@end

@interface QueryFeeBillStatusInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单表
@end

@interface EditFeeOrderInputParams : NSObject
@property(nonatomic, copy)NSString *expenseId;//费用表ID，主键
@property(nonatomic, copy)NSString *objectId;//工单表objectid
@property(nonatomic, copy)NSString *dispatchinfoId;//工单表ID
@property(nonatomic, copy)NSString *orderedProd;//服务物料代码
@property(nonatomic, copy)NSString *prodDescription;//智能产品描述
@property(nonatomic, copy)NSString *itmType;//项目类别（保外费用：ZRVW:智能产品：ZPRV）
@property(nonatomic, copy)NSString *quantity;//数量
@property(nonatomic, copy)NSString *netValue;//金额
@property(nonatomic, copy)NSString *zzfld00002v;//收据号
@property(nonatomic, copy)NSString *zzfld00005e;//智能产品分类
@property(nonatomic, copy)NSString *operate_type;//操作类型（-2：新增；-3：更新）
@end

@interface RepairerAppointmentOrderInputParams : NSObject
@property(nonatomic, copy)NSString *object_id;//订单号
@property(nonatomic, copy)NSString *flag;//0成功,1失败
@property(nonatomic, copy)NSString *appointmenttime;//YYYYMMDDhhmmss
@property(nonatomic, copy)NSString *reason;//预约失败理由
@property(nonatomic, copy)NSString *memo;//备注
@end

@interface ConfirmSupportInputParams : NSObject
@property(nonatomic, copy)NSString *supportInfoId;//技术支持表id
@property(nonatomic, copy)NSString *content;//技术确认内容
@property(nonatomic, copy)NSString *score;//分数
@end

@interface RepairerMangerListInputParams : NSObject
@property(nonatomic, copy)NSString *partner;
@end

@interface PartTracklistInputParams : NSObject
@property(nonatomic, copy)NSString *repairmanid;
@property(nonatomic, copy)NSString *pagenow;
@end

@interface SetPartTraceStatusInputParams : NSObject
@property(nonatomic, copy)NSString *dispatchparts_id;
@property(nonatomic, copy)NSString *puton_status;
@property(nonatomic, copy)NSString *operate_type; //-1删除,-2新增,-3更新, -4添加条码、-5修改条码不改状态
@property(nonatomic, copy)NSString *zzfld00002s;    //备件条码
@end

@interface ExpenseListInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单号
@property(nonatomic, copy)NSString *itmType;//费用项目类别(ZRVW 服务物料-保外费用ZPRV 智能产品销售项目)
@end

@interface AgreeUrgeInputParams : NSObject
@property(nonatomic, copy)NSString *object_id;
@end

@interface RepairSignInInputParams : NSObject
@property(nonatomic, copy)NSString *object_id;//订单号
@property(nonatomic, copy)NSString *repairmanid;//	维修工编号
@property(nonatomic, copy)NSString *lo;//	经度
@property(nonatomic, copy)NSString *la;//	纬度
@property(nonatomic, copy)NSString *arrive_address;//	上门地址
@property(nonatomic, copy)NSString *postype;//	定位类型：GPS定位、基站定位
@end

@interface MachineCategoryInputParams : NSObject
@property(nonatomic, copy)NSString *machinemodel;//主机号（或空调外机号）
@property(nonatomic, copy)NSString *product_flag;//设备类型(0空调、1其它，如彩电)
@end

@interface FinishBillInputParams : NSObject
@property(nonatomic, copy)NSString *object_id;//订单编号
@property(nonatomic, copy)NSString *repairmanid;//维修人员ID
@property(nonatomic, copy)NSString *faultexpression;//故障现象
@property(nonatomic, copy)NSString *repairdescribe;//维修措施
@property(nonatomic, copy)NSString *isscancode;  // 是否扫描0否， 1是
@property(nonatomic, copy)NSString *machinemodel;  //主机号（或空调外机号）
@property(nonatomic, copy)NSString *machinemodel2;  //空调内机号
@property(nonatomic, copy)NSString *brand;// 品牌
@property(nonatomic, copy)NSString *category;// 品类
@property(nonatomic, copy)NSString *buytime;  //购机时间 YYYYMMDD
@property(nonatomic, copy)NSString *type;  //保内或保外
@property(nonatomic, copy)NSString *name;// 用户名称
@property(nonatomic, copy)NSString *user_phone;// 用户电话（多个用逗号隔开）
@property(nonatomic, copy)NSString *street;//街道
@property(nonatomic, copy)NSString *detailedaddress;//详细地址
@property(nonatomic, copy)NSString *increasebusiness ;//增值业务
@property(nonatomic, copy)NSString *sparepart;//备件， 逗号分隔
@property(nonatomic, copy)NSString *isturnovercontract;//是否延保合同
@property(nonatomic, copy)NSString *contractno;// 合同号
@property(nonatomic, copy)NSString *turnoverreason;// 成交原因
@property(nonatomic, copy)NSString *warrantytime;// 延保时间YYYYMMDD
@property(nonatomic, copy)NSString *bugprice;// 购机价格
@property(nonatomic, copy)NSString *pricerange;// 价格区间
@property(nonatomic, copy)NSString *note;//合同备注
@property(nonatomic, copy)NSString *state;//0完工1未完工
@property(nonatomic, copy)NSString *failid;//失败编码（原因）
@property(nonatomic, copy)NSString *memo;//未完工描述，备注
@property(nonatomic, copy)NSString *zzfld00000m; //电商订单号
@property(nonatomic, copy)NSString *zzfld00002r;//京东鉴定结果
@property(nonatomic, copy)NSString *product_id; //机型
@property(nonatomic, copy)NSString *zzfld00005y;//故障处理方式及部位
@property(nonatomic, copy)NSString *zzfld0000;//销售活动
@property(nonatomic, copy)NSString *zzfld0001;//活动内容
@property(nonatomic, copy)NSString *weChatVisit;//微信回访（0：否；1：是）
@property(nonatomic, copy)NSString *isIntroduce;//已介绍清洗服务（0：否；1：是）
@property(nonatomic, copy)NSString *isDemonstrate;//已演示电视网络功能（0：否；1：是）
@end

@interface SpecialFinishBillInputParams : NSObject
@property(nonatomic, copy)NSString *objectid;//工单号
@property(nonatomic, copy)NSString *brand;//品牌
@property(nonatomic, copy)NSString *category;//品类
@property(nonatomic, copy)NSString *type;// 保内或保外
@property(nonatomic, copy)NSString *repairdescribe;//维修措施
@property(nonatomic, copy)NSString *memo;//	工单备注
@property(nonatomic, copy)NSString *zzfld00004r;//保外流失原因
@property(nonatomic, copy)NSString *zzfld00005x;//重单编号
@property(nonatomic, copy)NSString *zzfld00002r;//京东鉴定结果
@property(nonatomic, copy)NSString *zzfld00005y;//故障处理方式及部位
@end

@interface JdIdentifyImageUploadStatusInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单号
@property(nonatomic, copy)NSString *isupload;//是否上传京东检查单
@end

@interface RepairOrderListInPutParams : NSObject
@property(nonatomic, copy)NSString *repairmanid;
@property(nonatomic, copy)NSString *type_id;
@property(nonatomic, copy)NSString *pagenow;
@property(nonatomic, copy)NSString *brands;//品牌（“,”分隔）
@property(nonatomic, copy)NSString *productTypes;//产品大类（“,”分隔）
@property(nonatomic, copy)NSString *orderTypes;//订单类型:ZRA1新机安装；OTHER 上门维修（“,”分隔）

@end

@interface RepairerSelectPartsInputParams : NSObject
@property(nonatomic, copy)NSString *querystep;//	步骤编号(10)
@property(nonatomic, copy)NSString *mac_product_id;//	机型
@property(nonatomic, copy)NSString *zzfld000003;//	产品大类,不再使用
@end

@interface RepairerPartTypesInputParams : NSObject
@property(nonatomic, copy)NSString *querystep;//	步骤编号(20)
@property(nonatomic, copy)NSString *mac_product_id;//	机型
@property(nonatomic, copy)NSString *zzfld000003;//	产品大类,不再使用
@property(nonatomic, copy)NSString *screen_model;
@end

@interface RepairerPartListInputParams : NSObject
@property(nonatomic, copy)NSString *querystep;//	步骤编号(30)
@property(nonatomic, copy)NSString *mac_product_id;//	机号
@property(nonatomic, copy)NSString *zzfld000003;//	产品大类,不再使用
@property(nonatomic, copy)NSString *screen_model;
@property(nonatomic, copy)NSString *part_name;  //组件类别
@end

@interface RepairerPartGetInputParams : NSObject
@property(nonatomic, copy)NSString *querystep;//	步骤编号(40)
@property(nonatomic, copy)NSString *mac_product_id;//机型物料
@property(nonatomic, copy)NSString *part_product_id;//备件物料
@end

@interface GetPartsInfoInputParams : NSObject
@property(nonatomic, copy)NSString *partsBarcode;//机号
@end

@interface RepairerAddPartInputParams : NSObject
@property(nonatomic, copy)NSString *operate_type;//-2新增
@property(nonatomic, copy)NSString *object_id;//工单号
@property(nonatomic, copy)NSString *parts_maininfo_id;//主数据表id
@property(nonatomic, copy)NSString *parts_bominfo_id;//Bom表id
@property(nonatomic, copy)NSString *putoff_part_matno;//换下件物料
@property(nonatomic, copy)NSString *putoff_part_number;//换下件数量
@property(nonatomic, copy)NSString *putoff_status;//换下件状态，默认1创建
@property(nonatomic, copy)NSString *puton_part_matno;//换上件物料
@property(nonatomic, copy)NSString *puton_part_number;//换上件数量
@property(nonatomic, copy)NSString *puton_status;//换上件状态
@end

@interface RepairerDeletePartInputParams : NSObject
@property(nonatomic, copy)NSString *operate_type;//	-1删除
@property(nonatomic, copy)NSString *dispatchparts_id;//	主数据表id
@end

@interface RepairerUpdatePartInputParams : NSObject
@property(nonatomic, copy)NSString *operate_type;//	-3更新
@property(nonatomic, copy)NSString *dispatchparts_id;//	工单备件表id
@property(nonatomic, copy)NSString *puton_status;//	换上件状态
@end

@interface FacilitatorOrderListInPutParams : NSObject
@property(nonatomic, copy)NSString *partner;
@property(nonatomic, copy)NSString *status;
@property(nonatomic, copy)NSString *pagenow;
@property(nonatomic, copy)NSString *brands;//品牌（“,”分隔）
@property(nonatomic, copy)NSString *productTypes;//产品大类（“,”分隔）
@property(nonatomic, copy)NSString *orderTypes;//订单类型:ZRA1新机安装；OTHER 上门维修（“,”分隔）
@end

@interface ServiceImproveListInPutParams : NSObject
@property(nonatomic, copy)NSString *partner;
@end

@interface SupporterOrderListInPutParams : NSObject
@property(nonatomic, copy)NSString *supporterId;
@property(nonatomic, copy)NSString *status;
@property(nonatomic, copy)NSString *pagenow;
@end

@interface SupporterAcceptInPutParams : NSObject
@property(nonatomic, copy)NSString *supportId;
@end

@interface QueryActivityContentDetailInputParams : NSObject
@property(nonatomic, copy)NSString *zzfld0001;
@end

@interface WeixinCommentQrCodeInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单号;
@end

@interface ExtendPayOrderInfoInputParams : NSObject
@property(nonatomic, copy)NSString *tempNum;//临时延保号
@end

@interface SaveImageInfosInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;
@property(nonatomic, copy)NSString *imageType;//（1：设备；2：发票）
@property(nonatomic, copy)NSString *imageName;//照片名称（devicePicture1：设备照片1；devicePicture2：设备照片2；invoicePicture1：发票照片1）
@property(nonatomic, copy)NSString *imageUrl;//照片地址
@end

@interface RepairRefuseOrderInputParams : NSObject
@property(nonatomic, copy)NSString *object_id; //订单号
@property(nonatomic, copy)NSString *isreceivesign;//0:接受, 1:拒绝
@property(nonatomic, copy)NSString *declinefounid;//拒绝编码（理由）（主数据）
@property(nonatomic, copy)NSString *memo;//备注
@end

@interface SearchOrdersInputParams : NSObject
@property(nonatomic, copy)NSString *repairmanId;//维修工编号
@property(nonatomic, copy)NSString *objectId;//工单objectId
@property(nonatomic, copy)NSString *isFinishedOrder;//"0"：未完工，"1"：已完工，"":所有
@end

@interface RefuseOrderInputParams : NSObject
@property(nonatomic, copy)NSString *object_id; //订单号
@property(nonatomic, copy)NSString *flag;//0:接受, 1:拒绝
@property(nonatomic, copy)NSString *reason;//拒绝编码（理由）（主数据）
@property(nonatomic, copy)NSString *memo;//备注
@end

//延保列表
@interface ExtendOrderListInputParams : NSObject
@property(nonatomic, copy)NSString *userId; //登录用户userid
@property(nonatomic, copy)NSString *pageNow;//页码pageNow=1开始，每页10条）
@property(nonatomic, copy)NSString *type;
@end

@interface DeleteExtendOrderInputParams : NSObject
@property(nonatomic, copy)NSString *tempNum; //临时延保号
@end

@interface ExtendOrderDetailsInputParams : NSObject
@property(nonatomic, copy)NSString *extendprdId;//延保id
@end

@interface FindMachineModelInputParams : NSObject
@property(nonatomic, copy)NSString *machinetext;
@end

//单品延保
@interface SingleExtendOrderEditInputParams : NSObject
@property(nonatomic, copy)NSString *extendprdId;//延保id
@property(nonatomic, copy)NSString *customerId;//	客户id
@property(nonatomic, copy)NSString *userId;//	维修工userid
@property(nonatomic, copy)NSString *serverId;//	创建用户服务商id
@property(nonatomic, copy)NSString *reason;//	成交原因（代码）
@property(nonatomic, copy)NSString *contractNum;//	合同号
@property(nonatomic, copy)NSString *signDate;//	签字日期yyyy-MM-dd
@property(nonatomic, copy)NSString *extendLife;//延保年限YBTV_101, YBTV_102, YBTV_103
@property(nonatomic, copy)NSString *zzfld00000e;//购机门店
@property(nonatomic, copy)NSString *priceRange;//	价格区间
@property(nonatomic, copy)NSString *Description;//	合同描述
@property(nonatomic, copy)NSString *objectId;//	工单号
@property(nonatomic, copy)NSString *sysContractNum;//	订单号
@property(nonatomic, copy)NSString *cusName;//	客户姓名
@property(nonatomic, copy)NSString *cusTelNumber;//	客户电话1
@property(nonatomic, copy)NSString *cusMobNumber;//	客户电话2
@property(nonatomic, copy)NSString *province;//	省
@property(nonatomic, copy)NSString *city;//	市
@property(nonatomic, copy)NSString *town;//	区
@property(nonatomic, copy)NSString *street;//	街道
@property(nonatomic, copy)NSString *detailAddress;//	详细地址
@property(nonatomic, copy)NSString *type;//	类型1单品延保，2家多保
@property(nonatomic, copy)NSString *zzfld000000;//品牌
@property(nonatomic, copy)NSString *zzfld000003v;//其他品牌
@property(nonatomic, copy)NSString *zzfld000001;//品类
@property(nonatomic, copy)NSString *zzfld00000q;//机型
@property(nonatomic, copy)NSString *zzfld00002i;//购买日期
@property(nonatomic, copy)NSString *zzfld00000b;//机号(主机/内机条码)
@property(nonatomic, copy)NSString *buyprice;//购机价格
@property(nonatomic, copy)NSString *factoryWarrantyDue;//厂保到期日期
@property(nonatomic, copy)NSString *status;

//电子延保适用
@property(nonatomic, copy)NSString *tempNum;//临时延保号（由APP生成并且唯一）
@property(nonatomic, copy)NSString *econtract;//电子合同（0：否；1：是。电子合同传值1）
@end

//家多保
@interface MutiExtendOrderEditInputParams : NSObject
@property(nonatomic, copy)NSString *extendprdId;//延保id
@property(nonatomic, copy)NSString *customerId;//客户id
@property(nonatomic, copy)NSString *userId;//	维修工userid
@property(nonatomic, copy)NSString *serverId;//	创建用户服务商id
@property(nonatomic, copy)NSString *reason;//	成交原因（代码）
@property(nonatomic, copy)NSString *contractNum;//	合同号
@property(nonatomic, copy)NSString *signDate;//	签字日期yyyy-MM-dd
@property(nonatomic, copy)NSString *extendLife;//延保年限,YBQJB_101; 一年YBQJB_102, YBQJB_103
@property(nonatomic, copy)NSString *Description;//	合同描述
@property(nonatomic, copy)NSString *objectId;//	工单号
@property(nonatomic, copy)NSString *sysContractNum;//	订单号
@property(nonatomic, copy)NSString *cusName;//	客户姓名
@property(nonatomic, copy)NSString *cusTelNumber;//	客户电话
@property(nonatomic, copy)NSString *cusMobNumber;//	客户电话
@property(nonatomic, copy)NSString *province;//	省
@property(nonatomic, copy)NSString *city;//	市
@property(nonatomic, copy)NSString *town;//	区
@property(nonatomic, copy)NSString *street;//	街道
@property(nonatomic, copy)NSString *detailAddress;//	详细地址
@property(nonatomic, copy)NSString *type;//	类型 1单品延保，2家多保
@property(nonatomic, copy)NSString *productCount;//	产品数量
@property(nonatomic, copy)NSString *productInfos;//	产品列表, ExtendProductContent
@property(nonatomic, copy)NSString *status;

//电子延保适用
@property(nonatomic, copy)NSString *tempNum;//临时延保号（由APP生成并且唯一）
@property(nonatomic, copy)NSString *econtract;//电子合同（0：否；1：是。电子合同传值1）
@end

#pragma mark - Part 2 , Letv Interface Params

@interface LetvGetRepairerListInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;
@end

@interface LetvAssignEngineerInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;
@property(nonatomic, copy)NSString *repairManId;
@end

@interface LetvFacilitatorOrderListInPutParams : NSObject
@property(nonatomic, copy)NSString *serverId;
@property(nonatomic, copy)NSString *status;
@property(nonatomic, copy)NSString *currentPage;
@end

@interface LetvRefuseOrderInputParams : NSObject
@property(nonatomic, copy)NSString *objectId; //订单号
@property(nonatomic, copy)NSString *flag;//0:接受, 1:拒绝
@property(nonatomic, copy)NSString *reason;//拒绝编码（理由）（主数据）
@end

@interface LetvGetOrderDetailsInputParams : NSObject
@property(nonatomic, copy)NSString *objectId; //订单号
@end

@interface LetvConfirmSupportInputParams : NSObject
@property(nonatomic, copy)NSString *supportInfoId;//技术支持表id
@property(nonatomic, copy)NSString *content;//技术确认内容
@property(nonatomic, copy)NSString *score;//分数
@end

@interface LetvSupporterOrderListInPutParams : NSObject
@property(nonatomic, copy)NSString *supporterId;
@property(nonatomic, copy)NSString *status;
@property(nonatomic, copy)NSString *currentPage;
@end

@interface LetvRepairOrderListInPutParams : NSObject
@property(nonatomic, copy)NSString *repairManId;
@property(nonatomic, copy)NSString *status; //工单状态
@property(nonatomic, copy)NSString *currentPage;
@end

@interface LetvRepairRefuseOrderInputParams : NSObject
@property(nonatomic, copy)NSString *objectId; //订单号
@property(nonatomic, copy)NSString *isreceivesign;//0:接受, 1:拒绝
@property(nonatomic, copy)NSString *declinefounid;//拒绝编码（理由）（主数据）
@property(nonatomic, copy)NSString *realname;//维修工真实姓名
@property(nonatomic, copy)NSString *memo;//备注
@end

@interface LetvSupporterAcceptInPutParams : NSObject
@property(nonatomic, copy)NSString *supportInfoId;
@end

@interface LetvAppointmentOrderInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单号
@property(nonatomic, copy)NSString *flag;//预约成功与否标志（0：成功；1：失败。）
@property(nonatomic, copy)NSString *apptDate;//预约时间（yyyyMMddHHmmss）
@property(nonatomic, copy)NSString *statusL1;//一级工单状态
@property(nonatomic, copy)NSString *statusL2;//二级工单状态
@property(nonatomic, copy)NSString *faultCode;//故障代码
@property(nonatomic, copy)NSString *faultDesc;//故障描述
@property(nonatomic, copy)NSString *handleResult;//处理结果
@end

@interface LetvChangeAppointmentOrderInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//订单号
@property(nonatomic, copy)NSString *statusL1;//一级工单状态
@property(nonatomic, copy)NSString *statusL2;//二级工单状态
@property(nonatomic, copy)NSString *faultCode;//故障代码
@property(nonatomic, copy)NSString *faultDesc;//故障现象
@property(nonatomic, copy)NSString *handleResult;//处理结果
@property(nonatomic, copy)NSString *lastApptDate;//二次预约时间yyyyMMddHHmmss
@end

@interface LetvRepairerAppointmentOrderInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单号
@property(nonatomic, copy)NSString *flag;//预约成功与否标志（0：成功；1：失败。）
@property(nonatomic, copy)NSString *apptDate;//预约时间（yyyyMMddHHmmss）
@property(nonatomic, copy)NSString *statusL1;//一级工单状态
@property(nonatomic, copy)NSString *statusL2;//二级工单状态
@property(nonatomic, copy)NSString *faultCode;//故障代码
@property(nonatomic, copy)NSString *faultDesc;//故障描述
@property(nonatomic, copy)NSString *handleResult;//处理结果
@end

@interface LetvSearchOrdersInputParams : NSObject
@property(nonatomic, copy)NSString *repairmanId;//维修工编号
@property(nonatomic, copy)NSString *objectId;//工单objectId
@property(nonatomic, copy)NSString *isFinishedOrder;//"0"：未完工，"1"：已完工，"":所有
@end

@interface LetvSpecialFinishBillInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单号
@property(nonatomic, copy)NSString *repairManId;//维修人员编号
@property(nonatomic, copy)NSString *serviceReqType;//服务请求类型
@property(nonatomic, copy)NSString *brand;//品牌
@property(nonatomic, copy)NSString *productType;//产品大类
@property(nonatomic, copy)NSString *category;//品类
@property(nonatomic, copy)NSString *buyDate;//购机日期（购买日期）yyyyMMdd
@property(nonatomic, copy)NSString *securityLabe;//保内外标志（产品质保）（10：保内；20：保外）
@property(nonatomic, copy)NSString *vipCardActive;//会员卡激活（Y：是；N：否）
@property(nonatomic, copy)NSString *notActiveCause;//未激活原因
@property(nonatomic, copy)NSString *faultHandling;//故障处理(或维修措施)（处理措施）
@property(nonatomic, copy)NSString *statusL1;//一级工单状态
@property(nonatomic, copy)NSString *statusL2;//二级工单状态
@property(nonatomic, copy)NSString *faultCode;//故障代码
@property(nonatomic, copy)NSString *faultDesc;//故障现象
@property(nonatomic, copy)NSString *handleResult;//处理结果
@end

@interface LetvFinishBillInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单号
@property(nonatomic, copy)NSString *repairManId;//维修人员编号
@property(nonatomic, copy)NSString *serviceReqType;//服务请求类型
@property(nonatomic, copy)NSString *brand;//品牌
@property(nonatomic, copy)NSString *productType;//产品大类
@property(nonatomic, copy)NSString *category;//品类
@property(nonatomic, copy)NSString *model;//机型
@property(nonatomic, copy)NSString *macAddress;//MAC地址（12位）
@property(nonatomic, copy)NSString *snCode;//SN编码（19位）
@property(nonatomic, copy)NSString *buyDate;//购机日期（购买日期）yyyyMMdd
@property(nonatomic, copy)NSString *securityLabe;//保内外标志（产品质保）（10：保内；20：保外）
@property(nonatomic, copy)NSString *installWay;//安装方式
@property(nonatomic, copy)NSString *isBearingWall;//是否承重墙（Y：是；N：否；O：其他）
@property(nonatomic, copy)NSString *isBuyRack;//是否购买挂架（是否官方购买挂架）（Y：是；N：否；O：其他）
@property(nonatomic, copy)NSString *network;//家庭网络环境
@property(nonatomic, copy)NSString *invoiceNum;//发票号（发票）
@property(nonatomic, copy)NSString *name;//客户姓名（用户姓名）
@property(nonatomic, copy)NSString *street;//街道
@property(nonatomic, copy)NSString *detailAddr;//详细地址
@property(nonatomic, copy)NSString *phoneNum;//客户电话号码（联系方式）
@property(nonatomic, copy)NSString *vipCardActive;//会员卡激活（0：否；1：是）
@property(nonatomic, copy)NSString *notActiveCause;//未激活原因
@property(nonatomic, copy)NSString *whetherCmpl;//是否完工（0：完工；1：未完工）
@property(nonatomic, copy)NSString *faultHandling;//故障处理(或维修措施)（处理措施）
@property(nonatomic, copy)NSString *statusL1;//一级工单状态
@property(nonatomic, copy)NSString *statusL2;//二级工单状态
@property(nonatomic, copy)NSString *faultCode;//故障代码
@property(nonatomic, copy)NSString *faultDesc;//故障现象
@property(nonatomic, copy)NSString *replPartsName;//更换备件名称
@property(nonatomic, copy)NSString *handleResult;//处理结果

@end

@interface LetvAgreeUrgeInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;
@end

@interface LetvRepairSignInInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单号
@property(nonatomic, copy)NSString *repairManId;//维修人员编号
@property(nonatomic, copy)NSString *longitude;//经度
@property(nonatomic, copy)NSString *latitude;//纬度
@property(nonatomic, copy)NSString *arriveAddress;//上门地址
@property(nonatomic, copy)NSString *posType;//定位类型：GPS定位、基站定位
@end

@interface LetvFindMachineModelInputParams : NSObject
@property(nonatomic, copy)NSString *machineText;//机型描述
@property(nonatomic, copy)NSString *machineBrand;//品牌
@end

@interface LetvExpenseListInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单号
@property(nonatomic, copy)NSString *itmType;//项目类别（ZPRV：智能产品型项目；ZRV1：费用型项目。）
@property(nonatomic, copy)NSString *model;//机型
@end

@interface LetvEditFeeOrderInputParams : NSObject
@property(nonatomic, copy)NSString *Id;//费用表主键ID
@property(nonatomic, copy)NSString *bomCode;//物料代码（产品代码）
@property(nonatomic, copy)NSString *Description;//描述（产品描述）
@property(nonatomic, copy)NSString *handleCode;//处理代码
@property(nonatomic, copy)NSString *letvCode;//乐视代码
@property(nonatomic, copy)NSString *softwareVersion;//软件版本
@property(nonatomic, copy)NSString *contractNum;//延保合同号
@property(nonatomic, copy)NSString *itmType;//项目类别（ZPRV：智能产品行项目；ZRV1：费用行项目。）
@property(nonatomic, copy)NSString *dispatchInfoId;//工单表主键ID
@property(nonatomic, copy)NSString *objectId;//工单号

@property(nonatomic, copy)NSString *quantity;//数量
@property(nonatomic, copy)NSString *unitPrice;//单价
@property(nonatomic, copy)NSString *receiptNum;//收据号
@property(nonatomic, copy)NSString *classify;//智能产品分类

-(instancetype)initWithEditFeeOrderInputParams:(EditFeeOrderInputParams*)input;
@end

@interface LetvDeleteFeeOrderInputParams : NSObject
@property(nonatomic, copy)NSString *expenseId;//主键ID
@property(nonatomic, copy)NSString *objectId;//工单表objectId
@end

@interface LetvDeleteAllFeeOrderInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单表
@property(nonatomic, copy)NSString *itmType;//项目类别（费用：ZRV1:智能产品：ZPRV）
@end

@interface LetvGetEngneerListInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;
@end

@interface LetvGetFeeItemCountInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;
@end

@interface LetvApplySupportHelpInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单号
@property(nonatomic, copy)NSString *workerId;//维修工id
@property(nonatomic, copy)NSString *supporterId;//技术支持人员id
@end

@interface LetvQueryBomCodesInputParams : NSObject
@property(nonatomic, copy)NSString *model; //机型
@end

#pragma mark
#pragma mark 智米接口请求参数模型
////////////////通用////////////////
// 获取维修工列表（用于派工）
@interface SmartMiGetRepairerListInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;
@end

// 派工给服务工程师
@interface SmartMiAssignEngineerInputParams : NSObject
@property(nonatomic, copy)NSString *objectId; // 工单号
@property(nonatomic, copy)NSString *repairManId; // 维修人员编号
@end

// 签到
@interface SmartMiRepairSignInInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//订单号
@property(nonatomic, copy)NSString *repairManId;//	维修工编号
@property(nonatomic, copy)NSString *longitude;//	经度
@property(nonatomic, copy)NSString *latitude;//	纬度
@property(nonatomic, copy)NSString *arriveAddress;//	上门地址
@property(nonatomic, copy)NSString *posType;//	定位类型：GPS定位、基站定位
@end

// 工单详情
@interface SmartMiGetOrderDetailsInputParams : NSObject
@property(nonatomic, copy)NSString *objectId; //订单号
@end



////////////////服务商////////////////
// 获取服务商工单列表
@interface SmartMiFacilitatorOrderListInPutParams : NSObject
@property(nonatomic, copy)NSString *serverId; // 服务商编号
@property(nonatomic, copy)NSString *status; // 工单状态：（见附录表9） [101新工单][102已接受(未派工）][103已派工][104待预约][105待执行][106维修工已拒绝][107维修工已预约][108维修工预约失败][201技术确认][999历史工单]
@property(nonatomic, copy)NSString *currentPage; // 当前页（第一页currentPage =”1”）
@end

// 接受、拒绝订单
@interface SmartMiFacilitatorRefuseOrderInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;  //订单号
@property(nonatomic, copy)NSString *flag; //0:接受, 1:拒绝
@property(nonatomic, copy)NSString *reason; //拒绝编码（理由）（主数据）(可选，拒绝必填)
@end

// 预约提交
@interface SmartMiFacilitatorAppointmentOrderInputParams : NSObject
@property(nonatomic, copy)NSString *objectId; //工单号
@property(nonatomic, copy)NSString *flag; //预约成功与否标志（0：成功；1：失败。）
@property(nonatomic, copy)NSString *apptDate; //预约时间（yyyyMMddHHmmss)
@property(nonatomic, copy)NSString *apptFailCause; //预约失败原因
@property(nonatomic, copy)NSString *apptMemo; //备注
@end

// 改约、二次预约
@interface SmartMiFacilitatorChangeAppointmentOrderInputParams : NSObject
@property(nonatomic, copy)NSString *objectId; // 工单号
@property(nonatomic, copy)NSString *lastApptDate; // 改约（二次预约）时间（yyyyMMddHHmmss）
@property(nonatomic, copy)NSString *apptMemo; // 备注信息
@end


////////////////维修工////////////////

// 获取维修工工单列表
@interface SmartMiRepairOrderListInPutParams : NSObject
//@property(nonatomic, copy)NSString *repairmanid;
//@property(nonatomic, copy)NSString *type_id;
//@property(nonatomic, copy)NSString *pagenow;
//@property(nonatomic, copy)NSString *brands;//品牌（“,”分隔）
//@property(nonatomic, copy)NSString *productTypes;//产品大类（“,”分隔）
//@property(nonatomic, copy)NSString *orderTypes;//订单类型:ZRA1新机安装；OTHER 上门维修（“,”分隔）

@property (nonatomic , copy) NSString *repairManId;/**< 维修工编号 */
@property (nonatomic , copy) NSString *status;/**< 工单状态 */
@property (nonatomic , copy) NSString *currentPage;/**< 当前页 */
@end

// 接受、拒绝订单
@interface SmartMiRepairRefuseOrderInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;  //订单号
@property(nonatomic, copy)NSString *isreceivesign; //0:接受, 1:拒绝
@property(nonatomic, copy)NSString *declinefounid; //拒绝编码（理由）（主数据）
@property(nonatomic, copy)NSString *realname; //维修工真实姓名
@property(nonatomic, copy)NSString *memo; //备注
@end

// 预约提交
@interface SmartMiRepairerAppointmentOrderInputParams : NSObject
@property(nonatomic, copy)NSString *objectId; // 订单号
@property(nonatomic, copy)NSString *flag; // 0成功,1失败
@property(nonatomic, copy)NSString *apptDate; // 预约时间 YYYYMMDDhhmmss
@property(nonatomic, copy)NSString *apptFailCause; // 预约失败理由
@property(nonatomic, copy)NSString *apptMemo; // 备注
@end

// 接受催单
@interface SmartMiRepairerAgreeOrderUrgeInputParams : NSObject
@property(nonatomic, copy)NSString *objectId; // 订单号
@end

// 获取机型品牌
@interface SmartMiRepairerQueryAircraftBrandInputParams : NSObject
@property(nonatomic, copy)NSString *model; // 机型
@property(nonatomic, copy)NSString *flag; // 区分是备件还是机型的标记 （0：备件，1：机型）
@end

// 模糊查询机型
@interface SmartMiRepairerQueryFuzzyAircraftInputParams : NSObject
@property(nonatomic, copy)NSString *machineText; // 机型描述
@property(nonatomic, copy)NSString *machineBrand; // 品牌
@end

// 完工
@interface SmartMiRepairerFinishWorkInputParams : NSObject
@property(nonatomic, copy)NSString *objectId; // 工单号
@property(nonatomic, copy)NSString *repairManId; // 维修人员编号
@property(nonatomic, copy)NSString *brand; // 品牌
@property(nonatomic, copy)NSString *productType; // 产品大类
@property(nonatomic, copy)NSString *category; // 品类
@property(nonatomic, copy)NSString *model; // 机型
@property(nonatomic, copy)NSString *scanHostBarcode; // 手机APP扫描的主（内）机条码
@property(nonatomic, copy)NSString *scanExternalBarCode; // 手机APP扫描的外机条码
@property(nonatomic, copy)NSString *name; // 客户姓名
@property(nonatomic, copy)NSString *street; // 街道（可选）
@property(nonatomic, copy)NSString *detailAddr; // 详细地址
@property(nonatomic, copy)NSString *phoneNum2; // 客户电话号码
@property(nonatomic, copy)NSString *outdoorTemp; // 室外环境温度
@property(nonatomic, copy)NSString *outoTemp; // 室内出风温度
@property(nonatomic, copy)NSString *intoTemp; // 室内进风温度
@property(nonatomic, copy)NSString *runPressure; // 运行压力
@property(nonatomic, copy)NSString *area; // 使用面积
@property(nonatomic, copy)NSString *faultHandling; // 处理措施
@property(nonatomic, copy)NSString *memo; // 完工备注（可选）
@end

// 取消工单
@interface SmartMiRepairerCancelWorkInputParams : NSObject
@property(nonatomic, copy)NSString *objectId; // 工单号
@property(nonatomic, copy)NSString *scanHostBarcode; // 手机APP扫描的主（内）机条码
@property(nonatomic, copy)NSString *scanExternalBarCode; // 手机APP扫描的外机条码
@end

@interface SmartMiRepairerQueryList4RepairmanByObjectidInputParams : NSObject
@property(nonatomic, copy)NSString *repairmanId; // 维修工编号
@property(nonatomic, copy)NSString *objectId; // 工单号
@property(nonatomic, copy)NSString *isFinishedOrder; // 是否完工工单（是否历史工单。0：非完工工单；1：已完工工单；不传值（null或""）：所有工单。）(可选)
@end

@interface SmartMiRepairerSaveImageUrlInputParams : NSObject
@property(nonatomic, copy)NSString *objectId; // 工单号
@property(nonatomic, copy)NSString *imageType; // 照片类型（1：室内机照片；2：用户手机APP的照片；3：室外机照片；4：用户和设备的合照）
@property(nonatomic, copy)NSString *imageUrl; // 照片地址（可选）
@end

////////////////技术支持////////////////
