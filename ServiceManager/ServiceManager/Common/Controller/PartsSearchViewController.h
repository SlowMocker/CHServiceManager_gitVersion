//
//  PartsSearchViewController.h
//  ServiceManager
//
//  Created by will.wang on 11/2/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "ViewController.h"

/**
 *  备件搜索
 **/

//搜索后选中某项时
typedef void (^PartSearchSelectedBlock)(ViewController *viewController, PartsContentInfo *part);


@interface PartsSearchViewController : ViewController
@property(nonatomic, strong)PartSearchSelectedBlock modelSelectedBlock;
@property(nonatomic, strong)ProductModelDes *productInfo;
@end
