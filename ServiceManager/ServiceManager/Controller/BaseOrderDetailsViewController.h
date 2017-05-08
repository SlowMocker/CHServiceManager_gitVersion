//
//  BaseOrderDetailsViewController.h
//  ServiceManager
//
//  Created by will.wang on 16/5/4.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

// 1. 子类化
// 2. 设置 detailDataSource 数据源
// 3.

#import "ViewController.h"
#import "LeftTextRightTextCell.h"
#import "WZTableView.h"

/**
 *  工单详情基类
 *  用法: 1子类化，2设置 detalsDataModel 数据源，3根据需要重写公开的方法
 */

//指定行的TAG
enum {
    kOrderDetailsItemTelTag = 0x47832,
    kOrderDetailsItemPriorityTag,
    kOrderExtendAddItemTag, //添加单品延保
    kOrderMutiExtendAddItemTag, //添加家多保
    kOrderExtendOrderDetailsItemTag, //已提交的延保单详情
    kOrderDetailsItemNoteTag //备注
};

@protocol BaseOrderDetailsVcDelegate <NSObject>
@optional

@end

@interface BaseOrderDetailsViewController : ViewController

@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)UIButton *urgeButton;/**< 催单按钮 */

//数据源，需要设置
@property(nonatomic, strong)TableViewDataHandle *detalsDataModel;

//催单按钮被点击
-(void)urgeButtonClicked:(UIButton*)sender;

//设置数据到CELL
- (UITableViewCell*)setCell:(LeftTextRightTextCell*)cell withData:(TableViewCellData*)data;

//CELL行被选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//请求工单详情数据，可以是异步的, 数据准备好后需要设置到detalsDataModel中
-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo;

//设置section 标题
- (void)setDataToHeaderLabel:(UILabel*)headerLabel inSection:(NSInteger)section;

- (void)popTextView:(NSString*)text;

@end
