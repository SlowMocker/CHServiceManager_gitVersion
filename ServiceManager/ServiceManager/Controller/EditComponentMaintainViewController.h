//
//  EditComponentMaintainViewController.h
//  ServiceManager
//
//  Created by will.wang on 2/17/16.
//  Copyright © 2016 wangzhi. All rights reserved.
//

#import "ViewController.h"

@protocol EditComponentMaintainVCDelegate <NSObject>
- (void)componentMaintainEditCellDidEdit:(PartMaintainContent*)part;
@end

@interface EditComponentMaintainViewController : ViewController
@property(nonatomic, strong)NSArray *componentArray; //item: PartMaintainContent,从工单详情读取，并传入
@property(nonatomic, strong)ProductModelDes *productInfo;
@property(nonatomic, strong)PartMaintainContent *maintainContent;
@property(nonatomic, strong)OrderContentDetails *orderDetails;
@property(nonatomic, assign)id<EditComponentMaintainVCDelegate>delegate;
@end
