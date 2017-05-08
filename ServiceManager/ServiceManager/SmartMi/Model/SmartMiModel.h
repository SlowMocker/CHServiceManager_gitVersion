//
//  SmartMiModel.h
//  ServiceManager
//
//  Created by Wu on 17/3/27.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmartMiModel : NSObject

@end


#pragma mark
#pragma mark 智米相关数据模型

#import <Foundation/Foundation.h>
#import "ConfigItemInfo.h"

//备件信息
@interface SmartMiPartsContentInfo : NSObject
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
@interface SmartMiPartMaintainContent : NSObject
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




@interface SmartMiEmployeeInfo : NSObject
@property(nonatomic, copy)NSString *supportman_id;
@property(nonatomic, copy)NSString *supportman_name;
@property(nonatomic, copy)NSString *supportman_phone;
@property(nonatomic, copy)NSString *supportman_type;
@property(nonatomic, copy)NSString *supporttask_total;
@end


@interface SmartMiMyRepairerBaseInfo : NSObject
@property(nonatomic, copy)NSString *Id;
@property(nonatomic, copy)NSString *realname;
@property(nonatomic, copy)NSString *telephone;
@property(nonatomic, copy)NSString *userid;
@end


@interface SmartMiRepairerInfo : NSObject
@property(nonatomic, copy)NSString *repairManId;//维修人员编号
@property(nonatomic, copy)NSString *repairManName;//维修人员姓名
@property(nonatomic, copy)NSString *repairManTel;//维修人员电话
@property(nonatomic, copy)NSString *repairManAddr;//维修人员地址
@property(nonatomic, copy)NSString *customerLon;//客户经度
@property(nonatomic, copy)NSString *customerLat;//客户纬度
@end


//技术支持工单
@interface SmartMiSupporterOrderContent : OrderContent
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

@property(nonatomic, copy)NSString *customerFullAddress;
@end

//order content model
@interface SmartMiOrderContentModel : OrderContent

@property(nonatomic, copy)NSString *id; // 主键 id
@property(nonatomic, copy)NSString *objectId; // 订单号
@property(nonatomic, copy)NSString *status; // 工单状态
@property(nonatomic, copy)NSString *createTime; // 创建时间yyyyMMddHHmmss
@property(nonatomic, copy)NSString *orderType; // 订单类型
@property(nonatomic, copy)NSString *orderTypeVal; // 订单类型属性名
@property(nonatomic, copy)NSString *dispatchDate; // 派工日期yyyyMMddHHmmss
@property(nonatomic, copy)NSString *aboutDate; // 代约时间yyyyMMddHHmmss
@property(nonatomic, copy)NSString *province; // 省
@property(nonatomic, copy)NSString *city; // 市
@property(nonatomic, copy)NSString *county; // 县（区）
@property(nonatomic, copy)NSString *town; // 镇（乡）
@property(nonatomic, copy)NSString *street; // 街道
@property(nonatomic, copy)NSString *detailAddr; // 详细地址
@property(nonatomic, copy)NSString *brand; // 品牌
@property(nonatomic, copy)NSString *brandVal; // 品牌属性名
@property(nonatomic, copy)NSString *productType; // 产品大类
@property(nonatomic, copy)NSString *productTypeVal; // 产品大类属性名
@property(nonatomic, copy)NSString *category; // 品类
@property(nonatomic, copy)NSString *categoryVal; // 品类属性名
@property(nonatomic, copy)NSString *priority; // 优先级（1：一般；5：紧急；9：重大）
@property(nonatomic, copy)NSString *model; // 机型
@property(nonatomic, copy)NSString *isReceive; // 维修工是否接受工单（0：未处理；1：已接受；2：拒绝）
@property(nonatomic, copy)NSString *urgeFlag; // 催单标记（X：催单；0或空：不催单）
@property(nonatomic, copy)NSString *urgeTimes; // 催单次数
@property(nonatomic, copy)NSString *workerId; // 维修人员编号
@property(nonatomic, copy)NSString *workerName; // 维修人员姓名
@property(nonatomic, copy)NSString *name; // 客户姓名
@property(nonatomic, copy)NSString *phoneNum; // 客户电话号码

@property(nonatomic, copy)NSString *firstApptDate; // 预约日期yyyyMMddHHmmss
@property(nonatomic, copy)NSString *firstApptOpDate; // 首次预约操作日期
@property(nonatomic, copy)NSString *lastApptDate; // 最后一次预约日期
@property(nonatomic, copy)NSString *lastApptOpDate; // 最后一次预约操作日期
@property(nonatomic, copy)NSString *dispatchLogLastApptDate; // 工单日志中记录的最后一次预约日期yyyyMMddHHmmss
@property(nonatomic, copy)NSString *supprotStatus; // 技术支持状态（101:申请；102:接受；103:确认）

// self add
@property(nonatomic, readonly ,copy)NSString *customerFullAddress;

- (BOOL) isOrderStatus:(NSInteger)orderStatus; //是否属于某状态
- (NSArray *) orderStatusSet;
@end

// 带 val 后缀的代表中文汉字
@interface SmartMiOrderContentDetails : NSObject
@property(nonatomic, copy)NSString *id; // 工单主键
@property(nonatomic, copy)NSString *objectId; // 工单号（服务工单号）
@property(nonatomic, copy)NSString *smartmiOrderNum; // 智米工单编号（智米单号）
@property(nonatomic, copy)NSString *orderType; // 订单类型／服务类型（工单类型）
@property(nonatomic, copy)NSString *orderTypeVal; // 订单类型／服务类型（工单类型）
@property(nonatomic, copy)NSString *status; // 工单状态（状态）
@property(nonatomic, copy)NSString *createTime; // CRM 收单时间
@property(nonatomic, copy)NSString *serverId; // 服务商编号
@property(nonatomic, copy)NSString *workerId; // 维修人员编号
@property(nonatomic, copy)NSString *memo; // 备注
@property(nonatomic, copy)NSString *apptMemo; // 预约备注
@property(nonatomic, copy)NSString *workerName; // 维修人员姓名
@property(nonatomic, copy)NSString *apptFailCause; // 预约未成功原因(代码)
@property(nonatomic, copy)NSString *isBack; // 是否打回标识(0：否；1：是)
@property(nonatomic, copy)NSString *isReceive; // 维修工是否接受工单（0：未处理；1：已接受；2：拒绝）
@property(nonatomic, copy)NSString *aboutDate; // 代约时间yyyyMMddHHmmss
@property(nonatomic, copy)NSString *dispatchDate; // 派工日期yyyyMMddHHmmss
@property(nonatomic, copy)NSString *firstApptDate; // 首次预约日期yyyyMMddHHmmss
@property(nonatomic, copy)NSString *firstApptOpDate; // 首次预约操作日期yyyyMMddHHmmss
@property(nonatomic, copy)NSString *lastApptDate; // 最后一次预约日期yyyyMMddHHmmss
@property(nonatomic, copy)NSString *lastApptOpDate; // 最后一次预约操作日期yyyyMMddHHmmss
@property(nonatomic, copy)NSString *requestTime; // 客户要求上门时间（希望上门时间）yyyyMMddHHmmss
@property(nonatomic, copy)NSString *dispatchLogLastApptDate; // 工单日志中记录的最后一次预约日期
@property(nonatomic, copy)NSString *name; // 客户姓名（姓名）
@property(nonatomic, copy)NSString *phoneNum; // 客户参考电话号码（电话）详情页展示
@property(nonatomic, copy)NSString *PhoneNum2; // 客户电话号码（电话）
@property(nonatomic, copy)NSString *province; // 省
@property(nonatomic, copy)NSString *city; // 市
@property(nonatomic, copy)NSString *county; // 县（区）
@property(nonatomic, copy)NSString *town; // 镇（乡）
@property(nonatomic, copy)NSString *street; // 街道
@property(nonatomic, copy)NSString *detailAddr; // 详细地址
@property(nonatomic, copy)NSString *streetCode; // 街道代码
@property(nonatomic, copy)NSString *brand; // 品牌
@property(nonatomic, copy)NSString *brandVal;  // 品牌属性名
@property(nonatomic, copy)NSString *productType; // 产品大类
@property(nonatomic, copy)NSString *productTypeVal; // 产品大类属性名
@property(nonatomic, copy)NSString *category; // 品类
@property(nonatomic, copy)NSString *categoryVal; // 品类属性名
@property(nonatomic, copy)NSString *securityLabe; // 保内外标志（产品质保）
@property(nonatomic, copy)NSString *securityLabeVal; // 保内外标志（产品质保）属性名
@property(nonatomic, copy)NSString *priority; // 优先级（紧急程度）（1：一般；5：紧急；9：重大）
@property(nonatomic, copy)NSString *source; // 信息来源符号（只有维修工才显示）
@property(nonatomic, copy)NSString *sourceVal; // 信息来源文字（只有维修工才显示）
@property(nonatomic, copy)NSString *faultDesc; // 故障现象
@property(nonatomic, copy)NSString *model; // 机型
@property(nonatomic, copy)NSString *modelVal; // 机型属性名
@property(nonatomic, copy)NSString *hostBarcode; // 主（内）机条码
@property(nonatomic, copy)NSString *externalBarCode; // 外机条码
@property(nonatomic, copy)NSString *faultHandling; // 故障处理(或维修措施)
@property(nonatomic, copy)NSString *snCode; // SN编码
@property(nonatomic, copy)NSString *buyDate; // 购机日期yyyyMMdd
@property(nonatomic, copy)NSString *isBuyRack; // 是否购买挂架（是否官方购买挂架）
@property(nonatomic, copy)NSString *faultCode; // 故障代码
@property(nonatomic, copy)NSString *outdoorTemp; // 室外环境温度
@property(nonatomic, copy)NSString *intoTemp; // 室内进风温度
@property(nonatomic, copy)NSString *outoTemp; // 室内出风温度
@property(nonatomic, copy)NSString *pipeLength; // 连接管总长度
@property(nonatomic, copy)NSString *runPressure; // 运行压力
@property(nonatomic, copy)NSString *inMachinePic; // 室内机照片
@property(nonatomic, copy)NSString *userAppPic; // 用户app照片
@property(nonatomic, copy)NSString *outMachinePic; // 室外机照片
@property(nonatomic, copy)NSString *userMachinePic; // 用户跟机器合照
@property(nonatomic, copy)NSString *floor; // 楼层
@property(nonatomic, copy)NSString *area; // 使用面积
@property(nonatomic, copy)NSString *isSupport; // 是否需要技术支持(0：不需要支持；1：需要支持)
@property(nonatomic, copy)NSString *supporterId; // 技术支持人员编号
@property(nonatomic, copy)NSString *supporterName; // 技术支持人员姓名
@property(nonatomic, copy)NSString *supporterPhone; // 技术支持人员电话
@property(nonatomic, copy)NSString *supportInfoId; // 技术支持表主键ID
@property(nonatomic, copy)NSString *applyTime; // 申请时间
@property(nonatomic, copy)NSString *acceptTime; // 接受时间
@property(nonatomic, copy)NSString *confirmTime; // 确认时间
@property(nonatomic, copy)NSString *supprotStatus; // 技术支持状态（101:申请；102:接受；103:确认）
@property(nonatomic, copy)NSString *score; // 评分
@property(nonatomic, copy)NSString *content; // 内容描述

//local added
@property(nonatomic, copy)NSString *brandIdStr;
@property(nonatomic, copy)NSString *productIdStr;
@property(nonatomic, copy)NSString *categroyIdStr;
@property(nonatomic, copy)NSString *customerFullCountyAddress;
@property(nonatomic, copy)NSString *customerFullAddress;
@end

//机型描述
@interface SmartMiProductModelDes : NSObject
@property(nonatomic, copy)NSString *brand;//品牌
@property(nonatomic, copy)NSString *productType;//产品大类
@property(nonatomic, copy)NSString *category;//品类
@property(nonatomic, copy)NSString *model;//机型代码
@property(nonatomic, copy)NSString *modelDesc;//机型描述
@end

@interface SmartMiOrderTraceInfos: NSObject
@property(nonatomic, copy)NSString *dispatchparts_id;
@property(nonatomic, copy)NSString *object_id;
@property(nonatomic, copy)NSString *puton_part_matno;
@property(nonatomic, copy)NSString *puton_status;
@property(nonatomic, copy)NSString *wlmc;   //物料名称
@property(nonatomic, copy)NSString *zzfld00002s;    //备件条码
@property(nonatomic, copy)NSString *refusalReason;//未审核通过原因
@end

@interface SmartMiSellFeeListInfos: NSObject
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

@interface SmartMiDeviceInfos : NSObject
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


//延保客户
@interface SmartMiExtendCustomerInfo : NSObject
@property(nonatomic, copy)NSString *Id;//客户id
@property(nonatomic, copy)NSString *cusName;//	客户姓名
@property(nonatomic, copy)NSString *province;//省
@property(nonatomic, copy)NSString *city;//市
@property(nonatomic, copy)NSString *town;//区
@property(nonatomic, copy)NSString *street;//街道code
@property(nonatomic, copy)NSString *streetValue;//街道value
@property(nonatomic, copy)NSString *detailAddress;//详细地址
@property(nonatomic, copy)NSString *cusTelNumber;//	客户电话
@property(nonatomic, copy)NSString *cusMobNumber;//客户移动电话
@property(nonatomic, copy)NSString *extendprdId;//延保id
@end

//延保单内容
@interface SmartMiExtendServiceOrderContent : NSObject
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
@property(nonatomic, copy)NSString *tempNum;//临时延保号
@property(nonatomic, copy)NSNumber *econtract;//电子合同（0：否；1：是）
@property(nonatomic, copy)NSNumber *isPay;//是否支付（0：否；1：是）
@property(nonatomic, copy)NSString *payAmount;//支付金额

@property(nonatomic, copy)NSString *productCount;//	产品数量
@property(nonatomic, strong)NSArray *productInfoList;// item : ExtendProductContent
@property(nonatomic, strong)ExtendCustomerInfo *customerInfo;

//local
@property(nonatomic, assign, readonly)BOOL editable;
@end

//延保产品
@interface SmartMiExtendProductContent : NSObject
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


@interface SmartMiAdditionalBusinessItem  : NSObject
@property(nonatomic, copy)NSString *type;   //物料类别
@property(nonatomic, copy)NSString *items;  //销售物料
@property(nonatomic, copy)NSString *price;  //价格
@property(nonatomic, copy)NSString *num;    //数量
@end



