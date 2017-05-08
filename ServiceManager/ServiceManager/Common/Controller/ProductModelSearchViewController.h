//
//  ProductModelSearchViewController.h
//  ServiceManager
//
//  Created by will.wang on 10/20/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "ViewController.h"

typedef void (^ProductModelSelectedBlock)(ViewController *viewController, ProductModelDes *productModel);

/**
 * 机型查询
 */
@interface ProductModelSearchViewController : ViewController
@property(nonatomic, strong)ProductModelSelectedBlock modelSelectedBlock;

- (void)queryMachineModels:(NSString*)keyWords response:(RequestCallBackBlockV2)requestCallBackBlock;

@end
