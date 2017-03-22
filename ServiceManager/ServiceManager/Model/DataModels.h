//
//  DataModels.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-11.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigItemInfo.h"

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

@interface StreetInfo : NSObject
@property(nonatomic, copy)NSString *street;//街道
@end

@interface LoginInputParams : NSObject
@property(nonatomic, copy)NSString *userid;
@property(nonatomic, copy)NSString *password;
@property(nonatomic, copy)NSString *userrole;   //kUserRoleType str
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
@property(nonatomic, copy)NSString *operate_type; //-1删除,-2新增,-3更新
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
@end

@interface JdIdentifyImageUploadStatusInputParams : NSObject
@property(nonatomic, copy)NSString *objectId;//工单号
@property(nonatomic, copy)NSString *isupload;//是否上传京东检查单
@end

@interface RepairOrderListInPutParams : NSObject
@property(nonatomic, copy)NSString *repairmanid;
@property(nonatomic, copy)NSString *type_id;
@property(nonatomic, copy)NSString *pagenow;
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

//备件信息
@interface PartsContentInfo : NSObject
@property(nonatomic, strong)NSObject *partsMainInfo;//备件主数据表对象
@property(nonatomic, copy)NSString *parts_bominfo_id;//备件bom表id
@property(nonatomic, copy)NSString *Id;//备件主数据表id
@property(nonatomic, copy)NSString *product_id;//物料代码
@property(nonatomic, copy)NSString *short_text;//产品描述
@property(nonatomic, copy)NSString *zz0010;//索赔件
@property(nonatomic, copy)NSString *zz0011;//关键件
@property(nonatomic, copy)NSString *zz0017;
@property(nonatomic, copy)NSString *zz0018;
@end

//备件信息
@interface PartMaintainContent : NSObject
@property(nonatomic, copy)NSString *object_id;//工单号
@property(nonatomic, copy)NSString *dispatch_parts_id;//备件?
@property(nonatomic, copy)NSString *parts_bominfo_id;//备件bom表id
@property(nonatomic, copy)NSString *parts_maininfo_id;//备件主数据表id

@property(nonatomic, copy)NSString *puton_part_matno;//换上件ID
@property(nonatomic, copy)NSString *part_text;//换上件名称
@property(nonatomic, copy)NSString *puton_part_number;//换上件数量
@property(nonatomic, copy)NSString *puton_status;//换上件,申请状态(1创建，2申请,3doa)

@property(nonatomic, copy)NSString *putoff_status;//换下件,申请状态(默认1创建)
@property(nonatomic, copy)NSString *putoff_part_matno;//换下件ID
@property(nonatomic, copy)NSString *putoff_part_number;//换下件数量
@property(nonatomic, copy)NSString *putoff_part_text;//换下件名称

@property(nonatomic, copy)NSString *is_send_crm; //是否已同步到CRM,1未同步，2已同步

//local
@property(nonatomic, assign, readonly)BOOL bAffectPerformOrder; //是否影响完工
@end

//机型描述
@interface ProductModelDes : NSObject
@property(nonatomic, copy)NSString *product_id;//代码
@property(nonatomic, copy)NSString *short_text;//描述
@property(nonatomic, copy)NSString *zz0017;//品类
@property(nonatomic, copy)NSString *zz0018;//品牌
@property(nonatomic, copy)NSString *zzfld000003;//产品大类
@end

@interface FacilitatorOrderListInPutParams : NSObject
@property(nonatomic, copy)NSString *partner;
@property(nonatomic, copy)NSString *status;
@property(nonatomic, copy)NSString *pagenow;
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

@interface RepairRefuseOrderInputParams : NSObject
@property(nonatomic, copy)NSString *object_id; //订单号
@property(nonatomic, copy)NSString *isreceivesign;//0:接受, 1:拒绝
@property(nonatomic, copy)NSString *declinefounid;//拒绝编码（理由）（主数据）
@property(nonatomic, copy)NSString *memo;//备注
@end

@interface RefuseOrderInputParams : NSObject
@property(nonatomic, copy)NSString *object_id; //订单号
@property(nonatomic, copy)NSString *flag;//0:接受, 1:拒绝
@property(nonatomic, copy)NSString *reason;//拒绝编码（理由）（主数据）
@property(nonatomic, copy)NSString *memo;//备注
@end

@interface EmployeeInfo : NSObject
@property(nonatomic, copy)NSString *supportman_id;
@property(nonatomic, copy)NSString *supportman_name;
@property(nonatomic, copy)NSString *supportman_phone;
@property(nonatomic, copy)NSString *supportman_type;
@property(nonatomic, copy)NSString *supporttask_total;
@end

@interface RepairerInfo : NSObject
@property(nonatomic, copy)NSString *customer_la;
@property(nonatomic, copy)NSString *customer_lo;
@property(nonatomic, copy)NSString *repairman_lo;
@property(nonatomic, copy)NSString *repairman_la;
@property(nonatomic, copy)NSString *repairman_address;
@property(nonatomic, copy)NSString *repairman_id;
@property(nonatomic, copy)NSString *repairman_name;
@property(nonatomic, copy)NSString *repairman_phone;
@property(nonatomic, copy)NSString *tasktotal;
@end

@interface MyRepairerBaseInfo : NSObject
@property(nonatomic, copy)NSString *Id;
@property(nonatomic, copy)NSString *realname;
@property(nonatomic, copy)NSString *telephone;
@property(nonatomic, copy)NSString *userid;
@end

//技术支持工单
@interface SupporterOrderContent : NSObject
@property(nonatomic, copy)NSString *acceptTime;//接受时间YYYYMMDDhhmmss
@property(nonatomic, copy)NSString *applyTime;//申请时间YYYYMMDDhhmmss
@property(nonatomic, copy)NSString *confirmTime;//确认时间YYYYMMDDhhmmss
@property(nonatomic, copy)NSString *content;//描述
@property(nonatomic, copy)NSString *score;//评分
@property(nonatomic, copy)NSString *status;//状态
@property(nonatomic, copy)NSString *Id; //技术支持表id
@property(nonatomic, copy)NSString *supporterId;//技术支持id
@property(nonatomic, copy)NSString *supporterName;//技术支持姓名
@property(nonatomic, copy)NSString *supporterPhone;//技术支持电话
@property(nonatomic, copy)NSString *workerId;//维修工id
@property(nonatomic, copy)NSString *workerName;//维修工姓名
@property(nonatomic, copy)NSString *workerPhone;//维修工电话
@property(nonatomic, copy)NSString *dispatch_id;
@property(nonatomic, copy)NSString *objectId;//工单号
@property(nonatomic, copy)NSString *regiontxt;//省
@property(nonatomic, copy)NSString *city1;//市
@property(nonatomic, copy)NSString *city2;//区县
@property(nonatomic, copy)NSString *street;//街道
@property(nonatomic, copy)NSString *str_suppl1;//详细地址
@property(nonatomic, copy)NSString *zzfld000000;//品牌
@property(nonatomic, copy)NSString *zzfld000003;//产品大类
@property(nonatomic, copy)NSString *zzfld000001;//品类
@property(nonatomic, copy)NSString *zzfld00000q;//机型
@property(nonatomic, copy)NSString *order_type;//工单类型
@end

//order content model
@interface OrderContentModel : NSObject
@property(nonatomic, copy)NSString *city1;
@property(nonatomic, copy)NSString *city2;
@property(nonatomic, copy)NSString *date_cr;
@property(nonatomic, copy)NSString *date_dy;
@property(nonatomic, copy)NSString *date_pg;
@property(nonatomic, copy)NSString *date_yy;//预约时间
@property(nonatomic, copy)NSString *date_yywc;
@property(nonatomic, copy)NSString *last_yy_time; //预约操作时间
@property(nonatomic, copy)NSString *date_gy;
@property(nonatomic, copy)NSString *date_gywc;
@property(nonatomic, copy)NSString *object_id;
@property(nonatomic, copy)NSString *partner_fwg;
@property(nonatomic, copy)NSString *partner_fwgname;
@property(nonatomic, copy)NSString *priority;
@property(nonatomic, copy)NSString *process_type;
@property(nonatomic, copy)NSString *regiontxt;
@property(nonatomic, copy)NSString *status;
@property(nonatomic, copy)NSString *str_suppl1;
@property(nonatomic, copy)NSString *street;
@property(nonatomic, copy)NSString *urgeflag;
@property(nonatomic, assign)NSInteger urgetimes;
@property(nonatomic, copy)NSString *wxg_isreceive;//维修工是否接受工单（0：未处理；1：已接受；2：拒绝）
@property(nonatomic, strong)NSNumber *yy_operate_time;
@property(nonatomic, copy)NSString *zzfld000000;
@property(nonatomic, copy)NSString *zzfld000001;
@property(nonatomic, copy)NSString *zzfld000003;
@property(nonatomic, copy)NSString *zzfld00000q;
@property(nonatomic, copy)NSString *custname;
@property(nonatomic, copy)NSString *telnumber;
@property(nonatomic, copy)NSString *supportStatus; //技术支持状态
@end

@interface OrderContentDetails : NSObject
@property(nonatomic, copy)NSString *Id; //工单主键ID
@property(nonatomic, copy)NSString *object_id; //工单ID
@property(nonatomic, copy)NSString *buytime;
@property(nonatomic, copy)NSString *city1;
@property(nonatomic, copy)NSString *city2;
@property(nonatomic, copy)NSString *custname;
@property(nonatomic, copy)NSString *date_cr;
@property(nonatomic, copy)NSString *date_dy;
@property(nonatomic, copy)NSString *date_pg;
@property(nonatomic, copy)NSString *date_yy;
@property(nonatomic, copy)NSString *date_gy;
@property(nonatomic, copy)NSString *date_yywc;
@property(nonatomic, copy)NSString *last_yy_time;
@property(nonatomic, copy)NSString *date_gywc;
@property(nonatomic, copy)NSString *Description;
@property(nonatomic, copy)NSString *imageuploadpath;
@property(nonatomic, copy)NSString *isBake;
@property(nonatomic, copy)NSString *isSupport;
@property(nonatomic, copy)NSString *supporterName;
@property(nonatomic, copy)NSString *isturnovercontract;
@property(nonatomic, copy)NSString *isupload;
@property(nonatomic, copy)NSString *jd_thj;
@property(nonatomic, copy)NSString *machinemodel;  //主机条码
@property(nonatomic, copy)NSString *machinemodel2;  //附机条码
@property(nonatomic, copy)NSString *memo;
@property(nonatomic, copy)NSString *partner;
@property(nonatomic, copy)NSString *partner_fwg;
@property(nonatomic, copy)NSString *partner_fwgname;
@property(nonatomic, copy)NSString *priority;
@property(nonatomic, copy)NSString *process_type;   //CODE
@property(nonatomic, copy)NSString *regiontxt;
@property(nonatomic, copy)NSString *status;
@property(nonatomic, copy)NSString *street;
@property(nonatomic, copy)NSString *streetCode;
@property(nonatomic, copy)NSString *syscontractno;
@property(nonatomic, copy)NSString *telnumber;
@property(nonatomic, copy)NSString *wxg_isreceive; //维修工是否接受工单（0：未处理；1：已接受；2：拒绝）
@property(nonatomic, copy)NSString *str_suppl1;//详细地址
@property(nonatomic, copy)NSString *zzfld000000;//品牌
@property(nonatomic, copy)NSString *zzfld000003;//产品大类
@property(nonatomic, copy)NSString *zzfld000001;//品类
@property(nonatomic, copy)NSString *zzfld000002;//保内外标志
@property(nonatomic, copy)NSString *zzfld00000q;//机型
@property(nonatomic, copy)NSString *zzfld00002i;//购买日期
@property(nonatomic, copy)NSString *zzfld00000b;//主机条码
@property(nonatomic, copy)NSString *zzfld00000e;//门店名称
@property(nonatomic, copy)NSString *zzfld00002h;//故障处理
@property(nonatomic, copy)NSString *zzfld000005;//预约未成功原因(代码)
@property(nonatomic, copy)NSString *zzfld00000m;//电商订单号
@property(nonatomic, copy)NSObject *frequency;  //预约情况
@property(nonatomic, strong)NSArray *tDispatchParts;//item: PartMaintainContent
@property(nonatomic, strong)SupporterOrderContent *supportInfo;

//服务改善
@property(nonatomic, copy)NSString *infosource;//信息来源
@property(nonatomic, copy)NSString *improve;//服务改善原因

//延保
@property(nonatomic, copy)NSString *extendprdId; //延保合同id
@property(nonatomic, copy)NSString *extendprdType;
@property(nonatomic, copy)NSString *extendprdContractNum;
@property(nonatomic, copy)NSString *extendprdStatus;

//local added
@property(nonatomic,assign)BOOL isAirConditioning;
@property(nonatomic,assign)BOOL isTV;
@property(nonatomic, copy)NSString *brandIdStr;
@property(nonatomic, copy)NSString *productIdStr;
@property(nonatomic, copy)NSString *categroyIdStr;
@property(nonatomic, readonly)kProductType productType;

@end

@interface OrderTraceInfos: NSObject
@property(nonatomic, copy)NSString *dispatchparts_id;
@property(nonatomic, copy)NSString *object_id;
@property(nonatomic, copy)NSString *puton_part_matno;
@property(nonatomic, copy)NSString *puton_status;
@property(nonatomic, copy)NSString *wlmc;   //物料名称
@end

@interface SellFeeListInfos: NSObject
@property(nonatomic, copy)NSNumber *Id;    //费用表ID，主键,long
@property(nonatomic, copy)NSString *objectId; //工单表objectid
@property(nonatomic, copy)NSNumber *dispatchId;//工单表ID, long
@property(nonatomic, copy)NSNumber *createTime; //创建时间, long
@property(nonatomic, copy)NSString *isSendtoCrm;//同步到CRM,1已同步，0未同步
@property(nonatomic, copy)NSString *itmType; //保外费用：ZRVW:智能产品：ZPRV
@property(nonatomic, copy)NSNumber *netValue; //金额, double
@property(nonatomic, copy)NSString *orderedProd; //保外.服务物料代码(智能.产品代码)
@property(nonatomic, copy)NSString *prodDescription; //智能产品描述
@property(nonatomic, copy)NSNumber *quantity; //数量, long
@property(nonatomic, copy)NSString *zzfld00002v; //收据号
@property(nonatomic, copy)NSString *zzfld00005e; //智能产品分类

//local
@property(nonatomic, copy)NSString *brandIdStr;
@property(nonatomic, copy)NSString *categoryIdStr;
@property(nonatomic, readonly)CGFloat totalPrice;

@end

@interface DeviceInfos : NSObject
@property(nonatomic, copy)NSString *zzfld00002i;//购买日期YYYYMMDD
@property(nonatomic, copy)NSString *zzfld00000e;//购机商场
@property(nonatomic, copy)NSString *barCode;//机号条码
@property(nonatomic, copy)NSString *mainboardCode;//主板物料代码
@property(nonatomic, copy)NSString *mainboardDesc;//主板物料描述
@property(nonatomic, copy)NSString *powerCode;//电源物料编码
@property(nonatomic, copy)NSString *powerDesc;//电源物料描述
@property(nonatomic, copy)NSString *screenFactory;   //屏厂家
@property(nonatomic, copy)NSString *screenType; //屏型号
@end

@interface CHIQYunAirConditioningInfos : NSObject
@property(nonatomic, copy)NSString *acModel;
@property(nonatomic, copy)NSString *compNoRadiatorCode;
@property(nonatomic, copy)NSString *compNoRadiatorName;
@property(nonatomic, copy)NSString *compRadiatorCode;
@property(nonatomic, copy)NSString *compRadiatorName;
@property(nonatomic, copy)NSString *compressorCode;
@property(nonatomic, copy)NSString *compressorName;
@property(nonatomic, copy)NSString *dcFanDriCode;
@property(nonatomic, copy)NSString *dcFanDriName;
@property(nonatomic, copy)NSString *dispSwitchCode;
@property(nonatomic, copy)NSString *dispSwitchName;
@property(nonatomic, copy)NSString *dispWareCode;
@property(nonatomic, copy)NSString *dispWareName;
@property(nonatomic, copy)NSString *gasSensorCode;
@property(nonatomic, copy)NSString *gasSensorName;
@property(nonatomic, copy)NSString *inBoardCode;
@property(nonatomic, copy)NSString *inBoardName;
@property(nonatomic, copy)NSString *inFanCode;
@property(nonatomic, copy)NSString *inFanName;
@property(nonatomic, copy)NSString *inPanSensorCode;
@property(nonatomic, copy)NSString *inPanSensorName;
@property(nonatomic, copy)NSString *inTempSensorCode;
@property(nonatomic, copy)NSString *inTempSensorName;
@property(nonatomic, copy)NSString *infraredWareCode;
@property(nonatomic, copy)NSString *infraredWareName;
@property(nonatomic, copy)NSString *lightWareCode;
@property(nonatomic, copy)NSString *lightWareName;
@property(nonatomic, copy)NSString *outBoardCode;
@property(nonatomic, copy)NSString *outBoardName;
@property(nonatomic, copy)NSString *outFanCode;
@property(nonatomic, copy)NSString *outFanName;
@property(nonatomic, copy)NSString *outPanSensorCode;
@property(nonatomic, copy)NSString *outPanSensorName;
@property(nonatomic, copy)NSString *outSensorCode;
@property(nonatomic, copy)NSString *outSensorName;
@property(nonatomic, copy)NSString *socPowerCode;
@property(nonatomic, copy)NSString *socPowerName;
@property(nonatomic, copy)NSString *socWareCode;
@property(nonatomic, copy)NSString *socWareName;
@end

//延保客户
@interface ExtendCustomerInfo : NSObject
@property(nonatomic, copy)NSString *Id;//客户id
@property(nonatomic, copy)NSString *cusName;//	客户姓名
@property(nonatomic, copy)NSString *province;//省
@property(nonatomic, copy)NSString *city;//市
@property(nonatomic, copy)NSString *town;//区
@property(nonatomic, copy)NSString *street;//街道
@property(nonatomic, copy)NSString *detailAddress;//详细地址
@property(nonatomic, copy)NSString *cusTelNumber;//	客户电话
@property(nonatomic, copy)NSString *cusMobNumber;//客户移动电话
@property(nonatomic, copy)NSString *extendprdId;//延保id
@end

//延保单内容
@interface ExtendServiceOrderContent : NSObject
@property(nonatomic, copy)NSString *Id;//延保id
@property(nonatomic, copy)NSString *status;//	状态
@property(nonatomic, copy)NSString *objectId;//	工单号
@property(nonatomic, copy)NSString *type;//	类型1单品延保，2家多保
@property(nonatomic, copy)NSString *userId;//	维修工userid
@property(nonatomic, copy)NSString *serverId;//	创建用户服务商id
@property(nonatomic, copy)NSString *reason;//	成交原因（代码）
@property(nonatomic, copy)NSString *contractNum;//	合同号
@property(nonatomic, strong)NSNumber *signDate;//	签字日期
@property(nonatomic, copy)NSString *extendLife;//	延保年限
@property(nonatomic, copy)NSString *Description;//	合同描述
@property(nonatomic, copy)NSString *sysContractNum;//	订单号
@property(nonatomic, copy)NSString *creatTime;//	创建时间
@property(nonatomic, copy)NSString *updateTime;//	更新时间
@property(nonatomic, copy)NSString *zsp00180;//	服务商id
@property(nonatomic, copy)NSString *zsp00170;//	操作人id
@property(nonatomic, copy)NSString *productCount;//	产品数量
@property(nonatomic, strong)NSArray *productInfoList;// item : ExtendProductContent
@property(nonatomic, strong)ExtendCustomerInfo *customerInfo;
@end

//延保列表
@interface ExtendOrderListInputParams : NSObject
@property(nonatomic, copy)NSString *userId; //登录用户userid
@property(nonatomic, copy)NSString *pageNow;//页码pageNow=1开始，每页10条）
@property(nonatomic, copy)NSString *type; 
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
@end

//延保产品
@interface ExtendProductContent : NSObject
@property(nonatomic, copy)NSString *zzfld000000;//品牌
@property(nonatomic, copy)NSString *zzfld000003v;//其它品牌
@property(nonatomic, copy)NSString *zzfld000001;//品类(机器类型)
@property(nonatomic, copy)NSString *zzfld00000q;//机型
@property(nonatomic, copy)NSString *zzfld00005j;//机型描述,或手动输入的机型
@property(nonatomic, strong)NSString *zzfld00002i;//购买日期,in:yyyy-mm-dd,out: timeinteval
@property(nonatomic, copy)NSString *zzfld00000b;//机号(主机/内机条码)
@property(nonatomic, strong)NSString *buyprice;//购机价格,in: string, out:number
@property(nonatomic, copy)NSString *pricerange;//价格区间
@property(nonatomic, copy)NSString *factoryWarrantyDue;//厂保到期日期yyyy-MM-dd
@property(nonatomic, copy)NSString *invoiceNo;//发票号
@property(nonatomic, copy)NSString *extendprdBeginDue;//延保开始日期
@property(nonatomic, copy)NSString *extendprdEndDue;//延保结束日期
@property(nonatomic, copy)NSString *zzfld00000e;//购机门店
@end

@interface AppVersionInfo : NSObject
@property(nonatomic, copy)NSString *Id;//	应用id
@property(nonatomic, copy)NSString *upgradeType;//	是否强制升级
@property(nonatomic, copy)NSString *downloadUrl;//	最新版本的跳转下载地址
@property(nonatomic, copy)NSString *number;//	版本号
@property(nonatomic, copy)NSString *entrance;//	版本入口
@property(nonatomic, copy)NSString *name;//	版本名
@property(nonatomic, copy)NSString *createTime;//	版本创建时间
@property(nonatomic, copy)NSString *updateTime;//	版本更新时间
@property(nonatomic, copy)NSString *isPublished;//	是否发布
@property(nonatomic, copy)NSString *isAvailable;//	是否可用
@property(nonatomic, copy)NSString *Description;//	版本描述
@end

@interface AdditionalBusinessItem  : NSObject
@property(nonatomic, copy)NSString *type;   //物料类别
@property(nonatomic, copy)NSString *items;  //销售物料
@property(nonatomic, copy)NSString *price;  //价格
@property(nonatomic, copy)NSString *num;    //数量
@end

