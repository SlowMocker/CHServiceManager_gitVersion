//
//  MachineComponEditCell.h
//  ServiceManager
//
//  Created by will.wang on 15/9/16.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MachineComponEditCell : UITableViewCell
@property(nonatomic, weak)ViewController *viewController;

@property(nonatomic, strong)UIButton *componTypeSelBtn;
@property(nonatomic, strong)UITextField *priceTextField;

@property(nonatomic, strong)UIButton *increaseBtn;
@property(nonatomic, strong)UITextField *componCountTextField;
@property(nonatomic, strong)UIButton *decreaseBtn;

@property(nonatomic, strong)UIButton *addBtn;
@property(nonatomic, strong)UIButton *deleteBtn;

// if show the bottom add and remove buttons line or not
@property(nonatomic, assign)BOOL showAddRemoveButtonsLine;

//default value is 1
@property(nonatomic, assign)NSInteger componCount;
@property(nonatomic, assign)NSInteger minCount;
@property(nonatomic, assign)NSInteger maxCount;

@property(nonatomic, strong)CheckItemModel *typeItem;
@property(nonatomic, strong)CheckItemModel *subTypeItem;

//get cell height, 
- (CGFloat)fitHeight;

//set data
@property(nonatomic, strong)AdditionalBusinessItem *additonalItem;

- (NSString*)checkInput;

@end
