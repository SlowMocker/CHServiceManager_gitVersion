//
//  QiniuYunImageFileViewController.h
//  ServiceManager
//
//  Created by will.wang on 2017/2/14.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

/**
 *  1, view qiniu image file
 *  2, go to camera
 *  3, upload again
 */

#import "ViewController.h"
#import "TestViewController.h"
#import "QiniuResourceLoadManager.h"

@interface QiniuYunImageFileViewController : ViewController
//recommend showing methods
-(QiniuYunImageFileViewController*)presentViewControllerFrom:(ViewController*)srcViewController uploader:(QiniuResourceLoadManager*)uploader;
@end
