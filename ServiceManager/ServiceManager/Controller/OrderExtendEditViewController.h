//
//  OrderExtendEditViewController.h
//  ServiceManager
//
//  Created by will.wang on 10/12/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

/**
 *  1, 添加或编辑延保产品
 *  2, 家多保要添加2~8件
 *  3, 单保目前只支持电视，多保可支持视、冰、空、洗
 */

#import "ViewController.h"

@interface OrderExtendEditViewController : ViewController
@property(nonatomic, assign)kExtendOrderEditMode extendOrderEditMode;
@property(nonatomic, assign)kExtendServiceType extendServiceType;
@property(nonatomic, strong)ExtendServiceOrderContent *extendOrder; //used for kExtendOrderEditModeEdit mode
@property(nonatomic, strong)OrderContentDetails *orderDetails; //used for kExtendOrderEditModeAppend
@end
