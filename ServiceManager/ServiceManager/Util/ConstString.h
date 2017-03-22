//
//  ConstString.h
//  BaseProject
//
//  Created by wangzhi on 15-1-30.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#ifndef BaseProject_ConstString_h
#define BaseProject_ConstString_h

#pragma mark - 自定义通知

static NSString *const NotificationNameLogined = @"登录成功";
static NSString *const NotificationNameLogout = @"用户已登出";
static NSString *const NotificationUserInfoChanged = @"用户信息改变";
static NSString *const NotificationMainConfigInfoUpdated = @"更新了主数据";
static NSString *const NotificationMainConfigInfoUpdateFailed = @"更新主数据失败";
static NSString *const NotificationExtendOrderChanged = @"延保单有改变";
static NSString *const NotificationOrderChanged = @"工单有改变";
static NSString *const NotificationOrderDetailsChanged = @"工单详情有改变";
static NSString *const NotificationEmployeesChanged = @"维修工人数改变";
static NSString *const NotificationNameCustomFeatureChanged = @"首页定制";
static NSString *const NotificationNameWeixinComment = @"微信点评";
static NSString *const NotificationNameReceivedAccount = @"收款状态变更";

#pragma mark - 宏定义字符串

#define ksTrue  @"true"
#define ksFalse @"false"
#define ksYes   @"YES"
#define ksNo    @"NO"

#define ksSystemVersion @"sytemVersion"
#define ksOsName    @"osName"

#define ksResultCode    @"resultCode"
#define ksResultInfo    @"resultInfo"
#define ksData          @"data"
#define ksLandMark    @"landMark"
#define ksMarkId    @"markId"
#define ksMarkName    @"markName"
#define ksStreet    @"street"
#define ksStreetId    @"streetId"
#define ksStreetName    @"streetName"
#define kscurrentPage  @"currentPage"
#define ksPageCount     @"pageCount"
#define ksPageSize  @"pageSize"
#define ksTotalCount @"totalCount"
#define ksTitle         @"title"
#define ksStrCreateDate @"strCreateDate"
#define ksDetailsUrl    @"detailsUrl"

#define ksClient        @"client"
#define ksEncryptKey    @"encryptKey"
#define ksId            @"id"
#define ksSenderAvatar  @"senderAvatar"
#define ksSenderNickname    @"senderNickname"
#define ksSenderMobile  @"senderMobile"
#define ksReceiverAvatar  @"receiverAvatar"
#define ksReceiverNickname    @"receiverNickname"
#define ksReceiverMobile  @"receiverMobile"
#define ksLastLoginDate @"lastLoginDate"
#define ksMobile        @"mobile"
#define ksPassword      @"password"
#define ksRegisterDate  @"registerDate"
#define ksStatus        @"status"
#define ksUserName      @"userName"
#define ksNickName      @"nickName"
#define ksUserToken     @"userToken"
#define ksToken         @"token"
#define ksCantonId      @"cantonId"
#define ksCantonCode    @"cantonCode"
#define ksCantonName    @"cantonName"
#define ksVerifyCode    @"verifyCode"
#define ksAvatar        @"avatar"
#define ksChatAccount   @"chatAccount"

#define ksContent @"content"
#define ksQq    @"qq"

//贷款字典Key
#define ReimburseAmoutKey   @"reimburseAmout"       //还款总额
#define InterestPayKey      @"interestPay"          //支付利息
#define LoanMonthKey        @"loanMonth"            //贷款月数
#define LoanYearKey         @"loanYear"             //贷款年数
#define MonthPaymentKey     @"monthPayment"         //月均还款
#define LoanAmoutKey        @"loanAmout"            //贷款总额
#define InterestRateKey     @"interestRate"         //利率

#define ksComplainType  @"complainType"
#define ksAuthorType  @"authorType"
#define ksHouseType  @"houseType"
#define ksHouseInfo  @"houseInfo"
#define ksIndustry  @"industry"
#define ksInterestAcreage  @"interestAcreage"
#define ksHouseModel  @"houseModel"
#define ksSellPriceRange  @"sellPriceRange"
#define ksLoanRate  @"loanRate"
#define ksOrientations  @"orientations"
#define ksPropertYear  @"propertyYear"
#define ksRenovationType  @"renovationType"
#define ksSex  @"sex"
#define ksStructure  @"structure"
#define ksLeaseType  @"leaseType"
#define ksAcreageRange    @"acreageRange"
#define ksLoanRate  @"loanRate"
#define ksLeasePriceRange   @"leasePriceRange"
#define ksMatching      @"matching"
#define ksAccumulationRate  @"accumulationRate"
#define ksBusinessRate  @"businessRate"
#define ksIsAgent   @"isAgent"
#define ksIsTip @"isTip"
#define ksContactName   @"contactName"
#define ksContactTelephone @"contactTelephone"
#define ksContactId @"contactId"
#define ksContactAvatar @"contactAvatar"
#define ksChatAccount   @"chatAccount"
#define ksCheckInTime   @"checkInTime"
#define ksHouseTitle  @"houseTitle"
#define ksHouseId   @"houseId"
#define ksHousePubdate  @"housePubdate"
#define ksTotalPrice  @"totalPrice"
#define ksPrice  @"price"
#define ksHouseFloor  @"houseFloor"
#define ksTotalFloor  @"totalFloor"
#define ksRoomNum  @"roomNum"
#define ksWashNum   @"washNum"
#define ksHallNum   @"hallNum"
#define ksLeaseTypeCode @"leaseTypeCode"
#define ksLeaseTypeName @"leaseTypeName"
#define ksRenovationTypeCode  @"renovationTypeCode"
#define ksBuildingArea  @"buildingArea"
#define ksHouseTypeCode  @"houseTypeCode"
#define ksOrientationsCode  @"orientationsCode"
#define ksBuildingYear  @"buildingYear"
#define ksAddress  @"address"
#define ksDescription  @"description"
#define ksDesContent    @"desContent"
#define ksDESCONTENT    @"Description"
#define ksID            @"Id"
#define ksAgentName  @"agentName"
#define ksAgentMobile  @"agentMobile"
#define ksCollection    @"collection"
#define ksPayType   @"payType"
#define ksHousePic  @"housePic"
#define ksPicUrl  @"picUrl"
#define ksPicName  @"picName"
#define ksCover  @"cover"
#define ksSort  @"sort"
#define ksMerchantInfo  @"merchantInfo"
#define ksMerchantName  @"merchantName"
#define ksGpsx  @"gpsx"
#define ksGpsy  @"gpsy"
#define ksLandMarkId  @"landMarkId"
#define ksLandMarkName  @"landMarkName"
#define ksAddr  @"addr"
#define ksTenCompany  @"tenCompany"
#define ksTenFee  @"tenFee"
#define ksDevelopers  @"developers"
#define ksBusiMatching  @"busiMatching"
#define ksEduMatching  @"eduMatching"
#define ksTrafMatching  @"trafMatching"
#define ksOtherMatching  @"otherMatching"
#define ksProjectIntroduce  @"projectIntroduce"
#define ksAreaCode  @"areaCode"
#define ksAreaName  @"areaName"
#define ksCityCode  @"cityCode"
#define ksCityName  @"cityName"

//出租房屋备注
#define kId            @"id"
#define kHouseId       @"houseId"
#define kRentDate      @"rentDate"
#define kPropertyFee   @"strataFee"
#define kWaterFee      @"waterFee"
#define kPowerFee      @"powerFee"
#define kGasFee        @"gasFee"
#define kCreateDate    @"createDate"
#define kUpdateDate    @"updateDate"
#define kStrataFeeDate @"strataFeeDate"
#define kwaterFeeDate  @"waterFeeDate"
#define kPowerFeeDate  @"powerFeeDate"
#define kGasFeedate    @"gasFeeDate"
#define kStrataFeeTag  @"strataFeeTag"
#define kWaterFeeTag   @"waterFeeTag"
#define kPowerFeeTag   @"powerFeeTag"
#define kGasFeeTag     @"gasFeeTag"

#define kUnknown    @"未知"
#define kNone       @"暂无"
#define kNoName     @"未命名"
#define kUnlimited  @"不限"
#define kUnknownErr @"未知错误"


#define DEVICE_IS_IPHONE4S ([[UIScreen mainScreen] bounds].size.height == 480)


//#define DEVICE_IS_IPHONE4S \
//\
//- (BOOL)is4S \
//{ \
//    return [[UIScreen mainScreen] bounds].size.height == 480; \
//} \
//
//#if is4S
//# define kInterval   110.0//背景圆形和边缘的间隔距离
//# define kPreBtnSize 70.0 //小圆行按钮的大小
//# define topOffSet   35   //4S向上的偏移量
//#else
//# define kInterval   120.0//背景圆形和边缘的间隔距离
//# define kPreBtnSize 80.0 //小圆行按钮的大小
//# define  kTopOffSet  0    //4S向上的偏移量
//#endif


//#define kInterval 120.0 //背景圆形和边缘的间隔距离
//#define kPreBtnSize 80.0 //小圆行按钮的大小


#endif
