//
//  OrderListViewDelegateIMP.h
//  ServiceManager
//
//  Created by will.wang on 15/8/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

/**
 * 服务商和维修工人员工单列表
 */

#import "WZTableViewDelegateIMP.h"
#import "OrderTableViewCell.h"
#import "ViewController.h"
#import "AppointmentPopMenuView.h"

@interface OrderListViewDelegateIMP : WZTableViewDelegateIMP<WZSwipeCellDelegate>

@property(nonatomic, assign)kUserRoleType userRoleType;
@property(nonatomic, assign)NSInteger orderStatus;
@property(nonatomic, strong)OrderFilterConditionItems *filterCondition;

//create order menu button model
- (MenuButtonModel *) makeMenuButtonModel:(kOrderOperationType)operateType;

- (void) do_OrderOperationTypeView:(OrderContent *)order;//查看
- (void) do_OrderOperationTypeDelete:(OrderContent *)order;//删除
- (void) do_OrderOperationTypeAgree:(OrderContent *)order;//接受
- (void) do_OrderOperationTypeRefuse:(OrderContent *)order;//拒绝
- (void) do_OrderOperationTypeAssign:(OrderContent *)order;//派工
- (void) do_OrderOperationTypeReassign:(OrderContent *)order;//改派
- (void) do_OrderOperationTypeAppointment:(OrderContent *)order;//预约
- (void) do_OrderOperationTypeChangeAppointment:(OrderContent *)order;//改约
- (void) do_OrderOperationTypeAppointmentAgain:(OrderContent*)order;//二次预约
- (void) do_OrderOperationTypeExecute:(OrderContent *)order;//执行
- (void) do_OrderOperationTypeSpecialFinish:(OrderContent *)order;//特殊完工
- (void) do_OrderOperationTypeExtend:(OrderContent*)order;   //延保
- (void) do_OrderOperationTypeLetUserComment:(OrderContent*)order; //微信点评

// 接受工单，子类需重写
- (void) agreeOrder:(OrderContent*)order response:(RequestCallBackBlock)requestCallBackBlock;

// 接收工单时的附加提示语
- (NSString *) getExNoteStrWhenAgreeingOrder:(OrderContent*)order;

// 拒绝工单，子类需重写
- (void) refuseOrder:(OrderContent*)order reason:(CheckItemModel*)reason response:(RequestCallBackBlock)requestCallBackBlock;

// 预约工单时的弹出选择框数据设置，子类需重写
- (void) setAppointmentPopMenuView:(AppointmentPopMenuView*)menuView with:(OrderContent*)orderContent;

// 预约成功，子类需重写
- (void) gotoAppointmentViewController:(NSString*)title order:(OrderContent*)orderContent type:(kAppointmentOperateType)appointType;

- (void) refuseOrder:(OrderContent*)order reason:(CheckItemModel*)reason;

@end
