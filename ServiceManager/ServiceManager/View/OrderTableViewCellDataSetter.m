//
//  OrderTableViewCellDataSetter.m
//  ServiceManager
//
//  Created by will.wang on 16/5/12.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "OrderTableViewCellDataSetter.h"

#import "OrderTableViewCell.h"

@implementation OrderTableViewCellDataSetter

+(void)setOrderContentModel:(OrderContentModel*)order toCell:(OrderTableViewCell*)cell
{
    NSString *tempStr;
    OrderItemContentView *mainView = cell.topOrderContentView;
    
    mainView.orderIdLabel.text = order.object_id;
    
    mainView.contentLabel.attributedText = [[self class]buildOrderAttrStr:order.process_type catgory:order.zzfld000003 customer:order.custname];

    BOOL bPrior = [order.priority isEqualToString:@"紧急"];
    BOOL bUrgent = [order.urgeflag isEqualToString:@"X"] && (order.urgetimes > 0);
    [mainView showPrior:bPrior showUrgent:bUrgent];

    //完工后用户星评
    NSInteger commentScoreVal = 0;
    if (1 == [order.weChatVisit integerValue]
        && 1 == [order.isComment integerValue]) {
        commentScoreVal = [order.starLevel integerValue];
    }
    mainView.starView.score = commentScoreVal/5.0;
    mainView.starView.hidden = !(commentScoreVal > 0);

    [mainView updateProductRepairTypeToViews:order.process_type];

    mainView.addressLabel.text = [Util defaultStr:@"客户地址未知" ifStrEmpty:order.customerFullAddress];

    mainView.executeNameLabel.hidden = [Util isEmptyString:order.partner_fwgname];
    mainView.executeNameLabel.text = [order.partner_fwgname truncatingTailWhenLengthGreaterThan:6];
    
    tempStr = [MiscHelper getOrderProccessStatusStrById:order.status repairerHandle:order.wxg_isreceive];
    mainView.statusLabel.attributedText = [[self class]jointStatusText:tempStr createTime:order.date_cr];

    NSDate *date;
    tempStr = nil;
    if ([order.status isEqualToString:@"SR41"]) {
        date = [Util dateWithString:order.date_yy format:WZDateStringFormat9]; //预约上门时间
    }else if ([order.status isEqualToString:@"SR46"]){
        date = [Util dateWithString:order.date_gy format:WZDateStringFormat9]; //二次预约上门时间
    }
    tempStr = [[self class]generateReadableDateText:date];
    mainView.dateLabel.hidden = [Util isEmptyString:tempStr];
    mainView.dateLabel.text = tempStr;
}

+ (NSString*)generateReadableDateText:(NSDate*)date
{
    ReturnIf(nil == date)nil;
    NSString *dateTextFmt = WZDateStringFormat7;
    if ([date isToday]) {
        dateTextFmt = WZDateStringFormat11;
    }else if([date isThisYear]){
        dateTextFmt = WZDateStringFormat8;
    }
    return [NSString dateStringWithDate:date strFormat:dateTextFmt];
}

+(NSAttributedString*)jointStatusText:(NSString*)statusText createTime:(NSString*)createTime
{
    AttributeStringAttrs *statusItem = [AttributeStringAttrs new];
    statusItem.text = statusText;
    statusItem.font = SystemFont(14);
    statusItem.textColor = kColorDefaultRed;
    
    NSMutableString *durationDays = [[NSMutableString alloc]initWithString:@" 时延:"];
    NSString *tempStr = kUnknown;
    
    if (![Util isEmptyString:createTime]) {
        NSDate *createDate = [Util dateWithString:createTime format:WZDateStringFormat9];
        NSInteger hours = [[NSDate date] hoursAfterDate:createDate];
        
        if (hours >= 24) { // > 1 day
            if (0 == hours % 24) {
                tempStr = [NSString stringWithFormat:@"%@天",@(hours/24)];
            }else {
                tempStr = [NSString stringWithFormat:@"%@天%@小时",@(hours/24), @(hours%24)];
            }
        }else if (hours >= 1) { // [1, 24) hours
            tempStr = [NSString stringWithFormat:@"%@小时",@(hours)];
        }else { // < 1 hour
            tempStr = @"1小时以内";
        }
    }
    [durationDays appendString:tempStr];

    AttributeStringAttrs *durItem = [AttributeStringAttrs new];
    durItem.text = durationDays;
    durItem.font = SystemFont(14);
    durItem.textColor = kColorDefaultBlue;
    
    return [NSString makeAttrString:@[statusItem, durItem]];
}

+(void)setLetvOrderContentModel:(LetvOrderContentModel*)order toCell:(OrderTableViewCell*)cell
{
    NSString *tempStr;
    OrderItemContentView *mainView = cell.topOrderContentView;

    mainView.orderIdLabel.text = order.objectId;

    mainView.contentLabel.attributedText = [[self class]buildOrderAttrStr:nil catgory:order.productTypeVal customer:order.name];

    BOOL bPrior = [order.priority isEqualToString:@"紧急"];
    BOOL bUrgent = [order.urgeFlag isEqualToString:@"X"] && (order.urgeTimes > 0);
    [mainView showPrior:bPrior showUrgent:bUrgent];

    BOOL bInstallOrder = [order.serviceReqType isEqualToString:@"18"];
    [mainView updateProductRepairTypeToViews:bInstallOrder?@"新":@"修"];

    mainView.addressLabel.text = [Util defaultStr:@"客户地址未知" ifStrEmpty:order.customerFullAddress];

    mainView.executeNameLabel.hidden = [Util isEmptyString:order.workerId];
    mainView.executeNameLabel.text = [order.workerName truncatingTailWhenLengthGreaterThan:6];
    mainView.executeNameLabel.adjustsFontSizeToFitWidth = YES;

    tempStr = [MiscHelper getOrderProccessStatusStrById:order.status repairerHandle:order.isReceive];
    mainView.statusLabel.attributedText = [[self class]jointStatusText:tempStr createTime:order.createTime];

    NSDate *date;
    tempStr = nil;
    if ([order.status isEqualToString:@"SR41"]) {
        date = [Util dateWithString:order.firstApptDate format:WZDateStringFormat9]; //预约上门时间
    }else if ([order.status isEqualToString:@"SR46"]){
        date = [Util dateWithString:order.lastApptDate format:WZDateStringFormat9]; //二次预约上门时间
    }
    tempStr = [[self class]generateReadableDateText:date];
    mainView.dateLabel.hidden = [Util isEmptyString:tempStr];
    mainView.dateLabel.text = tempStr;
    
    mainView.starView.hidden = YES;
}

+ (NSAttributedString*)buildOrderAttrStr:(NSString*)processType catgory:(NSString*)category customer:(NSString*)customerName
{
    NSString *tempStr;
    
    NSMutableArray *attrArray = [NSMutableArray new];

    tempStr = [Util defaultStr:@"产品未知" ifStrEmpty:category];
    AttributeStringAttrs *productAttr = [AttributeStringAttrs new];
    productAttr.text = tempStr;
    productAttr.textColor = kColorDefaultRed;
    [attrArray addObject:productAttr];

    tempStr = [customerName truncatingTailWhenLengthGreaterThan:8];
    if (![Util isEmptyString:tempStr]) {
        tempStr = [NSString stringWithFormat:@" | %@", tempStr];
        AttributeStringAttrs *clientNameAttr = [AttributeStringAttrs new];
        clientNameAttr.text = tempStr;
        clientNameAttr.textColor = [UIColor brownColor];
        [attrArray addObject:clientNameAttr];
    }
    return [NSString makeAttrString:attrArray];
}

@end
