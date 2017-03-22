//
//  WeixinCommentQrCodeViewController.h
//  ServiceManager
//
//  Created by will.wang on 2017/2/10.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

/**
 * 微信点评二纬码展示页面，从服务端取得二纬码数据，生成二纬码，供用户扫码评论
 */

#import "ViewController.h"

@interface WeixinCommentQrCodeViewController : ViewController
@property(nonatomic, strong)NSString *orderId;
@end
