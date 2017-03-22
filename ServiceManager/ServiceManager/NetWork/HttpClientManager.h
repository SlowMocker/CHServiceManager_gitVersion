//
//  HttpClientManager.h
//  BaseProject
//
//  Created by wangzhi on 15-2-2.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "NetClientManager.h"
#import "InterFaceAPI.h"
#import "InterfaceInputParamsObjects.h"
#import "DataModelEntities.h"

#pragma mark - HTTP请求返回码定义

#pragma mark - HttpClientManager

//init请用父类的sharedInstance
@interface HttpClientManager : NSObject

//设置3DES加解密钥
@property(nonatomic, copy)NSString *tripleDesKey;

@property(nonatomic, strong)NetClientManager *netClient;

+(instancetype)sharedInstance;

#pragma mark - Serv API

#pragma mark - Common API

//上传图片
- (void)uploadImage:(UIImage*)image toPath:(NSString*)path response:(RequestCallBackBlock)requestCallBackBlock;

//app的版本信息
- (void)getAppVersionInfo:(RequestCallBackBlock)requestCallBackBlock;

//读主数据
- (void)getMainInfosByTypes:(NSArray*)cfgTypes response:(RequestCallBackBlock)requestCallBackBlock;

//读街道数据，版本1，需传入省市县CODE
- (void)getStreetInfos:(StreetListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//读街道数据，版本2， 只需传入县区CODE，即可取得其下的街道
- (void)getStreetsOfDistrict:(NSString*)districtCode response:(RequestCallBackBlock)requestCallBackBlock;

//工单详情
- (void)getOrderDetails:(GetOrderDetailsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//服务改善详情
- (void)getServiceImproveDetails:(GetOrderDetailsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//设备信息(非启客空调)
- (void)getDeviceInfos:(GetDeviceInfosInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//启客云空调设备信息
- (void)getCHIQAirConditioningInfo:(NSString*)machineBarCode response:(RequestCallBackBlock)requestCallBackBlock;

//活动详情读取
- (void)queryActivityContentDetail:(QueryActivityContentDetailInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//微信点评二纬码请求
- (void)getWeixinCommentQrCode:(WeixinCommentQrCodeInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//获取延保收款单信息
- (void)getExtendPayOrderInfo:(ExtendPayOrderInfoInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//保存图片信息
- (void)saveImageInfos:(SaveImageInfosInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//登录接口
- (void)login:(LoginInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//修改密码
-(void)changePassword:(ChangePasswordInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//修改员工信息
- (void)changeUserInfo:(ChangeUserInfoInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//删除员工
-(void)deleteRepairer:(DeleteRepairerInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//技术支持人员列表, List Item : EmployeeInfo
- (void)getEngneerList:(GetEngneerListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//申请技术支持
- (void)applySupportHelp:(ApplySupportHelpInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//服务商维修人员列表,用于派工 List Item: RepairerInfo
- (void)getRepairerList:(GetRepairerListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//派工给服务工程师
-(void)assignEngineer:(AssignEngineerInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//公告列表
-(void)queryBulletList:(QueryBulletListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//公告详情
-(void)queryBulletinDetails:(QueryBulletinDetailsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//首页热门公告列表
-(void)getTopBulletListWithResponse:(RequestCallBackBlock)requestCallBackBlock;

//Qiniu云图片上传的TOKEN
-(void)getQiniuUploadTokenWithResponse:(RequestCallBackBlock)requestCallBackBlock;

//取得问卷调查信息
- (void)getQuestionnaireSurveyWithResponse:(RequestCallBackBlock)requestCallBackBlock;

//维修工管理列表
- (void)repairerManageList:(RepairerMangerListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//备件跟踪列表
- (void)partTracklist:(PartTracklistInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//备件跟踪状态更新
- (void)setPartTraceStatus:(SetPartTraceStatusInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//费用管理
- (void)queryExpenseList:(ExpenseListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//接受催单
- (void)agreeOrderUrge:(AgreeUrgeInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//维修工上门签到
-(void)repairSignIn:(RepairSignInInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//机型品类
- (void)getMachineCategory:(MachineCategoryInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//完成工单
- (void)repairFinishBill:(FinishBillInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//特殊完工
- (void)repairSpecialFinishBill:(SpecialFinishBillInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//JD鉴定图片上传状态
-(void)setJdIdentifyImageUploadStatus:(JdIdentifyImageUploadStatusInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//创建或编辑单品延保单
- (void)editSingleExtendServiceOrder:(SingleExtendOrderEditInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//创建或编辑多品延保单
- (void)editMutiExtendServiceOrder:(MutiExtendOrderEditInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//单、多品延保单列表
- (void)extendOrderList:(ExtendOrderListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//删除电保单
- (void)deleteExtendOrder:(DeleteExtendOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//单、多品延保单详情
- (void)extendOrderDetails:(ExtendOrderDetailsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//模糊查询机型
- (void)findMachineModel:(FindMachineModelInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

#pragma mark - Repairer API

//接受、拒绝订单
- (void)repairer_refuseOrder:(RepairRefuseOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//订单列表
-(void)repairer_orderList:(RepairOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//备件屏列表
- (void)repairer_selectParts:(RepairerSelectPartsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//组件类别
- (void)repairer_partTypes:(RepairerPartTypesInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//组件列表
- (void)repairer_partList:(RepairerPartListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//组件信息
- (void)repairer_partFindInfo:(RepairerPartGetInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//添加组件信息
- (void)repairer_addPart:(RepairerAddPartInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//删除组件信息
- (void)repairer_deletePart:(RepairerDeletePartInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//更新组件信息
- (void)repairer_updatePart:(RepairerUpdatePartInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//得到备件信息
- (void)repairer_getPartsInfo:(GetPartsInfoInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//维修工预约,改约
- (void)repairer_appointmentOrder:(RepairerAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//维修工技术确认
- (void)repairer_confirmSupport:(ConfirmSupportInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

#pragma mark - Facilitator API

//接受、拒绝订单
- (void)facilitator_refuseOrder:(RefuseOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//订单列表
-(void)facilitator_orderList:(FacilitatorOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//服务改善列表
-(void)facilitator_serviceImproveList:(ServiceImproveListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//预约
- (void)facilitator_appointmentOrder:(AppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//意见反馈
-(void)submitFeedback:(SubmitFeedbackInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//改约
- (void)facilitator_changeAppointmentOrder:(ChangeAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//保外费用添加或编辑
- (void)editFeeOrder:(EditFeeOrderInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock;

//删除费用
- (void)deleteFeeOrder:(DeleteFeeOrderInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock;

//删除所有费用清单
- (void)deleteAllFeeOrder:(DeleteAllFeeOrderInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock;

//同步费用管理列表
- (void)syncFeeBillList:(SyncFeeBillListInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock;

//查询费用管理同步情况
- (void)queryFeeBillStatus:(QueryFeeBillStatusInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock;

//添加维修工
- (void)facilitator_newRepairer:(NewRepairerInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock;

//搜索工单, requestCallBackBlock's param 3 is OrderContentModel array
- (void)searchOrders:(SearchOrdersInputParams*)input response:(RequestCallBackBlockV2)requestCallBackBlock;

#pragma mark - Supporter API

//技术工单列表
-(void)supporter_orderList:(SupporterOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

//技术人员接收
-(void)supporter_accept:(SupporterAcceptInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock;

@end
