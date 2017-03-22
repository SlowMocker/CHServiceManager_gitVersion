//
//  ExtendProductEditViewController.h
//  ServiceManager
//
//  Created by will.wang on 10/13/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

/**
 * 延保产品编辑（用于家多保）
 */

#import "ViewController.h"

@interface ExtendProductEditViewController : ViewController
@property(nonatomic, strong)VoidBlock_id editFinishedBlock;
@property(nonatomic, strong)ExtendProductContent *product; //used for edit mode
@end
