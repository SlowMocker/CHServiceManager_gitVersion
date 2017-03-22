//
//  AddComponentMaintainViewController.h
//  ServiceManager
//
//  Created by will.wang on 9/28/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "ViewController.h"

/**
 * 备件维护列表
 */

@class AddComponentMaintainViewController;

@protocol AddComponentMaintainDelegate <NSObject>
//components: 更新后的备件, ITEM: PartMaintainContent
- (void)addComponentMaintainFinished:(AddComponentMaintainViewController*)viewController updated:(NSArray*)components;
@end

@interface AddComponentMaintainViewController : ViewController
@property(nonatomic, weak)id<AddComponentMaintainDelegate>delegate;
@property(nonatomic, strong)NSArray *components; //item: PartMaintainContent,从工单详情读取，并传入
@property(nonatomic, strong)ProductModelDes *productInfo;
@property(nonatomic, strong)OrderContentDetails *orderDetails;
@end
